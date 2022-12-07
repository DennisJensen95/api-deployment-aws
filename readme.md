# Deploying API

## Cloud infrastructure requirements

Deploying the application as a docker image with an ECS cluster building upon a fargate auto scale solution and exposing a public API.

Infrastructure setup: 
1. Virtual Private Network (VPC).
2. Security group. 
3. Container registry ECR.
4. Elastic Compute Service (ECS).
5. ECS task. 

Terraform backend:
1. S3 bucket.
2. Dynamo DB table.

## Code base of API

![example workflow](https://github.com/DennisJensen95/api-deployment-aws/actions/workflows/python-app.yml/badge.svg)
![Code coverage](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/DennisJensen95/2b7862c80c14d562c8659e1283543190/raw/api-deployment.json)

Small API deployment.
