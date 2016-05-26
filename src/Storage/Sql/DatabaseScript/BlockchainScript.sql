USE [master]
GO
/****** Object:  Database [Blockchain]    Script Date: 1/9/2015 11:46:53 AM ******/
CREATE DATABASE [Blockchain]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Blockchain', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Blockchain.mdf' , SIZE = 50004KB , MAXSIZE = UNLIMITED, FILEGROWTH = 524288KB )
 LOG ON 
( NAME = N'Blockchain_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\Blockchain_log.ldf' , SIZE = 504KB , MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
GO
ALTER DATABASE [Blockchain] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Blockchain].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Blockchain] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Blockchain] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Blockchain] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Blockchain] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Blockchain] SET ARITHABORT OFF 
GO
ALTER DATABASE [Blockchain] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Blockchain] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Blockchain] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Blockchain] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Blockchain] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Blockchain] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Blockchain] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Blockchain] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Blockchain] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Blockchain] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Blockchain] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Blockchain] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Blockchain] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Blockchain] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Blockchain] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Blockchain] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Blockchain] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Blockchain] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Blockchain] SET  MULTI_USER 
GO
ALTER DATABASE [Blockchain] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Blockchain] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Blockchain] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Blockchain] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [Blockchain] SET DELAYED_DURABILITY = DISABLED 
GO
USE [Blockchain]
GO
/****** Object:  Schema [Blocks]    Script Date: 1/9/2015 11:47:00 AM ******/
CREATE SCHEMA [Blocks]
GO
/****** Object:  Schema [Chains]    Script Date: 1/9/2015 11:47:00 AM ******/
CREATE SCHEMA [Chains]
GO
/****** Object:  Table [Blocks].[Block]    Script Date: 1/9/2015 11:47:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Blocks].[Block](
	[BlockIndex] [bigint] NOT NULL,
	[BlockHash] [varchar](200) NULL,
	[NextBlockHash] [varchar](200) NULL,
	[PreviousBlockHash] [varchar](200) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Blocks].[BlockDetail]    Script Date: 1/9/2015 11:47:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Blocks].[BlockDetail](
	[BlockIndex] [bigint] NOT NULL,
	[BlockTime] [bigint] NOT NULL,
	[SyncComplete] [bit] NOT NULL,
	[TransactionCount] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [Blocks].[BlockTransaction]    Script Date: 1/9/2015 11:47:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Blocks].[BlockTransaction](
	[TransactionId] [bigint] NOT NULL,
	[BlockIndex] [bigint] NOT NULL,
	[TransactionCode] [varchar](200) NOT NULL,
	[Timestamp] [datetime2](7) NOT NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Blocks]    Script Date: 1/9/2015 11:47:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Blocks](
	[BlockHash] [varchar](200) NOT NULL,
	[BlockIndex] [bigint] NOT NULL,
	[BlockSize] [bigint] NOT NULL,
	[BlockTime] [bigint] NOT NULL,
	[NextBlockHash] [varchar](200) NULL,
	[PreviousBlockHash] [varchar](200) NOT NULL,
	[SyncComplete] [bit] NOT NULL,
	[TransactionCount] [int] NOT NULL,
 CONSTRAINT [PK_Blocks] PRIMARY KEY CLUSTERED 
(
	[BlockHash] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[BlockTransactions]    Script Date: 1/9/2015 11:47:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BlockTransactions](
	[BlockHash] [varchar](200) NOT NULL,
	[BlockIndex] [bigint] NOT NULL,
	[TransactionId] [varchar](200) NOT NULL,
	[Timestamp] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_BlockTransactions] PRIMARY KEY CLUSTERED 
(
	[TransactionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[BlockTransactionsIntermediary]    Script Date: 1/9/2015 11:47:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BlockTransactionsIntermediary](
	[BlockHash] [varchar](200) NOT NULL,
	[BlockIndex] [bigint] NOT NULL,
	[TransactionId] [varchar](200) NOT NULL,
	[Timestamp] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_BlockTransactionsIntermediary] PRIMARY KEY CLUSTERED 
(
	[BlockHash] ASC,
	[TransactionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Transactions]    Script Date: 1/9/2015 11:47:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Transactions](
	[TransactionId] [varchar](200) NOT NULL,
	[Index] [int] NOT NULL,
	[IndexType] [int] NOT NULL,
	[Timestamp] [datetime2](7) NOT NULL,
	[InputCoinBase] [varchar](200) NULL,
	[InputIndex] [int] NULL,
	[InputTransactionId] [varchar](200) NULL,
	[InputAddress] [varchar](200) NULL,
	[InputValue] [decimal](18, 8) NULL,
	[OutputAddress] [varchar](200) NULL,
	[OutputType] [varchar](32) NULL,
	[OutputValue] [decimal](18, 8) NULL,
	[OutputSpent] [bit] NULL,
	[OutputSpentTransactionId] [varchar](200) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TransactionsIntermediary]    Script Date: 1/9/2015 11:47:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TransactionsIntermediary](
	[TransactionId] [varchar](200) NOT NULL,
	[Index] [int] NOT NULL,
	[IndexType] [int] NOT NULL,
	[Timestamp] [datetime2](7) NOT NULL,
	[InputCoinBase] [varchar](200) NULL,
	[InputIndex] [int] NULL,
	[InputTransactionId] [varchar](200) NULL,
	[InputAddress] [varchar](200) NULL,
	[InputValue] [decimal](18, 8) NULL,
	[OutputAddress] [varchar](200) NULL,
	[OutputType] [varchar](32) NULL,
	[OutputValue] [decimal](18, 8) NULL,
 CONSTRAINT [PK_TransactionsIntermediary] PRIMARY KEY CLUSTERED 
(
	[TransactionId] ASC,
	[Index] ASC,
	[IndexType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Index [IX_Blocks]    Script Date: 1/9/2015 11:47:01 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Blocks] ON [dbo].[Blocks]
(
	[BlockIndex] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Blocks_Hash]    Script Date: 1/9/2015 11:47:01 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Blocks_Hash] ON [dbo].[Blocks]
(
	[BlockHash] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [NonClusteredIndex-20141222-223818]    Script Date: 1/9/2015 11:47:01 AM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20141222-223818] ON [dbo].[BlockTransactions]
(
	[TransactionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [NonClusteredIndex-20141222-140628]    Script Date: 1/9/2015 11:47:01 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [NonClusteredIndex-20141222-140628] ON [dbo].[Transactions]
(
	[TransactionId] ASC,
	[Index] ASC,
	[IndexType] ASC
)
INCLUDE ( 	[OutputSpent]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [NonClusteredIndex-20141222-225314]    Script Date: 1/9/2015 11:47:01 AM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20141222-225314] ON [dbo].[Transactions]
(
	[OutputAddress] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[BlocksGetByHash]    Script Date: 1/9/2015 11:47:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[BlocksGetByHash] 
     @BlockHash varchar(200)
AS 
	SET NOCOUNT ON 
	
	SELECT

		[BlockHash], 
		[BlockIndex], 
		[BlockSize], 
		[BlockTime], 
		[NextBlockHash], 
		[PreviousBlockHash], 
		[SyncComplete], 
		[TransactionCount] 
	FROM   [dbo].[Blocks] 
	 WHERE  [BlockHash] = @BlockHash
	



GO
/****** Object:  StoredProcedure [dbo].[BlocksGetTop]    Script Date: 1/9/2015 11:47:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[BlocksGetTop] 
    @Count int
AS 
	SET NOCOUNT ON 
	
	SELECT top(@Count)

		[BlockHash], 
		[BlockIndex], 
		[BlockSize], 
		[BlockTime], 
		[NextBlockHash], 
		[PreviousBlockHash], 
		[SyncComplete], 
		[TransactionCount] 
	FROM   [dbo].[Blocks] 
	 ORDER BY [BlockIndex] desc



GO
/****** Object:  StoredProcedure [dbo].[BlocksInsertOrUpdate]    Script Date: 1/9/2015 11:47:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[BlocksInsertOrUpdate] 
    @BlockHash varchar(64),
    @BlockIndex bigint,
    @BlockSize bigint,
    @BlockTime bigint,
    @NextBlockHash varchar(64) = NULL,
    @PreviousBlockHash varchar(64),
    @SyncComplete bit,
    @TransactionCount int
AS 
	SET NOCOUNT ON 
	
	MERGE [dbo].[Blocks] AS TARGET
		
		USING
			 (SELECT 
				@BlockHash,
				@BlockIndex,
				@BlockSize,
				@BlockTime,
				@TransactionCount,
				@NextBlockHash,
				@PreviousBlockHash,
				@SyncComplete) as source
				
				([BlockHash]
				,[BlockIndex]
				,[BlockSize]
				,[BlockTime]
				,[NextBlockHash]
			    ,[PreviousBlockHash]
			    ,[SyncComplete]
			    ,[TransactionCount])
		
		ON TARGET.BlockHash = @BlockHash
		
		WHEN MATCHED THEN
		UPDATE SET
		
				[BlockHash] = @BlockHash, 
				[BlockIndex] = @BlockIndex,
				[BlockSize] = @BlockSize, 
				[BlockTime] = @BlockTime, 
				[NextBlockHash] = @NextBlockHash, 
				[PreviousBlockHash] = @PreviousBlockHash, 
				[SyncComplete] = @SyncComplete, 
				[TransactionCount] = @TransactionCount
			
 		WHEN NOT MATCHED THEN
	
 			INSERT 
				([BlockHash], 
				[BlockIndex], 
				[BlockSize], 
				[BlockTime], 
				[NextBlockHash], 
				[PreviousBlockHash], 
				[SyncComplete], 
				[TransactionCount])
				
			VALUES
				(@BlockHash, 
				 @BlockIndex, 
				 @BlockSize, 
				 @BlockTime, 
				 @NextBlockHash, 
			     @PreviousBlockHash, 
				 @SyncComplete, 
				 @TransactionCount);

GO
/****** Object:  StoredProcedure [dbo].[BlockTransactionsGetByBlock]    Script Date: 1/9/2015 11:47:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[BlockTransactionsGetByBlock] 
    @BlockHash varchar(200)
  
AS 
	SET NOCOUNT ON 

	SELECT 
	   
	   [BlockHash]
      ,[BlockIndex]
      ,[TransactionId]
      ,[Timestamp]
  
  FROM [dbo].[BlockTransactions]
		
		WHERE  [BlockHash] = @BlockHash 
     	 



GO
/****** Object:  StoredProcedure [dbo].[BlockTransactionsInsertOrUpdate]    Script Date: 1/9/2015 11:47:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[BlockTransactionsInsertOrUpdate] 
    @BlockHash varchar(64),
    @TransactionId varchar(64),
    @BlockIndex bigint,
    @Timestamp datetime2(7)
AS 
	SET NOCOUNT ON 
	
	MERGE [dbo].[BlockTransactions] AS TARGET
		
		USING
			 (SELECT 
				@BlockHash,
				@BlockIndex,
				@Timestamp,
				@TransactionId) as source
				
				([BlockHash]
				,[BlockIndex]
				,[TransactionId]
				,[Timestamp])
		
		ON  TARGET.BlockHash = @BlockHash
		AND TARGET.[TransactionId] = @TransactionId
		WHEN MATCHED THEN
		UPDATE SET
		
				[BlockHash] = @BlockHash, 
				[BlockIndex] = @BlockIndex,
				[TransactionId] = @TransactionId, 
				[Timestamp] = @Timestamp
			
 		WHEN NOT MATCHED THEN
	
 			INSERT 
				([BlockHash], 
				[BlockIndex], 
				[TransactionId], 
				[Timestamp])
				
			VALUES
				(@BlockHash, 
				 @BlockIndex, 
				 @TransactionId, 
				 @Timestamp);

GO
/****** Object:  StoredProcedure [dbo].[BlockTransactionsIntermediaryInsert]    Script Date: 1/9/2015 11:47:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[BlockTransactionsIntermediaryInsert] 
AS 
	SET NOCOUNT ON 
	
		MERGE INTO [dbo].[BlockTransactions] AS TARGET
		USING [dbo].[BlockTransactionsIntermediary] AS SOURCE
				ON  TARGET.[BlockHash] = SOURCE.[BlockHash]
				AND TARGET.[TransactionId] = SOURCE.[TransactionId]
		WHEN NOT MATCHED THEN
 			INSERT 
				([BlockHash], 
				[BlockIndex], 
				[TransactionId], 
				[Timestamp])
				
			VALUES
				(SOURCE.[BlockHash], 
				 SOURCE.[BlockIndex], 
				 SOURCE.[TransactionId], 
				 SOURCE.[Timestamp]);
	
	
				
	

GO
/****** Object:  StoredProcedure [dbo].[BlockTransactionsSelect]    Script Date: 1/9/2015 11:47:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[BlockTransactionsSelect] 
    @TransactionId varchar(200)
  
AS 
	SET NOCOUNT ON 

	SELECT 
	   
	   [BlockHash]
      ,[BlockIndex]
      ,[TransactionId]
      ,[Timestamp]
  
  FROM [dbo].[BlockTransactions]
	
		
		WHERE  [TransactionId] = @TransactionId 
     	 



GO
/****** Object:  StoredProcedure [dbo].[TransactionGetByAddress]    Script Date: 1/9/2015 11:47:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[TransactionGetByAddress] 
    @Address varchar(200)
  
AS 
	SET NOCOUNT ON 

	SELECT [TransactionId]
      ,[Index]
      ,[IndexType]
      ,[Timestamp]
      ,[InputCoinBase]
      ,[InputIndex]
      ,[InputTransactionId]
      ,[InputAddress]
      ,[InputValue]
      ,[OutputAddress]
      ,[OutputType]
      ,[OutputValue]
      ,[OutputSpent]
      ,[OutputSpentTransactionId]
  FROM [dbo].[Transactions]

		WHERE  [OutputAddress] = @Address --[InputAddress] = @Address or 
     	 



GO
/****** Object:  StoredProcedure [dbo].[TransactionsInsertOrUpdate]    Script Date: 1/9/2015 11:47:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[TransactionsInsertOrUpdate] 
    @TransactionId varchar(64),
    @Index int,
    @IndexType int,
    @Timestamp datetime2(7),
    @InputCoinBase varchar(64) = NULL,
    @InputIndex int = NULL,
    @InputTransactionId varchar(64) = NULL,
    @InputAddress varchar(64) = NULL,
    @InputValue decimal(18, 8) = NULL,
    @OutputAddress varchar(64) = NULL,
    @OutputType varchar(32) = NULL,
    @OutputValue decimal(18, 8) = NULL
AS 
	SET NOCOUNT ON 
	
	MERGE [dbo].[Transactions] AS TARGET
		
		USING
			 (SELECT 
				@TransactionId,
				@Index,
				@IndexType,
				@Timestamp,
				@InputCoinBase,
				@InputIndex,
				@InputTransactionId,
				@InputAddress,
				@InputValue,
				@OutputAddress,
				@OutputType,
				@OutputValue) as source
				
				([TransactionId]
				,[Index]
				,[IndexType]
				,[Timestamp]
				,[InputCoinBase]
				,[InputIndex]
				,[InputTransactionId]
				,[InputAddress]
				,[InputValue]
				,[OutputAddress]
				,[OutputType]
				,[OutputValue])
		
		   ON	TARGET.[TransactionId] = @TransactionId
			AND TARGET.[Index] = @Index
			AND TARGET.[IndexType] = @IndexType
		
		--WHEN MATCHED THEN
		
		--UPDATE SET
		--		[TransactionId] = @TransactionId, 
		--		[Index] = @Index, 
		--		[IndexType] = @IndexType, 
		--		[Timestamp] = @Timestamp, 
		--		[InputCoinBase] = @InputCoinBase, 
				--[InputIndex] = @InputIndex, 
				--[InputTransactionId] = @InputTransactionId, 
				--[InputAddress] = @InputAddress, 
				--[InputValue] = @InputValue, 
				--[OutputAddress] = @OutputAddress, 
				--[OutputType] = @OutputType, 
				--[OutputValue] = @OutputValue
			
 		WHEN NOT MATCHED THEN
	
 			INSERT 
				 ([TransactionId], 
				 [Index], 
				 [IndexType], 
				 [Timestamp], 
			     [InputCoinBase], 
				 [InputIndex], 
				 [InputTransactionId], 
				 [InputAddress], 
				 [InputValue], 
				 [OutputAddress], 
				 [OutputType], 
				 [OutputValue])

				VALUES 
				   (@TransactionId, 
					@Index, 
					@IndexType, 
					@Timestamp, 
					@InputCoinBase, 
					@InputIndex, 
					@InputTransactionId, 
					@InputAddress, 
					@InputValue, 
					@OutputAddress, 
					@OutputType, 
					@OutputValue);

				
	

GO
/****** Object:  StoredProcedure [dbo].[TransactionsIntermediaryInsert]    Script Date: 1/9/2015 11:47:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[TransactionsIntermediaryInsert] 
AS 
	SET NOCOUNT ON 
	
		MERGE INTO [dbo].[Transactions] AS TARGET
		USING [dbo].[TransactionsIntermediary] AS  SOURCE
			ON	TARGET.[TransactionId] = SOURCE.[TransactionId]
			AND TARGET.[Index] = SOURCE.[Index]
			AND TARGET.[IndexType] = SOURCE.[IndexType] 
		WHEN NOT MATCHED THEN
 			INSERT 
				 ([TransactionId], 
				 [Index], 
				 [IndexType], 
				 [Timestamp], 
			     [InputCoinBase], 
				 [InputIndex], 
				 [InputTransactionId], 
				 [InputAddress], 
				 [InputValue], 
				 [OutputAddress], 
				 [OutputType], 
				 [OutputValue])
				VALUES 
				   (SOURCE.[TransactionId], 
					SOURCE.[Index], 
					SOURCE.[IndexType], 
					SOURCE.[Timestamp], 
					SOURCE.[InputCoinBase], 
					SOURCE.[InputIndex], 
					SOURCE.[InputTransactionId], 
					SOURCE.[InputAddress], 
					SOURCE.[InputValue], 
					SOURCE.[OutputAddress], 
					SOURCE.[OutputType], 
					SOURCE.[OutputValue]);
	
	
				
	

GO
/****** Object:  StoredProcedure [dbo].[TransactionsIntermediaryMergeInsert]    Script Date: 1/9/2015 11:47:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[TransactionsIntermediaryMergeInsert] 
AS 
	SET NOCOUNT ON 
	
	

		MERGE INTO [dbo].[Transactions] AS TARGET
		USING 
			(SELECT 
				t.[Index] as [TIndex], 
				t.[IndexType] as [TIndexType],
				t.[TransactionId] as [TTransactionId],
				t.[OutputSpent] as [TOutputSpent],
				t.[OutputSpentTransactionId] as [TOutputSpentTransactionId],
				ti.[InputIndex] as [TIInputIndex],
				ti.[InputTransactionId] as [TIInputTransactionId],
				ti.[TransactionId] as [TITransactionId]
				
				  FROM [dbo].[Transactions] t
							 INNER JOIN [dbo].[TransactionsIntermediary] ti
							 ON t.[TransactionId] = ti.[InputTransactionId]
							 AND  t.[OutputSpent] IS NULL
							 AND t.[Index] = ti.[InputIndex]
							 AND t.[IndexType] = 1
							 AND ti.[IndexType] = 0) AS  SOURCE
			
			ON	TARGET.[TransactionId] = SOURCE.[TTransactionId]
			AND TARGET.[Index] = SOURCE.[TIndex]
			AND TARGET.[IndexType] = SOURCE.[TIndexType]
	
	WHEN MATCHED THEN
	
 			UPDATE SET 
 			
			[OutputSpent] = 1,
			[OutputSpentTransactionId] = SOURCE.[TITransactionId];
		
			
	
	
				
	


GO
/****** Object:  StoredProcedure [dbo].[TransactionsSelect]    Script Date: 1/9/2015 11:47:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[TransactionsSelect] 
    @TransactionId varchar(200)
  
AS 
	SET NOCOUNT ON 


	SELECT 
	
		[TransactionId], 
		[Index], 
		[IndexType], 
		[Timestamp], 
		[InputCoinBase], 
		[InputIndex], 
		[InputTransactionId], 
		[InputAddress], 
		[InputValue],
		[OutputAddress], 
		[OutputType], 
		[OutputValue], 
		[OutputSpent],
		[OutputSpentTransactionId]
	FROM   [dbo].[Transactions] 
		
		WHERE  [TransactionId] = @TransactionId 
     	 



GO
/****** Object:  StoredProcedure [dbo].[TransactionsSelectByIndex]    Script Date: 1/9/2015 11:47:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[TransactionsSelectByIndex] 
    @TransactionId varchar(200),
    @Index int,
    @IndexType int
AS 
	SET NOCOUNT ON 


	SELECT 
	
		[TransactionId], 
		[Index], 
		[IndexType], 
		[Timestamp], 
		[InputCoinBase], 
		[InputIndex], 
		[InputTransactionId], 
		[InputAddress], 
		[InputValue],
		[OutputAddress], 
		[OutputType], 
		[OutputValue] 
	
	FROM   [dbo].[Transactions] 
		
		WHERE  [TransactionId] = @TransactionId 
     	   AND [Index] = @Index  
		   AND [IndexType] = @IndexType 



GO
USE [master]
GO
ALTER DATABASE [Blockchain] SET  READ_WRITE 
GO
