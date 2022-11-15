import json

from fastapi import FastAPI
from fastapi import HTTPException

app = FastAPI()


@app.get("/country/{country}")
def get_continent_from_country(country: str):

    with open('country-by-continent.json') as f:
        data = json.load(f)

    matched_data = {}
    for item in data:
        if item['country'].lower() == country.lower():
            matched_data = item
            break

    if len(matched_data) == 0:
        raise HTTPException(status_code=404, detail="Item not found")

    return {"country": matched_data['country'], "continent": matched_data['continent']}
