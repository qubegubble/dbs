db.createView(
    "mostPlayedHeroes", 
    "matches", 
    [
        {
            $project: {
                radiant_team_array: { $split: ["$radiant_team", ","] },
                dire_team_array: { $split: ["$dire_team", ","] }
            }
        },
        {
            $project: {
                all_heroes: { $concatArrays: ["$radiant_team_array", "$dire_team_array"] }
            }
        },
        {
            $unwind: "$all_heroes"
        },
        {
            $group: {
                _id: "$all_heroes",
                totalMatches: { $sum: 1 }
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
                totalMatches: 1,
                hero: { $arrayElemAt: ["$heroDetails.localized_name", 0] }
            }
        },
        {
            $sort: { totalMatches: -1 }
        }
    ]
);
