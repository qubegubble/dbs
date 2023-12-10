import requests
import json

# Your Riot API key
api_key = 'RGAPI-ef56e99c-ccb1-423f-ad8b-20dd95cc349d'

base_url = 'https://euw1.api.riotgames.com/lol/league-exp/v4/entries'
queue = 'RANKED_SOLO_5x5'
tier = 'SILVER'
division = 'III'
pages_to_retrieve = 20

# Define the path where you want to save the JSON data
output_path = 'L:\Studium\Semester_4\DBS\LolData\Silver\Silver3Players.json'

headers = {
    'X-Riot-Token': api_key
}

all_data = []

for page in range(1, pages_to_retrieve + 1):
    endpoint = f'/{queue}/{tier}/{division}?page={page}'
    full_url = f'{base_url}{endpoint}'

    response = requests.get(full_url, headers=headers)

    if response.status_code == 200:
        data = response.json()
        all_data.extend(data)
    else:
        print(f"Error: {response.status_code}")

# Save the collected data as JSON
with open(output_path, 'w') as json_file:
    json.dump(all_data, json_file, indent=2)

print(f"Data saved to {output_path}")
