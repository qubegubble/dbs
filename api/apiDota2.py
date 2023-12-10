import requests
import json
import time

api_key = '85518fb0-70d1-423d-bff5-c798c0e5b5ec'


def fetch_match_ids(api_key, start_index, end_index):
    base_url = "https://api.opendota.com/api/publicMatches"
    url = f"{base_url}?api_key={api_key}&mmr_descending=true&date={start_index}-{end_index}"

    try:
        response = requests.get(url)
        matches = response.json()
        match_ids = [match['match_id'] for match in matches]
        return match_ids
    except requests.exceptions.RequestException as e:
        print(f"Error fetching match IDs: {e}")
        return []


def fetch_match_data(match_id, api_key):
    base_url = "https://api.opendota.com/api/matches/"
    url = f"{base_url}{match_id}?api_key={api_key}"

    try:
        response = requests.get(url)
        data = response.json()
        return data
    except requests.exceptions.RequestException as e:
        print(f"Error fetching match data: {e}")
        return None


total_matches = 31000

matches_per_file = 1000

num_match_id_batches = total_matches // matches_per_file

matches_processed = 0

for batch_number in range(num_match_id_batches):
    start_index = batch_number * matches_per_file + 1
    end_index = (batch_number + 1) * matches_per_file

    match_ids_batch = fetch_match_ids(api_key, start_index, end_index)

    match_data_list = []

    for i, match_id in enumerate(match_ids_batch):

        match_data = fetch_match_data(match_id, api_key)

        if match_data:
            match_data_list.append(match_data)

            matches_processed += 1

    file_path = f"L:\Studium\Semester_4\DBS\dota2Data\Matches\match_data_batch{batch_number + 1}.json"

    with open(file_path, 'w') as json_file:
        json.dump(match_data_list, json_file, indent=2)

    print(f"Batch {batch_number + 1} data saved to {file_path}")
    print("---")

    time.sleep(1)
