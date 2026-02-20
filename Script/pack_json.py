import os
import json

base_dir = "Demo/What's New?"
output_file = "packed_data.json"

packed_data = {}

for folder in os.listdir(base_dir):
    if folder.endswith(".lproj"):
        lang = folder.split(".lproj")[0]
        json_path = os.path.join(base_dir, folder, "data.json")
        if os.path.exists(json_path):
            with open(json_path, "r", encoding="utf-8") as f:
                data = json.load(f)
                packed_data[lang] = data

with open(output_file, "w", encoding="utf-8") as f:
    json.dump(packed_data, f, ensure_ascii=False, indent=4)

print(f"✅ Successfully packed all data.json files into {output_file}!")
