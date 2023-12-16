db.createView(
    "mostPlayedHeroes", 
    "matches", 
    [
        {
            $unwind: "$radiant_team"
        },
        {
            $unwind: "$dire_team"
        },
        {
            $group: {
                _id: { hero: { $cond: { if: { $eq: ["$radiant_win", true] }, then: "$radiant_team", else: "$dire_team" } } },
                totalMatches: { $sum: 1 }
            }
        },
        {
            $project: {
                _id: 0,
                hero: "$_id.hero",
                totalMatches: 1
            }
        },
        {
            $sort: { totalMatches: -1 }
        }
    ]
);

db.createView(
    "averageRankTierByHero", 
    "matches", 
    [
        {
            $unwind: "$radiant_team"
        },
        {
            $unwind: "$dire_team"
        },
        {
            $group: {
                _id: { hero: { $cond: { if: { $eq: ["$radiant_win", true] }, then: "$radiant_team", else: "$dire_team" } } },
                averageRankTier: { $avg: "$avg_rank_tier" }
            }
        },
        {
            $project: {
                _id: 0,
                hero: "$_id.hero",
                averageRankTier: 1
            }
        }
    ]
);

db.createView(
    "heroWinRates", // Name of the view
    "matches", // Source collection
    [ // Aggregation pipeline
        {
            $unwind: "$radiant_team" // Split the document per hero in radiant_team
        },
        {
            $unwind: "$dire_team" // Split the document per hero in dire_team
        },
        {
            $project: {
                hero: { $cond: { if: { $eq: ["$radiant_win", true] }, then: "$radiant_team", else: "$dire_team" } },
                win: { $cond: { if: { $eq: ["$radiant_win", true] }, then: 1, else: 0 } }
            }
        },
        {
            $group: {
                _id: "$hero",
                totalGames: { $sum: 1 },
                totalWins: { $sum: "$win" }
            }
        },
        {
            $project: {
                _id: 0,
                hero: "$_id",
                totalGames: 1,
                totalWins: 1,
                winRate: { $divide: ["$totalWins", "$totalGames"] }
            }
        }
    ]
);
