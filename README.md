# AKS Store Demo

A demo store app with React frontend and Node.js backend services.

## Prerequisites

Install the following CLI tools:

| Tool | Purpose | Install |
|------|---------|---------|
| Docker | Build & run containers | [docker.com](https://www.docker.com) |
| Docker Compose | Run multi-container apps | Included with Docker |
| Azure CLI | Manage Azure resources | `brew install azure-cli` or [docs](https://docs.microsoft.com/cli/azure/install-azure-cli) |
| kubectl | K8s management | `az aks install-cli` or [docs](https://kubernetes.io/docs/tasks/tools/install-kubectl) |
| Terraform | IaC for AKS | [terraform.io](https://www.terraform.io/downloads) |
| Helm | K8s package manager | `brew install helm` or [docs](https://helm.sh/docs/intro/install) |
| Node.js | Local development | `brew install node` |

## Quick Start (Local)

One command to run everything:

```bash
docker-compose -f aks-store-demo/docker-compose.yaml up -d
```
App at http://localhost:8080

RabbitMQ UI: http://localhost:15672 (username/password: username/password)

---

## Services

| Service | Port |
|---------|------|
| store-front | 8080 |
| order-service | 3000 |
| product-service | 3002 |
| rabbitmq | 5672 |

---

## Run Locally with Docker

### Option 1: docker-compose (easiest)

```bash
docker-compose -f aks-store-demo/docker-compose.yaml up -d
```

### Option 2: Pull pre-built images

```bash
docker network create store-network

docker run -d --name rabbitmq --network store-network -p 5672:5672 -p 15672:15672 \
  mcr.microsoft.com/azurelinux/base/rabbitmq-server:3.13

docker run -d --name order-service --network store-network -p 3000:3000 \
  ghcr.io/azure-samples/aks-store-demo/order-service:2.1.0

docker run -d --name product-service --network store-network -p 3002:3002 \
  ghcr.io/azure-samples/aks-store-demo/product-service:2.1.0

docker run -d --name store-front --network store-network -p 8080:8080 \
  ghcr.io/azure-samples/aks-store-demo/store-front:2.1.0
```

### Option 3: Build yourself

```bash
docker build -t store-front aks-store-demo/src/store-front/
docker build -t order-service aks-store-demo/src/order-service/
docker build -t product-service aks-store-demo/src/product-service/
# Then run with docker-compose using build: instead of image:
```

---

## Deploy to Kubernetes (AKS)

### Step 1: Create AKS cluster

```bash
cd aks-store-demo/terraform
terraform init
terraform apply
```

### Step 2: Connect

```bash
az aks get-credentials --resource-group aks-store-rg --name aks-store-cluster
```

### Step 3: Deploy (Helm)

```bash
helm install store ./aks-store-demo/helm/aks-store -n aks-store --create-namespace
```

### Check

```bash
kubectl get pods -n aks-store
kubectl get svc -n aks-store
```

---

## Project Structure

| Folder | What |
|--------|------|
| `aks-store-demo/helm/` | Helm chart |
| `aks-store-demo/terraform/` | AKS cluster |
| `aks-store-demo/pipeline/` | CI/CD |
| `aks-store-demo/src/` | Dockerfiles |

---

## CI/CD

In Azure DevOps, use `aks-store-demo/pipeline/build-deploy.yaml`.

Variables to set:
- `ACR_NAME`
- `AZURE_SERVICE_CONNECTION`
- `RESOURCE_GROUP`
- `CLUSTER_NAME`

---

## Commands

```bash
# Local
docker-compose -f aks-store-demo/docker-compose.yaml up -d      # start
docker-compose -f aks-store-demo/docker-compose.yaml down       # stop
docker-compose -f aks-store-demo/docker-compose.yaml logs -f    # watch logs

# K8s
kubectl get pods -n aks-store
kubectl logs -n aks-store -l app=store-front
kubectl port-forward -n aks-store svc/store-front 8080:80

# Cleanup
helm uninstall store -n aks-store
cd aks-store-demo/terraform && terraform destroy
```

---

## Test Helm

```bash
helm lint ./aks-store-demo/helm/aks-store
```

---
