CREATE TABLE [Players] (
    [id] INT IDENTITY(1,1) PRIMARY KEY,
    [summonerId] NVARCHAR(255),
    [summonerName] NVARCHAR(255),
    [rank] NVARCHAR(255),
    [tier] NVARCHAR(255),
    [wins] INT,
    [losses] INT,
    [leaguePoints] INT
);


CREATE TABLE [Matches] (
  [id] int,
  [matchId] nvarchar(255) PRIMARY KEY,
  [summonerId] nvarchar(255),
  [gameMode] nvarchar(255),
  [championId] int,
  [championName] nvarchar(255),
  [win] bit,
  CONSTRAINT [FK_Matches_id]
    FOREIGN KEY ([id])
      REFERENCES [Players]([id])
);
