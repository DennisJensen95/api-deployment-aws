# Test repo

![example workflow](https://github.com/DennisJensen95/novozymes-deployment/actions/workflows/python-app.yml/badge.svg)
![Code coverage](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/DennisJensen95/2b7862c80c14d562c8659e1283543190/raw/novozymes-deployment.json)

Small API deployment.

## Setup

### Installation

With an installed local version of python 3.10.2 you can install the dependencies with:

```bash
python -m venv .venv
source .venv/Scripts/activate
pip install -r requirements.txt
```

### How to run the application

You can run the application by doing

```bash
uvicorn main:app
```
