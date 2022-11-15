import json

from fastapi import FastAPI

app = FastAPI()


@app.get("/country/{country}")
def get_continent_from_country(country: str):
	
	with open('country-by-continent.json') as f:
		data = json.load(f)
	
	for item in data:
		if item['country'] == country:
			break

	return {"country": country, "continent": item['continent']}
