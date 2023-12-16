const axios = require('axios');
const fs = require('fs');

const API_URL = 'https://api.opendota.com/api/publicMatches';
//const MAX_REQUESTS_PER_MINUTE = 60;
const MAX_REQUESTS = 60;
const INTERVAL = 60000 / MAX_REQUESTS; // Interval in milliseconds
let matches = new Set(); // Set to store unique match IDs
let requestCount = 0; // Counter for API calls

// Read existing data if available
if (fs.existsSync('matches.json')) {
    const existingMatches = JSON.parse(fs.readFileSync('matches.json'));
    existingMatches.forEach(match => matches.add(match.match_id));
}

async function fetchAndStoreMatches() {
    if (requestCount >= MAX_REQUESTS) {
        console.log('Reached maximum request limit.');
        clearInterval(intervalId);
        return;
    }

    try {
        const response = await axios.get(API_URL, {
            params: {
                less_than_match_id: getLowestMatchId()
            }
        });
        const newMatches = [];

        response.data.forEach(match => {
            if (!matches.has(match.match_id)) {
                matches.add(match);
                newMatches.push(match);
            }
        });

        if (newMatches.length > 0) {
            fs.writeFileSync('matches.json', JSON.stringify([...matches]), { flag: 'w' });
            console.log(`${newMatches.length} new matches added.`);
        } else {
            console.log('No new matches to add.');
        }
    } catch (error) {
        console.error('Error fetching matches:', error.message);
    }

    requestCount++;
}

function getLowestMatchId() {
    let lowestMatchId = 7489705500;
    matches.forEach(matchId => {
        if (matchId < lowestMatchId) {
            lowestMatchId = matchId;
        }
    });
    return lowestMatchId;
}

// Fetch and store matches at regular intervals
setInterval(fetchAndStoreMatches, INTERVAL);

fetchAndStoreMatches(); // Initial call