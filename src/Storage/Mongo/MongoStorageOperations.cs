﻿// --------------------------------------------------------------------------------------------------------------------
// <copyright file="MongoStorageOperations.cs" company="SoftChains">
//   Copyright 2016 Dan Gershony
//   //  Licensed under the MIT license. See LICENSE file in the project root for full license information.
//   //  THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, 
//   //  EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES 
//   //  OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
// </copyright>
// --------------------------------------------------------------------------------------------------------------------

namespace Nako.Storage.Mongo
{
    #region Using Directives

    using System;
    using System.Collections.Generic;
    using System.Linq;

    using MongoDB.Driver;

    using Nako.Client.Types;
    using Nako.Config;
    using Nako.Extensions;
    using Nako.Operations;
    using Nako.Operations.Types;
    using Nako.Storage.Mongo.Types;
    using Nako.Storage.Types;
    using Nako.Sync;

    #endregion

    /// <summary>
    /// The CoinOperations interface.
    /// </summary>
    public class MongoStorageOperations : IStorageOperations
    {
        /// <summary>
        /// The storage.
        /// </summary>
        private readonly IStorage storage;

        /// <summary>
        /// The tracer.
        /// </summary>
        private readonly Tracer tracer;

        /// <summary>
        /// The configuration.
        /// </summary>
        private readonly NakoConfiguration configuration;

        /// <summary>
        /// The data.
        /// </summary>
        private readonly MongoData data;

        /// <summary>
        /// Initializes a new instance of the <see cref="MongoStorageOperations"/> class.
        /// </summary>
        /// <param name="storage">
        /// The storage.
        /// </param>
        /// <param name="mongoData">
        /// The mongo Data.
        /// </param>
        /// <param name="tracer">
        /// The tracer.
        /// </param>
        /// <param name="nakoConfiguration">
        /// The Configuration.
        /// </param>
        public MongoStorageOperations(IStorage storage, MongoData mongoData, Tracer tracer, NakoConfiguration nakoConfiguration)
        {
            this.data = mongoData;
            this.configuration = nakoConfiguration;
            this.tracer = tracer;
            this.storage = storage;
        }

        #region Public Methods and Operators

        /// <summary>
        /// The validate block.
        /// </summary>
        /// <param name="item">
        /// The item.
        /// </param>
        public void ValidateBlock(SyncBlockTransactionsOperation item)
        {
            if (item.BlockInfo != null)
            {
                var lastBlock = this.storage.BlockGetBlockCount(1).FirstOrDefault();

                if (lastBlock != null)
                {
                    if (lastBlock.BlockHash == item.BlockInfo.Hash)
                    {
                        if (lastBlock.SyncComplete)
                        {
                            throw new ApplicationException("This should never happen.");
                        }
                    }
                    else
                    {
                        if (item.BlockInfo.PreviousBlockHash != lastBlock.BlockHash)
                        {
                            this.InvalidBlockFound(lastBlock, item);
                            return;
                        }

                        this.CreateBlock(item.BlockInfo);

                        ////if (string.IsNullOrEmpty(lastBlock.NextBlockHash))
                        ////{
                        ////    lastBlock.NextBlockHash = item.BlockInfo.Hash;
                        ////    this.SyncOperations.UpdateBlockHash(lastBlock);
                        ////}
                    }
                }
                else
                {
                    this.CreateBlock(item.BlockInfo);
                }
            }
        }

        /// <summary>
        /// The insert transactions.
        /// </summary>
        /// <param name="item">
        /// The item.
        /// </param>
        /// <returns>
        /// The <see cref="int"/>.
        /// </returns>
        public InsertStats InsertTransactions(SyncBlockTransactionsOperation item)
        {
            var stats = new InsertStats { Items = new List<MapTransactionAddress>() };

            if (item.BlockInfo != null)
            {
                // remove all transactions from the memory pool
                item.Transactions.ForEach(t =>
                    {
                        DecodedRawTransaction outer;
                        this.data.MemoryTransactions.TryRemove(t.TxId, out outer);
                    });

                // break the work in to batches of 1000 transactions per batch
                var queue = new Queue<DecodedRawTransaction>(item.Transactions);
                do
                {
                    var items = this.GetTransactionBatch(1000, queue).ToList();

                    try
                    {
                        if (item.BlockInfo != null)
                        {
                            var inserts = items.Select(s => new MapTransactionBlock { BlockIndex = item.BlockInfo.Height, TransactionId = s.TxId }).ToList();

                            this.data.MapTransactionBlock.InsertMany(inserts, new InsertManyOptions { IsOrdered = false });

                            stats.Transactions += inserts.Count();
                        }
                    }
                    catch (MongoBulkWriteException mbwex)
                    {
                        if (!mbwex.Message.Contains("E11000 duplicate key error collection"))
                        {
                            throw;
                        }
                    }

                    try
                    {
                        var inputs = this.CreateInputs(item.BlockInfo.Height, items).ToList();
                        this.data.MapTransactionAddress.InsertMany(inputs, new InsertManyOptions { IsOrdered = false });
                        stats.Inputs += inputs.Count();

                        // add to the list for later to use on the notification task.
                        stats.Items.AddRange(inputs);
                    }
                    catch (MongoBulkWriteException mbwex)
                    {
                        if (!mbwex.Message.Contains("E11000 duplicate key error collection"))
                        {
                            throw;
                        }
                    }

                    var outputs = this.CreateOutputs(items).ToList();
                    outputs.ForEach(outp => this.data.MarkOutput(outp.InputTransactionId, outp.InputIndex, outp.TransactionId));
                    stats.Outputs += outputs.Count();
                }
                while (queue.Any());

                // mark the block as synced.
                this.CompleteBlock(item.BlockInfo);
            }
            else
            {
                // memory transaction push in to the pool.
                item.Transactions.ForEach(t =>
                {
                    this.data.MemoryTransactions.TryAdd(t.TxId, t);
                });

                stats.Transactions = this.data.MemoryTransactions.Count();

                // todo: for accuracy - remove transactions from the mongo memory pool that are not anymore in the syncing pool
                // remove all transactions from the memory pool
                // this can be done using the SyncingBlocks objects - see method SyncOperations.FindPoolInternal()

                // add to the list for later to use on the notification task.
                var inputs = this.CreateInputs(-1, item.Transactions).ToList();
                stats.Items.AddRange(inputs);
            }

            return stats;
        }
        
        #endregion

        /// <summary>
        /// The complete block.
        /// </summary>
        /// <param name="block">
        /// The block.
        /// </param>
        private void CompleteBlock(BlockInfo block)
        {
            this.data.CompleteBlock(block.Hash);
        }

        /// <summary>
        /// The complete block.
        /// </summary>
        /// <param name="block">
        /// The block.
        /// </param>
        private void CreateBlock(BlockInfo block)
        {
            var blockInfo = new MapBlock
            {
                BlockIndex = block.Height, 
                BlockHash = block.Hash, 
                BlockSize = block.Size, 
                BlockTime = block.Time, 
                NextBlockHash = block.NextBlockHash, 
                PreviousBlockHash = block.PreviousBlockHash, 
                TransactionCount = block.Transactions.Count(), 
                SyncComplete = false
            };

            this.data.InsertBlock(blockInfo);
        }

        /// <summary>
        /// Gets a batch of transactions.
        /// </summary>
        /// <param name="maxItems">
        /// The max Items.
        /// </param>
        /// <param name="queue">
        /// The transaction queue.
        /// </param>
        /// <returns>
        /// A batch of transactions.
        /// </returns>
        private IEnumerable<DecodedRawTransaction> GetTransactionBatch(int maxItems, Queue<DecodedRawTransaction> queue)
        {
            var total = 0;
            var items = new List<DecodedRawTransaction>();

            do
            {
                var aggregate = Extensions.TakeAndRemove(queue, 100).ToList();

                items.AddRange(aggregate);

                total = items.SelectMany(s => s.VIn).Cast<object>().Concat(items.SelectMany(s => s.VOut).Cast<object>()).Count();
            }
            while (total < maxItems && queue.Any());

            return items;
        }

        /// <summary>
        /// The invalid block found.
        /// </summary>
        /// <param name="lastBlock">
        /// The last block.
        /// </param>
        /// <param name="item">
        /// The item.
        /// </param>
        private void InvalidBlockFound(SyncBlockInfo lastBlock, SyncBlockTransactionsOperation item)
        {
            // Re-org happened.
            throw new SyncRestartException();
        }

        /// <summary>
        /// The create transaction inserts.
        /// </summary>
        /// <param name="block">
        /// The block.
        /// </param>
        /// <param name="transactions">
        /// The transactions.
        /// </param>
        /// <returns>
        /// The collection.
        /// </returns>
        private IEnumerable<SyncTransactionInfo> CreateTransactions(BlockInfo block, IEnumerable<DecodedRawTransaction> transactions)
        {
            var trxInfps = transactions.Select(trx => new SyncTransactionInfo
            {
                TransactionHash = trx.TxId, 
                Timestamp = block == null ? UnixUtils.DateToUnixTimestamp(DateTime.UtcNow) : block.Time
            });

            return trxInfps;
        }

        /// <summary>
        /// The create transaction inserts.
        /// </summary>
        /// <param name="blockIndex">
        /// The blockIndex.
        /// </param>
        /// <param name="transactions">
        /// The block.
        /// </param>
        /// <returns>
        /// The collection.
        /// </returns>
        private IEnumerable<MapTransactionAddress> CreateInputs(long blockIndex, IEnumerable<DecodedRawTransaction> transactions)
        {
            foreach (var transaction in transactions)
            {
                var rawTransaction = transaction;
                var coinBase = rawTransaction.VIn.Any(v => v.CoinBase != null);

                var transactionOutputs = from output in rawTransaction.VOut
                                         where output.Value >= 0
                                                 && output.ScriptPubKey != null
                                                 && output.ScriptPubKey.Addresses != null
                                                 && output.ScriptPubKey.Addresses.Any()
                                         select new MapTransactionAddress
                                         {
                                             Id = string.Format("{0}-{1}", rawTransaction.TxId, output.N), 
                                             TransactionId = rawTransaction.TxId, 
                                             Value = Convert.ToDouble(output.Value), 
                                             Index = output.N, 
                                             Addresses = output.ScriptPubKey.Addresses, 
                                             ScriptHex = output.ScriptPubKey.Hex, 
                                             BlockIndex = blockIndex, 
                                             CoinBase = coinBase
                                         };

                foreach (var output in transactionOutputs)
                {
                    yield return output;
                }
            }
        }

        /// <summary>
        /// The create outputs.
        /// </summary>
        /// <param name="transactions">
        /// The transactions.
        /// </param>
        /// <returns>
        /// The dynamic.
        /// </returns>
        private IEnumerable<dynamic> CreateOutputs(IEnumerable<DecodedRawTransaction> transactions)
        {
            foreach (var transaction in transactions)
            {
                var rawTransaction = transaction;

                var transactionInputs = from input in transaction.VIn ////.Select((vin, index) => new { Item = vin, Index = index })
                                        where input.TxId != null
                                        select new
                                        {
                                            TransactionId = rawTransaction.TxId, 
                                            InputTransactionId = input.TxId, 
                                            InputIndex = input.VOut
                                        };

                foreach (var input in transactionInputs)
                {
                    yield return input;
                }
            }
        }
    }
}
