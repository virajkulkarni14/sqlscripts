-- Compare Row Counts in Tables From Two Different Databases With the Same Schema

-- If you have a large database and the source of data for your database is some ETL (extract, transform, load) process that runs on a daily basis.

-- Say you have scripts that run on a daily basis to extract data into your database and this process takes about five hours each day. As you begin to look more deeply into this process, you find some areas where you can optimize the script to finish the task in under four hours.

-- You would like to try out this optimization, but since you already have the current implementation on a production server, the logical thing to do is try out the optimized process in a separate database, which you would replicate using the existing database.

-- Now, once ready, you would run both ETL processes and compare the extracted data. If you have a database with many tables, this comparison can take quite a while. So, here's a quick script that facilitates this process.
use YourDatabase_1
CREATE TABLE #counts
(
table_name varchar(255),
row_count int
)

EXEC sp_MSForEachTable @command1='INSERT #counts (table_name, row_count) SELECT ''?'', COUNT(*) FROM ?'

use YourDatabase_2
CREATE TABLE #counts_2
(
table_name varchar(255),
row_count int
)

EXEC sp_MSForEachTable @command1='INSERT #counts_2 (table_name, row_count) SELECT ''?'', COUNT(*) FROM ?'

SELECT a.table_name,
a.row_count as [Counts from regular run],
b.row_count as [Counts from mod scripts],
a.row_count - b.row_count as [difference]
FROM #counts a
inner join #counts_2 b on a.table_name = b.table_name
where a.row_count <> b.row_count
ORDER BY a.table_name, a.row_count DESC
