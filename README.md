# Burger Builder Platform

Burger Builder is a full-stack ordering experience built by Group1. It couples a responsive React + TypeScript frontend with a Spring Boot API and an automated Azure landing zone (AKS, Azure SQL, Key Vault, optional Front Door) provisioned through Terraform and GitHub Actions.

## Highlights
- React 19 + Vite 7 SPA with local storage cart persistence and rich burger composition experience
- Spring Boot 3.2 REST API backed by Azure SQL, Actuator health checks, and Prometheus metrics
- Terraform-managed Azure footprint (AKS, static ingress IP, user-assigned identity, Key Vault secrets, SQL, storage, optional Front Door)
- GitHub Actions workflow that provisions infrastructure, deploys workloads to AKS, manages DNS/front-door, and installs monitoring

## Repository Layout
```
Group1-final-project/
├── backend/                         # Spring Boot API and Dockerfile
├── frontend/                        # React + TypeScript app and Dockerfile
├── k8s/
│   ├── backend/                     # Deployment, HPA, SecretProviderClass, network policy
│   ├── frontend/                    # Deployment, HPA, ingress, network policy
│   ├── ingress-controller/          # Helm-based ingress notes
│   ├── monitoring/                  # kube-prometheus-stack overrides, alerts, ServiceMonitors
│   └── namespace.yaml               # Application namespace definition
├── terraform/                       # Azure infrastructure modules, backend, variables
├── .github/workflows/               # CI/CD workflows (infra-complete.yml)
├── clean-aks.sh                     # Utility to purge deployed workloads from AKS
├── environment.env.example          # Backend environment template
└── README.md                        # This file
```

## Application Components

### Frontend (React + Vite)
- SPA that lets users stack ingredients, view a live burger preview, and push orders to the backend
- Ingredient catalogue grouped by category with graceful fallback sample data when the API is offline
- Cart management, checkout, and order history pages backed by React Context and local storage persistence
- Axios service layer configured via `VITE_API_BASE_URL`
- Build artifacts served through Nginx; Dockerfile handles multi-stage build

### Backend (Spring Boot)
- REST endpoints for ingredients, carts, orders, health, and metrics (`/actuator/prometheus`)
- Spring Data JPA with Azure SQL (production) or PostgreSQL (development) support
- Key Vault secret consumption through the CSI driver (username/password), with environment overrides from ConfigMaps
- Horizontal scaling ready via Kubernetes readiness/liveness probes and auto-scaling policies
- Maven project targeting Java 21 with comprehensive DTO/service/controller layer separation

### Kubernetes Workloads
- Namespace-isolated deployments (`app` namespace) with separate manifests for backend and frontend
- HPAs, PodDisruptionBudgets, and network policies for both tiers
- Ingress NGINX configured for `/api` (backend) and root path (frontend) with static public IP
- SecretProviderClass wiring Key Vault secrets into pods, plus synced Kubernetes secret
- Monitoring stack (Prometheus, Alertmanager, Grafana) installed via Helm with Slack webhook placeholders

## Local Development
1. Clone the repository and move into the project directory.
2. Copy the backend environment template:
   ```bash
   cp environment.env.example environment.env
   ```
3. Update `environment.env` with local or cloud database credentials and CORS origins.
4. Start the backend:
   ```bash
   cd backend
   mvn spring-boot:run
   ```
5. Start the frontend (in a new shell):
   ```bash
   cd frontend
   npm install
   npm run dev
   ```
6. Browse to `http://localhost:5173` (frontend) with the API available at `http://localhost:8080`.

### Useful Environment Profiles
- Development: `SPRING_PROFILES_ACTIVE=default` (Azure SQL) or switch to a PostgreSQL profile if required
- Frontend: create `frontend/.env` with `VITE_API_BASE_URL=http://localhost:8080`

## Docker Images
- Backend: `backend/Dockerfile` (multi-stage Maven build, produces `app.jar`)
  ```bash
  docker build -t burger-builder-backend ./backend
  ```
- Frontend: `frontend/Dockerfile` (Node build + Nginx runtime)
  ```bash
  docker build -t burger-builder-frontend ./frontend
  ```
- Kubernetes manifests reference published images `docker.io/aalhatlan/backend:latest` and `docker.io/aalhatlan/fe-final-project:latest`.

## Infrastructure & Deployment

### Terraform (Azure)
- Remote state stored in Azure Storage (`terraform-backend-rg-gr1/aalhatlanstate001/tfstate`)
- Modules provision:
  - Resource group, virtual network, AKS cluster with user-assigned managed identity
  - Azure SQL server/database with subnet rule
  - Static public IP for ingress controller
  - Key Vault (with optional custom name) and seeded SQL credentials
  - Storage account for general use
  - Optional Azure Front Door profile and route
- Usage:
  ```bash
  cd terraform
  az login
  export TF_VAR_sql_admin=...
  export TF_VAR_sql_password=...
  terraform init
  terraform plan
  terraform apply
  ```
  Adjust `terraform.tfvars` for prefix, region (`austriaeast`), SKU choices, etc.

### GitHub Actions (`infra-complete.yml`)
- Triggers on pushes to `main` or manual dispatch
- Job `terraform`:
  - Logs into Azure using federated identity
  - Runs `terraform apply`
  - Exports kubeconfig, Key Vault name, AKS identity, ingress static IP, resource group, optional Front Door endpoint
- Job `deploy`:
  - Rehydrates kubeconfig, installs Helm
  - Installs/updates ingress-nginx using the static IP and node resource group annotation
  - Optionally updates Azure Front Door origin and prints DNS guidance or updates Cloudflare records
  - Applies namespaces, ConfigMaps, SecretProviderClass, Kubernetes secrets, backend/frontend workloads, HPAs, ingress rules
  - Installs/updates `kube-prometheus-stack` with `k8s/monitoring/values.yaml`
  - Runs final `kubectl get` checks for pods, ingresses, services

### Kubernetes Manifests (`k8s/`)
- `backend/`: deployment, ClusterIP service, ingress at `/api`, ConfigMap for JDBC settings, SecretProviderClass, network policy, PodDisruptionBudget, HPA, Key Vault validation pod
- `frontend/`: deployment, ClusterIP service, ingress for `/`, ConfigMap placeholder, network policy, PodDisruptionBudget, HPA
- `monitoring/`: ServiceMonitors for both workloads, PrometheusRule alerts (latency, error rate, pod health, resource saturation), Grafana dashboards, Alertmanager Slack receivers (requires `SLACK_WEBHOOK_URL`)
- `namespace.yaml`: defines the `app` namespace with labels to support selectors

### Monitoring Stack
- Helm chart `prometheus-community/kube-prometheus-stack`
- Grafana exposed as LoadBalancer with admin password override (`admin123` default)
- Alertmanager configured for Slack via `${SLACK_WEBHOOK_URL}` (provide via Helm values substitution or GitHub Actions env)

## Environment Variables & Secrets

### Backend (`environment.env`)
- `SPRING_PROFILES_ACTIVE`
- `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USERNAME`, `DB_PASSWORD`, `DB_DRIVER`
- `SERVER_PORT`
- `CORS_ALLOWED_ORIGINS`

### Frontend (`frontend/.env`)
- `VITE_API_BASE_URL` (points to backend base URL, e.g., `https://<ingress-ip>.nip.io` or `http://localhost:8080`)

### GitHub Secrets (workflow)
- `AZURE_CREDENTIALS`, `AZURE_CLIENT_ID`, `AZURE_CLIENT_SECRET`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`
- `SQL_ADMIN_USERNAME`, `SQL_ADMIN_PASSWORD`
- Optional: `CF_API_TOKEN`, `CF_ZONE_ID`, `DNS_RECORD_NAME`, `DNS_RECORD_TYPE`, `SLACK_WEBHOOK_URL`

## Testing
- Backend: `mvn test` (uses Spring Boot Test + H2)
- Frontend: `npm run test`, `npm run test:ui`, `npm run test:coverage`
  - Latest results (`frontend/test-results.json`) show 19 passing suites / 46 assertions
- Lint frontend with `npm run lint`

## API Overview
- `GET /api/ingredients` – list all ingredients
- `GET /api/ingredients/{category}` – list by category
- `GET /api/ingredients/categories` – list categories
- `GET /api/ingredients/id/{id}`, `GET /api/ingredients/name/{name}`, `GET /api/ingredients/search?searchTerm=`
- `POST /api/cart/items` – add to cart
- `GET /api/cart/{sessionId}` – retrieve cart
- `DELETE /api/cart/items/{itemId}?sessionId=` – remove item
- `DELETE /api/cart/{sessionId}` – clear cart
- `GET /api/cart/{sessionId}/total` and `/count` – totals and counts
- `POST /api/orders` – create order
- `GET /api/orders/{orderId}`, `/order-number/{orderNumber}`
- `GET /api/orders/customer/{email}`, `/session/{sessionId}`, `/status/{status}`, `/history?email=`
- `PUT /api/orders/{orderId}/status?status=` – update order status
- `GET /api/health` – health check
- `/actuator/*` – Spring Boot Actuator endpoints (prometheus enabled)

## Operations
- Use `clean-aks.sh` to tear down namespaces, LoadBalancer services, and monitoring CRDs prior to a clean redeploy.
- Retrieve kubeconfig from Terraform output or workflow artifacts (`aks_kube_config`).
- Update ingress hostnames or allowlists via `k8s/backend/configmap.yaml` and `k8s/frontend/configmap.yaml`.

## License

This project is delivered as part of Group1's capstone and intended for educational use.
