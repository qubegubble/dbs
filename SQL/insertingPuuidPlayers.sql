IF OBJECT_ID('tempdb..#tempMatches') IS NOT NULL
    DROP TABLE #tempPuuid;

CREATE TABLE #TempPuuid (
    [id] NVARCHAR(MAX),
    [puuid] NVARCHAR(MAX)
);

DECLARE @JSON NVARCHAR(MAX), @cursor CURSOR, @key NVARCHAR(MAX);

SELECT @JSON = BulkColumn
FROM OPENROWSET (BULK 'C:\Users\dbsstudent\Desktop\DataInJson\LolData\LolData\Players\puuid\AllPlayersPuuid.json', SINGLE_CLOB) import;

SET @cursor = CURSOR LOCAL FAST_FORWARD FOR
    SELECT [key] FROM OPENJSON(@json);

OPEN @cursor;
FETCH NEXT FROM @cursor INTO @key;

WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO #TempPuuid ([id], [puuid])
    SELECT
        id,
        puuid
    FROM OPENJSON(@json, '$.' + '"' + @key + '"') WITH (
        id NVARCHAR(MAX),
        puuid NVARCHAR(MAX)
    );

    FETCH NEXT FROM @cursor INTO @key;
END

CLOSE @cursor;
DEALLOCATE @cursor;

UPDATE p
SET p.[puuid] = tp.[puuid]
FROM [Players] p
JOIN #TempPuuid tp ON p.[summonerId] = tp.[id];

DROP TABLE #TempPuuid;
