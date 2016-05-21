-- Many programming languages allow you to insert values inside string texts, which is very useful when generating dynamic string texts. Since SQL doesn't provide any such function by default, here is a quick remedy for that. Using the function below, any number of texts can be dynamically inserted inside string texts.

--Example Usage
--declare @test varchar(400)
--select @test = [dbo].[FN_SPRINTF] ('I am %s and you are %s', '1,0', ',') --param separator ','
--print @test -- result: I am 1 and you are 0
--select @test = [dbo].[FN_SPRINTF] ('I am %s and you are %s', '1#0', '#') --param separator ','
--print @test -- result: I am 1 and you are 0

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- AUTHOR: <AuthorName>
-- =============================================
CREATE FUNCTION DBO.FN_SPRINTF
(
@STRING VARCHAR(MAX),
@PARAMS VARCHAR(MAX),
@PARAM_SEPARATOR CHAR(1) = ','
)
RETURNS VARCHAR(MAX)
AS
BEGIN

DECLARE @P VARCHAR(MAX)
DECLARE @PARAM_LEN INT

SET @PARAMS = @PARAMS + @PARAM_SEPARATOR
SET @PARAM_LEN = LEN(@PARAMS)
WHILE NOT @PARAMS = ''
BEGIN
    SET @P = LEFT(@PARAMS+@PARAM_SEPARATOR, CHARINDEX(@PARAM_SEPARATOR, @PARAMS)-1)
    SET @STRING = STUFF(@STRING, CHARINDEX('%S', @STRING), 2, @P)
    SET @PARAMS = SUBSTRING(@PARAMS, LEN(@P)+2, @PARAM_LEN)
END
RETURN @STRING

END
