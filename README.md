# Cities Population API

A simple API service that maintains a list of cities and their populations using OpenSearch as the database.

## Features

- Health check endpoint
- Add/Update city population
- Retrieve city population
- Containerized with Docker
- Kubernetes deployment with Helm
- Infrastructure as Code with Terraform

## Overview
This project uses
* Docker - to containerization, versioning and distribution application versions
* Digital Ocean - cheap production ready cloud provider for fast start and use managed Kubernetes and OpenSearch (fork of ElasticSearch)
* Terraform - to manage cloud idempodent resources in IaaC way
* Helm - to manage kubernetes resources

## Prerequisites

- Docker
- Kubernetes cluster
- Helm
- kubectl
- Terraform
- DigitalOcean account and API token

## Local Development (folder ./app)

1. Install dependencies:
```bash
pip install -r requirements.txt
```

2. Run the application locally:
```bash
fastapi dev main.py
```

## Docker Build

Build the Docker image:
```bash
docker build -t maxbr/cities-api:1.0.0 .
```

Push the Docker image to public Registry:
```bash
docker push maxbr/cities-api:1.0.0
```

## Infrastructure Deployment with Terraform

1. Navigate to the terraform directory and export Digital Ocean API token:
```bash
cd terraform
TF_VAR_do_token=<REPLACE_TO_YOUR_API_TOKEN>
```

3. Initialize Terraform:
```bash
terraform init
```

4. Review the planned changes:
```bash
terraform plan
```

5. Apply the configuration:
```bash
terraform apply
```

6. After successful deployment, configure kubectl:
```bash
terraform output -raw kubeconfig > ../kubeconfig.yaml
chmod 600 ../kubeconfig.yaml
```

## Kubernetes Deployment

1. Create namespace:
```bash
KUBECONFIG=kubeconfig.yaml kubectl create namespace dev
```

2. Deploy secret to connect OpenSearch:
```bash
KUBECONFIG=kubeconfig.yaml kubectl -n dev create secret generic opensearch --from-literal=host="$(terraform -chdir=terraform output -raw database_host):$(terraform -chdir=terraform output -raw database_port)" --from-literal=user="$(terraform -chdir=terraform output -raw database_user)" --from-literal=password="$(terraform -chdir=terraform output -raw database_password)"
```

3. Deploy the Cities API:
```bash
KUBECONFIG=kubeconfig.yaml helm --namespace dev install cities-api ./helm/cities-api
```

4. Quick check 
```bash
KUBECONFIG=kubeconfig.yaml kubectl -n dev port-forward svc/cities-api 8000:8000

curl http://localhost:8000/cities
curl localhost:8000/cities/saratov -XPOST -d '{"population":123}' -H "Content-Type: application/json" 
curl http://localhost:8000/cities
```

## API Endpoints

- `GET /health` - Health check endpoint
- `PUT /cities/{city_name}` - Add or update city population
- `GET /cities/{city_name}` - Get city population

## Possible next steps in the Project:
* Implement CI/CD pipelines based on Github Actions to cover both infrastructure IaaC and application codes
* Configure scaling both on managed cluster sides and app deployment side
