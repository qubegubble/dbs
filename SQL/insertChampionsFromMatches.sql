INSERT INTO Champion (ChampionID, ChampionName, MatchCount)
SELECT ChampionID, ChampionName, COUNT(*) AS MatchCount
FROM Matches
GROUP BY ChampionID, ChampionName;
