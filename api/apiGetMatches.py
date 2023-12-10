import json
import time
import requests

# Nur gültig für je 22h deswegen entfernt
api_key = 'YOUR-API KEY'

# URL's für den access auf die API's
base_url_matches = 'https://europe.api.riotgames.com/lol/match/v5/matches/by-puuid/'
base_url_match_details = 'https://europe.api.riotgames.com/lol/match/v5/matches/'

headers = {
    'X-Riot-Token': api_key
}


def make_request(url):
    response = requests.get(url, headers=headers)
    time.sleep(1.2)
    return response


def process_rank(input_path, output_path):
    with open(input_path, 'r', encoding='utf-8') as json_file:
        existing_data = json.load(json_file)

    all_match_data = {}

    for summoner_name, summoner_data in existing_data.items():
        puuid = summoner_data['puuid']

        full_url_match_ids = f'{base_url_matches}{puuid}/ids'
        response_match_ids = make_request(full_url_match_ids)

        if response_match_ids.status_code == 200:
            match_ids = response_match_ids.json()
        else:
            print(f"Error for PUUID {puuid}: {response_match_ids.status_code}")
            continue

        request_limit = 4
        requests_made = 0

        match_data_for_player = []

        for match_id in match_ids:
            if requests_made >= request_limit:
                break

            full_url_match = f'{base_url_match_details}{match_id}'
            response_match = make_request(full_url_match)

            if response_match.status_code == 200:
                match_data = response_match.json()
                match_data_for_player.append(match_data)
                requests_made += 1
            else:
                print(f"Error for match ID {match_id}: {response_match.status_code}")

        all_match_data[summoner_name] = match_data_for_player

    with open(output_path, 'w') as json_file:
        json.dump(all_match_data, json_file, indent=2)

    print(f"Match data saved to {output_path}")


rank_paths = {
    'Iron4': {
        'input_path': 'C:\YourPath\Input',
        'output_path': 'C:\YourPath\Output',
    },
}

for rank, paths in rank_paths.items():
    input_path = paths['input_path']
    output_path = paths['output_path']

    process_rank(input_path, output_path)
