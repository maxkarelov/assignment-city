from fastapi import FastAPI, HTTPException
from opensearchpy import OpenSearch, NotFoundError
from pydantic import BaseModel
import os
import logging

app = FastAPI(title="Cities Population API")

# Initialize OpenSearch client
opensearch = OpenSearch(
    hosts=[os.getenv("OPENSEARCH_HOST", "http://localhost:9200")],
    http_auth=(os.getenv("OPENSEARCH_USER", "admin"), os.getenv("OPENSEARCH_PASSWORD", "admin")),
    use_ssl = True,
    verify_certs = True,
)

class CityPopulation(BaseModel):
    population: int

@app.get("/health")
async def health_check():
    return {"status": "OK"}

@app.post("/cities/{city_name}")
async def upsert_city(city_name: str, city_data: CityPopulation):
    try:
        opensearch.index(
            index="cities",
            id=city_name,
            body={"population": city_data.population}
        )
        return {"message": f"City {city_name} updated successfully"}
    except Exception as e:
        logging.error(f"Error updating city {city_name}: {e}")
        raise HTTPException(status_code=500)

@app.get("/cities/{city_name}")
async def get_city_population(city_name: str):
    try:
        result = opensearch.get(index="cities", id=city_name)
        return {"population": result["_source"]["population"]}
    except NotFoundError as e:
        raise HTTPException(status_code=404, detail=f"City {city_name} not found")
    except Exception as e:
        logging.error(f"Error getting city {city_name}: {e}")
        raise HTTPException(status_code=500)
