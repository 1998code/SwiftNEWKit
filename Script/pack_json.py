import json
from pathlib import Path

script_dir = Path(__file__).resolve().parent
base_dir = script_dir.parent / "Demo" / "What's New?"
output_file = script_dir / "packed_data.json"

packed_data = {}

for folder in sorted(base_dir.glob("*.lproj")):
    json_path = folder / "data.json"
    if json_path.exists():
        with json_path.open("r", encoding="utf-8") as f:
            packed_data[folder.stem] = json.load(f)

with output_file.open("w", encoding="utf-8") as f:
    json.dump(packed_data, f, ensure_ascii=False, indent=4)
    f.write("\n")

print(f"✅ Successfully packed all data.json files into {output_file}!")
