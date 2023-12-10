import requests
import json

api_key = 'YOUR-API-KEY'

base_url = 'https://euw1.api.riotgames.com/lol/league-exp/v4/entries'
queue = 'RANKED_SOLO_5x5'
tier = ''
division = ''
pages_to_retrieve = 20

output_path = 'YOUR-PATH'

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

with open(output_path, 'w') as json_file:
    json.dump(all_data, json_file, indent=2)

print(f"Data saved to {output_path}")
