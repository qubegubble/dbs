import requests
import json
import time

api_key = 'YOUR-API-KEY'

input_path = 'YOUR-PATH'

output_path = 'YOUR-PATH'

base_url = 'https://euw1.api.riotgames.com/lol/summoner/v4/summoners/by-name/'

headers = {
    'X-Riot-Token': api_key
}

with open(input_path, 'r', encoding='utf-8') as json_file:
    existing_data = json.load(json_file)

all_data = {}


def make_request(url):
    response = requests.get(url, headers=headers)
    time.sleep(1.2)
    return response

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
        all_data[summoner_name] = data
        requests_made += 1
    else:
        print(f"Error for summoner Name {summoner_name}: {response.status_code}")

with open(output_path, 'w') as json_file:
    json.dump(all_data, json_file, indent=2)

print(f"Data saved to {output_path}")
