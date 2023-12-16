-- Drop the existing table if it exists
IF OBJECT_ID('tempdb..#tempJson') IS NOT NULL
    DROP TABLE #tempJson;

-- Create the temporary table
CREATE TABLE #tempJson (
    [json] NVARCHAR(MAX)
);

-- Load the JSON file into the temporary table
INSERT INTO #tempJson ([json])
SELECT BulkColumn
FROM OPENROWSET(BULK 'C:\Users\dbsstudent\Desktop\DataInJson\LolData\LolData\Players\AllPlayers.json', SINGLE_CLOB) AS j;

-- View the contents of the temporary table
SELECT * FROM #tempJson;

-- Insert data into the [Players] table
INSERT INTO [Players] (
    [summonerId],
    [summonerName],
    [rank],
    [tier],
    [wins],
    [losses],
    [leaguePoints]
)
SELECT
    ISNULL(jsonValues.[summonerId], ''),
    ISNULL(jsonValues.[summonerName], ''),
    ISNULL(jsonValues.[rank], ''),
    ISNULL(jsonValues.[tier], ''),
    ISNULL(jsonValues.[wins], 0),
    ISNULL(jsonValues.[losses], 0),
    ISNULL(jsonValues.[leaguePoints], 0)
FROM #tempJson
CROSS APPLY OPENJSON([json])
    WITH (
        [summonerId] NVARCHAR(255),
        [summonerName] NVARCHAR(255),
        [rank] NVARCHAR(255),
        [tier] NVARCHAR(255),
        [wins] INT,
        [losses] INT,
        [leaguePoints] INT
    ) AS jsonValues;

-- Drop the temporary table
DROP TABLE #tempJson;
