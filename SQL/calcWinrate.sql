WITH AggregatedData AS (
    SELECT
        ChampionID,
        COUNT(*) AS TotalMatches,
        SUM(CAST(win AS INT)) AS TotalWins
    FROM Matches
    GROUP BY ChampionID
)

UPDATE Champion
SET Winrate = ISNULL(
    CONVERT(DECIMAL(5, 2), 
        TotalWins * 1.0 / NULLIF(TotalMatches, 0) * 100
    ),
    0
)
FROM Champion c
LEFT JOIN AggregatedData a ON c.ChampionID = a.ChampionID;
