SELECT
    m.*,
    p.[summonerName],
	p.[tier]
FROM
    [Matches] m
JOIN
    [Players] p ON m.[summonerId] = p.[summonerId]
WHERE p.[tier] = 'BRONZE'
