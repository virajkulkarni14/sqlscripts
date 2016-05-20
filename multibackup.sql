-- Back Up Multiple Databases at Once

-- In any IT company, the first thing a newly hired programmer (or sql developer) has to do before writing his or her first SQL query is buy insurance of the working version of the production database, i.e. make a backup.

-- This single act of creating a backup and working with the backup version gives you the freedom to perform and practice any kind of data transformation, as it ensures that even if you blow off the company's client's data, it can be recovered. In fact, not just new hires but even the veterans from the same IT company never perform any data transformation without creating backups.

-- Although backing up databases in SQL Server is not a difficult task, it
-- definitely is time-consuming, especially when you need to back up many databases at once.
DECLARE @name VARCHAR(50) -- database name
DECLARE @path VARCHAR(256) -- path for backup files
DECLARE @fileName VARCHAR(256) -- filename for backup
DECLARE @fileDate VARCHAR(20) -- used for file name

-- specify database backup directory
SET @path = 'E:\\Sovit\_BackupFolder\'
exec master.dbo.xp_create_subdir @path

-- specify filename format
SELECT @fileDate = CONVERT(VARCHAR(20),GETDATE(),112)

DECLARE db_cursor CURSOR FOR
SELECT name
FROM master.dbo.sysdatabases
WHERE name IN ('DB_1','DB_2','DB_3',
'DB_4','DB_5','DB_6') -- only these databases

OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @name

WHILE @@FETCH_STATUS = 0
BEGIN
SET @fileName = @path + @name + '_' + @fileDate + '.BAK'
BACKUP DATABASE @name TO DISK = @fileName

FETCH NEXT FROM db_cursor INTO @name
END

CLOSE db_cursor
DEALLOCATE db_cursor
