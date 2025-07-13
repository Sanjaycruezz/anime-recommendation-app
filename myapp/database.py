# myapp/database.py

import json
from myapp.models import Anime

def export_anime_to_json():
    all_anime = Anime.objects.all().values()
    anime_list = list(all_anime)  # Convert queryset to list of dicts

    with open("anime_data.json", "w", encoding="utf-8") as f:
        json.dump(anime_list, f, ensure_ascii=False, indent=4)

    print("Anime data exported to anime_data.json successfully.")
