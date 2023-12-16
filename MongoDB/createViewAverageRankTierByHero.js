db.createView(
    "averageRankTierByHero", 
    "matches", 
    [
        {
            $project: {
                radiant_team_array: { $split: ["$radiant_team", ","] },
                dire_team_array: { $split: ["$dire_team", ","] },
                avg_rank_tier: 1
            }
        },
        {
            $project: {
                all_heroes: { $concatArrays: ["$radiant_team_array", "$dire_team_array"] },
                avg_rank_tier: 1
            }
        },
        {
            $unwind: "$all_heroes"
        },
        {
            $group: {
                _id: "$all_heroes",
                averageRankTier: { $avg: "$avg_rank_tier" }
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
                averageRankTier: 1
            }
        }
    ]
);
