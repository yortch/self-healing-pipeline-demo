# Self-Healing Pipeline Demo 🔧

A comprehensive demonstration of a **self-healing CI/CD pipeline** using GitHub Actions, Azure Container Apps, and GitHub Copilot Coding Agent for automated remediation.

## 🎯 Overview

This project showcases an intelligent pipeline that:
- **Builds** and **tests** applications automatically (CI)
- **Deploys** to Azure Container Apps (CD)
- **Monitors** application health continuously
- **Detects** failures automatically
- **Creates** GitHub Issues for failures
- **Assigns** issues to GitHub Copilot Coding Agent for automated remediation
- **Self-heals** by automatically fixing detected issues

```
┌─────────────────┐
│   Code Push     │
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────────┐
│  CI Pipeline (ci.yaml)              │
│  - Install dependencies             │
│  - Run tests & linting              │
│  - Build Docker image               │
│  - Vulnerability scan               │
│  - Push to ACR                      │
└────────┬────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────┐
│  CD Pipeline (cd.yaml)              │
│  - Deploy to Azure Container App    │
│  - Health checks                    │
│  - Endpoint verification            │
└────────┬────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────┐
│  Monitor Pipeline (monitor.yaml)    │
│  - Check Container App status       │
│  - Verify endpoints                 │
│  - Check workflow status            │
└────────┬────────────────────────────┘
         │
         ▼ (on failure)
┌─────────────────────────────────────┐
│  Healing Pipeline (heal.yaml)       │
│  - Analyze error logs               │
│  - Create GitHub Issue              │
│  - Assign to Copilot Agent          │
│  - Trigger automated fix            │
└─────────────────────────────────────┘
```

## 📋 Prerequisites

### Required Tools
- **Git** - Version control
- **Node.js 18+** - Application runtime
- **Docker** - Container runtime
- **Azure CLI** - Azure resource management
- **Azure Developer CLI (AZD)** - Infrastructure deployment

### Required Accounts
- **GitHub Account** - Repository and Actions
- **Azure Subscription** - Container Apps, Container Registry
- **GitHub Copilot Pro/Business/Enterprise** - For automated issue remediation ⚠️ **[Setup Required](COPILOT_SETUP.md)**

### Required Permissions
- GitHub repository admin access
- Azure subscription contributor role
- GitHub Personal Access Token for Copilot assignment (see [COPILOT_SETUP.md](COPILOT_SETUP.md))

## 🚀 Quick Start

### 1. Clone and Setup Repository

```bash
# Clone the repository
git clone <your-repo-url>
cd self-healing-pipeline-demo

# Install dependencies (from src/ directory)
cd src
npm install
cd ..
```

### 2. Configure Azure Resources

```bash
# Login to Azure
az login

# Create a resource group (or use azd to create automatically)
az group create \
  --name rg-self-healing-pipeline-demo \
  --location eastus

# Deploy infrastructure using AZD (deploys infra/main.bicep)
azd auth login
azd env new <environment-name>
azd up
```
azd up
```

This will:
- Create Azure Container Registry (ACR)
- Create Container App Environment
- Create Log Analytics Workspace
- Deploy the Container App

### 3. Configure GitHub Secrets

⚠️ **Important:** Before configuring these secrets, complete the [Copilot Setup Guide](COPILOT_SETUP.md) to create the required Personal Access Token.

Add the following secrets to your GitHub repository:

**Repository Settings > Secrets and variables > Actions**

```
COPILOT_TOKEN              # Personal Access Token for Copilot assignment (REQUIRED - see COPILOT_SETUP.md)
AZURE_CREDENTIALS          # Service Principal credentials (JSON format)
AZURE_SUBSCRIPTION_ID      # Your Azure subscription ID
AZURE_RESOURCE_GROUP       # Resource group name (e.g., rg-self-healing-pipeline-demo)
CONTAINER_APP_NAME         # Container app name (from AZD output)
ACR_LOGIN_SERVER           # Azure Container Registry login server
ACR_USERNAME               # ACR username
ACR_PASSWORD               # ACR password
```

#### Creating Azure Credentials for GitHub

```bash
# Create a service principal
az ad sp create-for-rbac \
  --name "github-actions-sp" \
  --role contributor \
  --scopes /subscriptions/{subscription-id}

# Output JSON format:
# {
#   "clientId": "...",
#   "clientSecret": "...",
#   "subscriptionId": "...",
#   "tenantId": "..."
# }

# Add as AZURE_CREDENTIALS secret
```

#### Getting ACR Credentials

```bash
# Get ACR details
az acr show --name <your-acr-name> --query loginServer -o tsv
az acr credential show --name <your-acr-name>
```

### 4. Verify Setup

```bash
# Test application locally
npm start

# Test health endpoint
curl http://localhost:3000/health

# Test root endpoint
curl http://localhost:3000/
```

## 📁 Project Structure

```
self-healing-pipeline-demo/
├── Dockerfile                       # Docker configuration
├── .dockerignore                    # Docker build optimization
├── azure.yaml                       # AZD project configuration
├── plan.md                          # Implementation plan
├── README.md                        # This file
│
├── src/                             # Application source code
│   ├── app.js                      # Express.js application
│   ├── package.json                # Node.js dependencies
│   └── package-lock.json           # Dependency lock file
│
├── infra/                           # Infrastructure as Code
│   ├── main.bicep                  # Main Bicep template
│   └── abbreviations.json          # AZD naming conventions
│
└── .github/
    └── workflows/
        ├── ci.yaml                 # Build & push workflow
        ├── cd.yaml                 # Deployment workflow
        ├── monitor.yaml            # Monitoring & detection
        └── heal.yaml               # Issue creation & Copilot assignment
```

## 🔄 Pipeline Workflows

### 1. CI Pipeline (ci.yaml)

**Triggers:** Push to main/develop, Pull requests

**Steps:**
1. Checkout code
2. Set up Node.js environment
3. Install dependencies
4. Run tests (`npm test`)
5. Run linting (`npm run lint`)
6. Build Docker image
7. Scan for vulnerabilities (Trivy)
8. Log in to Azure Container Registry
9. Push image to ACR with tags (commit SHA and latest)

**Outputs:**
- Docker image URI
- Image digest
- Build artifacts

### 2. CD Pipeline (cd.yaml)

**Triggers:** Successful CI completion, Manual dispatch

**Steps:**
1. Wait for CI to complete
2. Log in to Azure
3. Pull image from ACR
4. Update Container App with new image
5. Wait for deployment to stabilize
6. Run health checks
7. Test endpoints

**Health Checks:**
- Container App status (Running)
- Liveness probe (`GET /health`)
- Readiness probe (`GET /health`)
- Root endpoint response
- Status endpoint response

### 3. Monitor Pipeline (monitor.yaml)

**Triggers:** Every 15 minutes, Manual dispatch

**Checks:**
1. Container App running status
2. Application health endpoint
3. Latest CI workflow status
4. Latest CD workflow status
5. Failed workflow detection

**On Failure:**
- Categorizes failure type
- Triggers healing workflow

### 4. Healing Pipeline (heal.yaml)

**Triggers:** Monitor detects failure, Manual dispatch

**Steps:**
1. Fetch failed workflow logs
2. Analyze failure details
3. Create GitHub Issue with:
   - Failure type and category
   - Workflow logs and error details
   - Remediation instructions
   - Copilot assignment marker
4. Add labels and assignment
5. Notify team

**Copilot Integration:**
- Issue includes `#github-pull-request_copilot-coding-agent` hashtag
- Provides detailed context and logs
- Includes remediation suggestions
- Ready for automated PR creation

## 🧪 Demo Scenarios

### Scenario 1: Syntax Error in Application

**File:** `src/app.js`

```bash
# Introduce syntax error
# Change: res.status(200).json({
# To:     res.status(200).json(SYNTAX_ERROR

git add src/app.js
git commit -m "demo: introduce syntax error"
git push origin main
```

**Expected Flow:**
1. ❌ CI pipeline fails at linting step
2. 📊 Monitor detects CI failure
3. 🎯 Healing creates GitHub Issue
4. 🤖 Copilot analyzes and creates fix
5. ✅ PR merged, pipeline succeeds

### Scenario 2: Docker Build Failure

**File:** `Dockerfile`

```bash
# Introduce invalid base image
# Change: FROM node:18-alpine
# To:     FROM invalid-image:latest

git add Dockerfile
git commit -m "demo: introduce Docker build failure"
git push origin main
```

**Expected Flow:**
1. ❌ CI pipeline fails at Docker build
2. 📊 Monitor detects CI failure
3. 🎯 Healing creates GitHub Issue
4. 🤖 Copilot creates fix
5. ✅ PR merged, pipeline succeeds

### Scenario 3: Deployment Configuration Error

**File:** `.github/workflows/cd.yaml`

```bash
# Introduce invalid Azure parameter
# Intentionally change resource group name

# This would be caught during deployment
# Expected: CD pipeline failure
```

**Expected Flow:**
1. ✅ CI succeeds
2. ❌ CD pipeline fails at deployment
3. 📊 Monitor detects CD failure
4. 🎯 Healing creates GitHub Issue
5. 🤖 Copilot creates fix
6. ✅ PR merged, deployment succeeds

## 📊 Workflow Status Dashboard

Monitor your workflows:
- **GitHub Actions Tab:** View all workflow runs
- **GitHub Issues Tab:** See created healing issues
- **Pull Requests Tab:** Track Copilot fixes

## 🔐 Security Considerations

1. **Service Principal:** Limited to required scope
2. **GitHub Secrets:** Never commit sensitive data
3. **Image Scanning:** Trivy scans for vulnerabilities
4. **RBAC:** Use least privilege access
5. **Branch Protection:** Require PR reviews before merge

## 🛠️ Troubleshooting

### Issue: Workflows not triggering

**Solution:**
- Check GitHub Actions is enabled
- Verify branch protection rules
- Check workflow syntax with `gh workflow view`

### Issue: Container App not deploying

**Solution:**
```bash
# Check container app logs
az containerapp logs show \
  --name <app-name> \
  --resource-group <rg-name>

# Check container app status
az containerapp show \
  --name <app-name> \
  --resource-group <rg-name>
```

### Issue: ACR authentication failing

**Solution:**
```bash
# Verify ACR credentials
az acr credential show --name <acr-name>

# Test login
docker login <acr-login-server>
```

### Issue: Healing workflow not creating issues

**Solution:**
- Verify GitHub token has `issues` permission
- Check workflow has `contents: write` permission
- Review healing workflow logs

## 📈 Monitoring and Logs

### View Workflow Logs

```bash
# List recent runs
gh run list --repo <owner/repo>

# View specific run
gh run view <run-id> --log
```

### View Container App Logs

```bash
az containerapp logs show \
  --name <app-name> \
  --resource-group <rg-name> \
  --tail 50
```

### View Azure Monitor Data

```bash
# Query Log Analytics
az monitor log-analytics query \
  --workspace <workspace-id> \
  --analytics-query "ContainerAppConsoleLogs_CL | tail 50"
```

## 🎓 Learning Resources

- [GitHub Actions Documentation](https://docs.github.com/actions)
- [Azure Container Apps](https://learn.microsoft.com/azure/container-apps)
- [GitHub Copilot CLI](https://docs.github.com/copilot)
- [Bicep Documentation](https://learn.microsoft.com/azure/azure-resource-manager/bicep)
- [Azure Developer CLI](https://learn.microsoft.com/azure/developer/azure-developer-cli)

## 🤝 Contributing

Feel free to extend this demo:
- Add more test scenarios
- Implement advanced monitoring
- Add additional Azure services
- Enhance Copilot integration

## 📝 License

MIT License - See LICENSE file for details

## 🙋 Support

For issues or questions:
1. Check the troubleshooting section
2. Review GitHub Actions logs
3. Check Azure resources status
4. Open an issue on GitHub

---

**Happy Self-Healing! 🚀**

*This demo showcases the power of AI-assisted DevOps and automated remediation in modern CI/CD pipelines.*
