-- Select summonerId's and matches for players with tier 'BRONZE' and rank 'IV'
WITH BronzeIVPlayers AS (
    SELECT
        p.[puuid],
        p.[summonerId],
        p.[summonerName],
        p.[rank],
        p.[tier]
    FROM
        [Players] p
    WHERE
        p.[tier] = 'PLATINUM'
        AND p.[rank] = 'I'
)
SELECT
    bp.[summonerId],
    bp.[summonerName],
    bp.[rank],
    bp.[tier],
    m.[matchId],
    m.[gameMode],
    m.[championId],
    m.[championName],
    m.[win]
FROM
    BronzeIVPlayers bp
JOIN
    [Matches] m ON bp.[puuid] = m.[puuid];


