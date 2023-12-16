IF OBJECT_ID('tempdb..#TempMatches') IS NOT NULL
    DROP TABLE #TempMatches;

CREATE TABLE #TempMatches (
    [matchId] NVARCHAR(255),
    [summonerId] NVARCHAR(255),
    [gameMode] NVARCHAR(255),
    [championId] NVARCHAR(255),
    [championName] NVARCHAR(255),
    [win] NVARCHAR(255),
	[puuid] nvarchar(255)
);

DECLARE @JSON NVARCHAR(MAX), @cursor CURSOR, @key NVARCHAR(MAX);

SELECT @JSON = BulkColumn
FROM OPENROWSET(BULK 'C:\Users\dbsstudent\Desktop\DataInJson\LolData\LolData\Matches\Challenger\ChallengerMatches.json', SINGLE_CLOB) import;

SET @cursor = CURSOR LOCAL FAST_FORWARD FOR
    SELECT [key] FROM OPENJSON(@json);
	
OPEN @cursor;
FETCH NEXT FROM @cursor INTO @key;

WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO #TempMatches
    SELECT
        matchId,
        summonerId,
        gameMode,
        championId,
        championName,
		CASE WHEN win = 'true' THEN 1 ELSE 0 END AS win,
		puuid
    FROM OPENJSON(@json, '$.' + '"' + @key + '"') WITH (
        matchId NVARCHAR(MAX) '$.metadata.matchId',
        summonerId NVARCHAR(MAX) '$.info.participants[0].summonerId',
        gameMode NVARCHAR(MAX) '$.info.gameMode',
        championId NVARCHAR(MAX) '$.info.participants[0].championId',
        championName NVARCHAR(MAX) '$.info.participants[0].championName',
        win NVARCHAR(MAX) '$.info.participants[0].win',
		puuid NVARCHAR(MAX) '$.info.participants[0].puuid'
    );

    FETCH NEXT FROM @cursor INTO @key;
END

CLOSE @cursor;
DEALLOCATE @cursor;

INSERT INTO [Matches] ([matchId], [summonerId], [gameMode], [championId], [championName], [win], [puuid])
SELECT [matchId], [summonerId], [gameMode], [championId], [championName], [win], [puuid] FROM #TempMatches;

DROP TABLE #TempMatches;
