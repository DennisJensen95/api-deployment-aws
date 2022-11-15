FROM python:3.10-slim-bullseye

# Install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY main.py main.py
COPY country-by-continent.json .

EXPOSE 8000:8000

CMD [ "uvicorn", "main:app", "--host", "0.0.0.0" ]