CREATE NONCLUSTERED INDEX [IDX_Players_Rank_Tier] 
ON [dbo].[Players] ([rank], [tier])
INCLUDE ([summonerId], [summonerName]);
