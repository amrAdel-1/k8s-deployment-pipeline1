# Three-Tier Application with Docker & Kubernetes

A production-ready three-tier application demonstrating modern DevOps practices with Docker, Kubernetes, Helm, and Jenkins CI/CD pipeline.

## 🏗️ Architecture Overview

This project implements a secure three-tier architecture:

- **Proxy Layer (NGINX)**: HTTPS reverse proxy with SSL/TLS termination
- **Backend Layer (Go)**: RESTful API built with Go and Gorilla Mux
- **Database Layer (MySQL 8.0)**: Persistent data storage with secure credential management

## ✨ Key Features

- **Multi-stage Docker builds** for optimized image sizes
- **Secret management** using Docker secrets and Kubernetes secrets
- **HTTPS/SSL** encryption for secure communication
- **Helm charts** for Kubernetes deployment
- **Jenkins CI/CD pipeline** with automated testing and deployment
- **Health checks** and smoke tests
- **Persistent storage** for database with PV/PVC
- **Network isolation** between services
- **Single-command deployment** with Docker Compose

## 🚀 Quick Start

### Prerequisites

- Docker & Docker Compose
- Kubernetes cluster (for K8s deployment)
- Helm 3.x
- Jenkins (for CI/CD)

### Local Development with Docker Compose

1. **Set up database password**:
   ```bash
   echo "your_secure_password" > db-password.txt
   ```

2. **Generate SSL certificates**:
   ```bash
   cd nginx
   ./generate-ssl.sh
   cd ..
   ```

3. **Start all services**:
   ```bash
   docker-compose up -d
   ```

4. **Access the application**:
   ```bash
   curl -k https://localhost:443
   ```

5. **Stop all services**:
   ```bash
   docker-compose down
   ```

## 🐳 Docker Architecture

### Backend (Multi-stage Build)
- **Stage 1**: Build Go application with dependencies
- **Stage 2**: Run tests
- **Stage 3**: Create minimal Alpine-based runtime image

### Proxy (NGINX)
- SSL/TLS termination
- Reverse proxy to backend service
- Custom nginx.conf for routing

### Database (MySQL 8.0)
- Persistent volume for data
- Secret-based password management
- Automatic initialization

## ☸️ Kubernetes Deployment

### Using Helm

```bash
# Install/Upgrade the application
helm upgrade --install my-app ./my-app \
  --namespace dev \
  --create-namespace

# Check deployment status
kubectl get pods -n dev

# Access logs
kubectl logs -f deployment/backend-deployment -n dev
```

### Kubernetes Resources

- **Deployments**: Backend (2 replicas), Database, Proxy
- **Services**: ClusterIP for backend/db, NodePort for proxy
- **Secrets**: Database credentials
- **PersistentVolume/PVC**: Database storage
- **RBAC**: ClusterRole and RoleBindings for Jenkins

## 🔄 CI/CD Pipeline

The Jenkins pipeline automates:

1. **Source**: Pull code from GitHub
2. **Build**: Create Docker images for all services
3. **Push**: Upload images to Docker Hub
4. **Deploy**: Deploy to Kubernetes using Helm
5. **Smoke Test**: Verify application health
6. **Notification**: Email alerts on success/failure

### Pipeline Configuration

```groovy
// Jenkinsfile includes:
- Multi-container pod with Docker and Helm
- Automated image tagging with build numbers
- Helm-based deployment with dynamic values
- Health checks and rollback capabilities
```

## 📁 Project Structure

```
.
├── main.go                      # Go backend application
├── Dockerfile                   # Multi-stage backend build
├── docker-compose.yaml          # Local development setup
├── db-password.txt             # Database credentials (gitignored)
├── nginx/
│   ├── Dockerfile              # NGINX proxy image
│   ├── nginx.conf              # Reverse proxy configuration
│   └── generate-ssl.sh         # SSL certificate generator
├── my-app/                     # Helm chart
│   ├── Chart.yaml
│   ├── values.yaml
│   └── templates/
│       ├── backend_deployment.yaml
│       ├── backend_service.yaml
│       ├── database_deployment.yaml
│       ├── db-secret.yaml
│       ├── db_service.yaml
│       ├── proxy_deployment.yaml
│       └── proxy_nodeport.yaml
└── Jenkins_new/
    ├── Jenkinsfile             # CI/CD pipeline
    ├── jenkins-deployment.yml  # Jenkins K8s deployment
    └── *.yml                   # RBAC and service configs
```

## 🔒 Security Features

- **Secrets Management**: Database passwords stored securely
- **SSL/TLS**: HTTPS encryption for all external traffic
- **Network Isolation**: Services communicate through defined networks
- **RBAC**: Kubernetes role-based access control
- **Non-root Containers**: Alpine-based minimal images
- **Secret Injection**: InitContainers for secure credential mounting

## 🛠️ Technology Stack

| Layer | Technology |
|-------|-----------|
| Backend | Go 1.19, Gorilla Mux |
| Database | MySQL 8.0 |
| Proxy | NGINX with SSL |
| Containerization | Docker, Multi-stage builds |
| Orchestration | Kubernetes, Helm 3 |
| CI/CD | Jenkins Pipeline |
| Storage | Kubernetes PV/PVC |

## 📊 API Endpoints

- `GET /` - Retrieve blog post titles from database

## 🧪 Testing

The backend includes automated tests run during the Docker build process:

```bash
# Run tests locally
go test -v ./...
```

## 📝 Configuration

### Environment Variables

- `DB_PASSWORD_FILE`: Path to database password file

### Docker Compose Networks

Services are isolated in separate networks with controlled communication paths.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## 📄 License

This project is open source and available for educational purposes.

## 👤 Author

Built with ❤️ to demonstrate modern DevOps practices

---

**Note**: This is a demonstration project showcasing Docker, Kubernetes, Helm, and Jenkins integration. Ensure proper security configurations before production use.
