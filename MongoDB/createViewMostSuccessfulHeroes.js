db.createView(
    "mostSuccessfulHeroes",
    "matches",
    [
        {
            $project: {
                radiant_team_array: { $split: ["$radiant_team", ","] },
                dire_team_array: { $split: ["$dire_team", ","] },
                radiant_win: 1
            }
        },
        {
            $project: {
                heroesInMatch: {
                    $concatArrays: [
                        { $map: { input: "$radiant_team_array", as: "hero", in: { hero_id: "$$hero", win: "$radiant_win" } } },
                        { $map: { input: "$dire_team_array", as: "hero", in: { hero_id: "$$hero", win: { $not: "$radiant_win" } } } }
                    ]
                }
            }
        },
        {
            $unwind: "$heroesInMatch"
        },
        {
            $group: {
                _id: { $toInt: "$heroesInMatch.hero_id" }, // Convert hero_id to integer
                totalWins: { $sum: { $cond: [{ $eq: ["$heroesInMatch.win", true] }, 1, 0] } },
                totalGames: { $sum: 1 }
            }
        },
        {
            $lookup: {
                from: "heroes",
                localField: "_id",
                foreignField: "id",
                as: "heroDetails"
            }
        },
        {
            $project: {
                _id: 0,
                hero_id: "$_id",
                hero_name: { $arrayElemAt: ["$heroDetails.localized_name", 0] },
                totalWins: 1,
                totalGames: 1,
                winRate: { $divide: ["$totalWins", "$totalGames"] }
            }
        },
        {
            $sort: { winRate: -1 }
        }
    ]
);
