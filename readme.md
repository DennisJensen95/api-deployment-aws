# Deploying Country based API

## 1 solution proposal

Deploy the application as a docker image with an ECS cluster building upon a fargate auto scale solution and exposing a public API.

Infrastructure setup: 
1. Virtual Private Network (VPC).
2. Security group. 
3. Container registry ECR.
4. Elastic Compute Service (ECS).
5. ECS task. 

Terraform backend:
1. S3 bucket.
2. Dynamo DB table.

## 2 solution proposal

Deploy the REST API on serverless lambda functions providing the application as a ZIP file to the infrastrucure. 

Infrastructure setup: 
1. S3 Bucket to upload FastAPI source.
2. Lambda function with FastAPI source.
3. API Gateway to route requests.
4. Lambda proxy API.


Terraform backend:
1. S3 bucket.
2. Dynamo DB table.

## Test repo with solution proposal 1

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
