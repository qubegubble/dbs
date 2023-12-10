import requests
import json
import time

# Your Riot API key
api_key = 'RGAPI-4bc6c7cf-4e46-488f-95fc-de978a3cf610'

# Define the path to your existing JSON file
input_path = 'L:\Studium\Semester_4\DBS\LolData\Players\Platinum\Platinum1Players.json'

# Define the path where you want to save the new JSON data with PUUIDs
output_path = 'L:\Studium\Semester_4\DBS\LolData\Players\puuid\Platinum\Platinum1PlayerPuuid.json'

base_url = 'https://euw1.api.riotgames.com/lol/summoner/v4/summoners/by-name/'

headers = {
    'X-Riot-Token': api_key
}

# Load existing JSON data with explicit encoding specification
with open(input_path, 'r', encoding='utf-8') as json_file:
    existing_data = json.load(json_file)

all_data = {}


# Function to make API requests with rate limiting
def make_request(url):
    response = requests.get(url, headers=headers)
    time.sleep(1.2)  # Introduce a delay to comply with the rate limit
    return response


# Limit the script to retrieve data for the first 500 summoners
request_limit = 250
requests_made = 0

for summoner_data in existing_data:
    if requests_made >= request_limit:
        break

    summoner_name = summoner_data['summonerName']
    full_url = f'{base_url}{summoner_name}'

    response = make_request(full_url)

    if response.status_code == 200:
        data = response.json()
        # Assuming you want to store the PUUIDs in a dictionary with summoner IDs as keys
        all_data[summoner_name] = data
        requests_made += 1
    else:
        print(f"Error for summoner Name {summoner_name}: {response.status_code}")

# Save the collected data as JSON
with open(output_path, 'w') as json_file:
    json.dump(all_data, json_file, indent=2)

print(f"Data saved to {output_path}")
