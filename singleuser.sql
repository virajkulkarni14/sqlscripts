-- Single-user mode specifies that only one user at a time can access the database and is generally used for maintenance actions. Basically, if other users are connected to the database at the time that you set the database to single-user mode, their connections to the database will be closed without warning.

-- This is quite useful in the scenarios where you need to restore your database to the version from a certain point in time or you need to prevent possible changes by any other processes accessing the database.

USE master;
GO
ALTER DATABASE YourDatabaseName
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE;
GO
ALTER DATABASE YourDatabaseName
SET READ_ONLY;
GO
ALTER DATABASE YourDatabaseName
SET MULTI_USER;
GO
