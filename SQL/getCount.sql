SELECT [matchId], COUNT(*)
FROM [Matches]
GROUP BY [matchId]
HAVING COUNT(*) > 1;
