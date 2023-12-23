CREATE NONCLUSTERED INDEX [IDX_Matches_Rank_Tier] 
ON [dbo].[Matches] ([puuid])
INCLUDE ([matchId], [gameMode], [championId], [championName], [win]);