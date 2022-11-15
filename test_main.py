# Standard library
import unittest

# Application code
from main import app

# Third party library
from fastapi.testclient import TestClient


client = TestClient(app)


class TestCountry(unittest.TestCase):
    def test_country(self):
        response = client.get("/country/India")
        self.assertTrue(response.status_code == 200)
        self.assertTrue(response.json() == {
                        "country": "India", "continent": "Asia"})

        response = client.get("/country/denmark")
        self.assertTrue(response.status_code == 200)
        self.assertTrue(response.json()["country"] == "Denmark")
        self.assertTrue(response.json()["continent"] == "Europe")

        response = client.get("/country/imageinary-land")
        self.assertTrue(response.status_code == 404)
