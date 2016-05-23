-- When comparing multiple databases that have similar schemas, one has to look at the details of table columns. The definitions of the columns (data types, nullables?) are as vital as the name of the columns themselves.

-- Now for databases having many tables and tables having many columns, it can take quite a while to compare each column manually with a column from another table of another database. The next script can precisely be used to automate this very process as it prints the definitions of all tables for a given database.

SELECT
sh.name+'.'+o.name AS ObjectName,
s.name as ColumnName
,CASE
    WHEN t.name IN ('char','varchar') THEN t.name+'('+CASE WHEN s.max_length<0 then 'MAX' ELSE CONVERT(varchar(10),s.max_length) END+')'
    WHEN t.name IN ('nvarchar','nchar') THEN t.name+'('+CASE WHEN s.max_length<0 then 'MAX' ELSE CONVERT(varchar(10),s.max_length/2) END+')'
    WHEN t.name IN ('numeric') THEN t.name+'('+CONVERT(varchar(10),s.precision)+','+CONVERT(varchar(10),s.scale)+')'
    ELSE t.name
END AS DataType
,CASE
     WHEN s.is_nullable=1 THEN 'NULL'
    ELSE 'NOT NULL'
END AS Nullable

FROM sys.columns s
INNER JOIN sys.types t ON s.system_type_id=t.user_type_id and t.is_user_defined=0
INNER JOIN sys.objects o ON s.object_id=o.object_id
INNER JOIN sys.schemas sh on o.schema_id=sh.schema_id

WHERE O.name IN
   (select table_name from information_schema.tables)

ORDER BY sh.name+'.'+o.name,s.column_id
