-- Search for Text Inside All the SQL Procedures
-- You have 20-30 sql procedures in your database and you need to find the procedure that contains a certain word.
SELECT DISTINCT o.name AS Object_Name,o.type_desc
FROM sys.sql_modules m
INNER JOIN sys.objects o
ON m.object_id=o.object_id
WHERE m.definition Like '%search_text%'
