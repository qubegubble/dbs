CREATE VIEW ChampionWinratesByTier AS
WITH AggregatedData AS (
    SELECT
        C.ChampionID,
        C.ChampionName,
        P.tier,
        COUNT(*) AS TotalMatches,
        SUM(CAST(M.win AS INT)) AS TotalWins
    FROM Champion C
    JOIN Matches M ON C.ChampionID = M.ChampionID
    JOIN Players P ON M.summonerId = P.summonerId
    GROUP BY C.ChampionID, C.ChampionName, P.tier
)

SELECT
    ChampionID,
    ChampionName,
    tier,
    ISNULL(CONVERT(DECIMAL(5, 2), TotalWins * 100.0 / NULLIF(TotalMatches, 0)), 0) AS Winrate
FROM AggregatedData;


--SELECT * FROM ChampionWinratesByTier;