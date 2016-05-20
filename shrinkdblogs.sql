-- Every SQL Server database has a transaction log that records all transactions and the database modifications made by each transaction. The transaction log is a critical component of the database and, if there is a system failure, the transaction log might be required to bring your database back to a consistent state.

-- As the number of transactions starts increasing, however, space availability starts becoming a major concern. Fortunately, SQL Server allows you to reclaim the excess space by reducing the size of the transaction log.

-- While you can shrink log files manually, one at a time using the UI provided, who has the time to do this manually? The following script can be used to shrink multiple database log files rapidly.

DECLARE @logName as nvarchar(50)
DECLARE @databaseID as int

DECLARE db_cursor CURSOR FOR
SELECT TOP 10 name,database_id -- only 10 but you can choose any number
FROM sys.master_Files WHERE physical_name like '%.ldf'
and physical_name not like '/data/db/'  -- specify your database paths
and name not in ('somelog') -- any database logs that you would like to exclude
ORDER BY size DESC

OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @logName , @databaseID

WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @databaseName as nvarchar(50)
 SET @databaseName =  DB_NAME(@databaseID)

  DECLARE @tsql nvarchar(300)
 SET @tsql='USE ['+@databaseName+'] ALTER DATABASE ['+@databaseName+'] set recovery simple DBCC SHRINKFILE ('+@logName+' , 1)'
 EXEC(@tsql)

    FETCH NEXT FROM db_cursor INTO @logName , @databaseID
END
CLOSE db_cursor
DEALLOCATE db_cursor
