db.createView(
    "heroWinRates", 
    "matches", 
    [
        {
            $project: {
                radiant_team_array: { $split: ["$radiant_team", ","] },
                dire_team_array: { $split: ["$dire_team", ","] },
                win: { $cond: { if: "$radiant_win", then: true, else: false } }
            }
        },
        {
            $project: {
                all_heroes: { $concatArrays: ["$radiant_team_array", "$dire_team_array"] },
                win: 1
            }
        },
        {
            $unwind: "$all_heroes"
        },
        {
            $group: {
                _id: "$all_heroes",
                totalGames: { $sum: 1 },
                totalWins: { $sum: { $cond: { if: "$win", then: 1, else: 0 } } }
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
                hero: { $arrayElemAt: ["$heroDetails.localized_name", 0] },
                totalGames: 1,
                totalWins: 1,
                winRate: { $divide: ["$totalWins", "$totalGames"] }
            }
        }
    ]
);
