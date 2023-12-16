// FILEPATH: Untitled-1
db.createCollection("Hero", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["HeroID", "HeroName", "MatchCount"],
            properties: {
                HeroID: {
                    bsonType: "string",
                    description: "must be a string and is required"
                },
                HeroName: {
                    bsonType: "string",
                    description: "must be a string and is required"
                },
                MatchCount: {
                    bsonType: "int",
                    description: "must be an integer and is required"
                }
            }
        }
    }
});
