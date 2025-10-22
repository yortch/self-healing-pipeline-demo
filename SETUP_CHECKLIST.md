# Setup Checklist

Complete this checklist to deploy the self-healing pipeline demo.

## Prerequisites

- [ ] Git installed and configured
- [ ] Node.js 18+ installed
- [ ] Docker installed and running
- [ ] Azure CLI installed
- [ ] Azure Developer CLI (AZD) installed
- [ ] GitHub CLI (gh) installed and authenticated
- [ ] Active Azure subscription
- [ ] GitHub account with repository access
- [ ] GitHub Copilot subscription (for automated fixes)

## Repository Setup

- [ ] Fork or clone the repository
- [ ] Create a new GitHub repository for the demo
- [ ] Clone the repository locally
- [ ] Navigate to project directory: `cd self-healing-pipeline-demo`

## Azure Setup

### Create Azure Resources

- [ ] Login to Azure: `az login`
- [ ] Set subscription: `az account set --subscription <subscription-id>`
- [ ] Create resource group: `az group create --name rg-self-healing-pipeline-demo --location eastus`

### Deploy Infrastructure with AZD

- [ ] Login with AZD: `azd auth login`
- [ ] Initialize environment: `azd env new <environment-name>`
- [ ] Deploy infrastructure: `azd up`
  - This will deploy `infra/main.bicep` and all modules
  - Creates Azure Container Registry, Container App Environment, and Container App
- [ ] Verify deployment completed successfully
- [ ] Note down the outputs:
  - [ ] Container Registry name: _______________
  - [ ] Container Registry login server: _______________
  - [ ] Container App name: _______________
  - [ ] Resource group: _______________

### Get Azure Credentials

- [ ] Create Service Principal for GitHub:
  ```bash
  az ad sp create-for-rbac \
    --name "github-actions-sp" \
    --role contributor \
    --scopes /subscriptions/{subscription-id}
  ```
- [ ] Save the JSON output for next step
- [ ] Get ACR credentials: `az acr credential show --name <acr-name>`
- [ ] Note down:
  - [ ] ACR username: _______________
  - [ ] ACR password: _______________

## GitHub Configuration

### Repository Secrets

Navigate to: **Settings > Secrets and variables > Actions**

Create the following secrets:

- [ ] `AZURE_CREDENTIALS`
  - [ ] Value: (JSON from Service Principal)
  
- [ ] `AZURE_SUBSCRIPTION_ID`
  - [ ] Value: (Your subscription ID)
  
- [ ] `AZURE_RESOURCE_GROUP`
  - [ ] Value: `rg-self-healing-pipeline-demo`
  
- [ ] `CONTAINER_APP_NAME`
  - [ ] Value: (From AZD output)
  
- [ ] `ACR_LOGIN_SERVER`
  - [ ] Value: (e.g., `acrXXXXXXXX.azurecr.io`)
  
- [ ] `ACR_USERNAME`
  - [ ] Value: (From ACR credentials)
  
- [ ] `ACR_PASSWORD`
  - [ ] Value: (From ACR credentials)

### Repository Settings

- [ ] Navigate to **Settings > General**
  - [ ] Enable: "Allow GitHub Actions"
  - [ ] Enable: "Read and write permissions" for workflows

- [ ] Navigate to **Settings > Actions > Workflow permissions**
  - [ ] Select: "Read and write permissions"
  - [ ] Check: "Allow GitHub Actions to create and approve pull requests"

### Copilot Settings (Optional but Recommended)

- [ ] Enable GitHub Copilot on your organization
- [ ] Verify Copilot has repository access
- [ ] Check Copilot settings in repository

## Local Testing

- [ ] Install dependencies: `cd src && npm install && cd ..`
- [ ] Run tests: `cd src && npm test && cd ..`
- [ ] Start app: `cd src && npm start && cd ..`
- [ ] Test health endpoint: `curl http://localhost:3000/health`
- [ ] Test root endpoint: `curl http://localhost:3000/`
- [ ] Verify endpoints return expected responses
- [ ] Stop the application (Ctrl+C)

## Docker Testing

- [ ] Build image: `docker build -t self-healing-pipeline:test .`
- [ ] Run container: `docker run -p 3000:3000 self-healing-pipeline:test`
- [ ] Test endpoints via Docker
- [ ] Stop container (Ctrl+C)

## GitHub Actions Validation

- [ ] Navigate to repository: **Actions** tab
- [ ] Verify workflows are visible:
  - [ ] CI - Build and Push to ACR
  - [ ] CD - Deploy to Azure Container Apps
  - [ ] Monitor - Detect Failures and Trigger Healing
  - [ ] Heal - Create Issue and Trigger Copilot

- [ ] Check workflow syntax: `gh workflow view ci.yaml`

## Initial Pipeline Run

- [ ] Push code to main branch
- [ ] Verify CI workflow triggers
- [ ] Wait for CI to complete (2-5 minutes)
- [ ] Verify image pushed to ACR: `az acr repository list --name <acr-name>`
- [ ] Verify CD workflow triggered
- [ ] Wait for CD to complete (5-10 minutes)
- [ ] Get Container App URL: 
  ```bash
  az containerapp show \
    --name <app-name> \
    --resource-group <rg-name> \
    --query 'properties.configuration.ingress.fqdn' -o tsv
  ```
- [ ] Test deployed application:
  - [ ] Health endpoint: `https://<fqdn>/health`
  - [ ] Root endpoint: `https://<fqdn>/`
  - [ ] Status endpoint: `https://<fqdn>/status`

## Monitor Setup

- [ ] Trigger monitor manually: `gh workflow run monitor.yaml --ref main`
- [ ] Wait for monitor to complete
- [ ] Verify no issues created (app is healthy)

## Demo Scenario 1: Syntax Error

- [ ] Create branch: `git checkout -b demo/syntax-error`
- [ ] Edit `src/app.js` and introduce syntax error
- [ ] Commit and push changes
- [ ] Wait for CI failure (1-3 minutes)
- [ ] Verify healing issue created
- [ ] Review issue details
- [ ] (Optional) Let Copilot create fix or manually fix and merge
- [ ] Verify pipeline recovers

## Demo Scenario 2: Docker Build Failure

- [ ] Create branch: `git checkout -b demo/docker-failure`
- [ ] Edit `Dockerfile` with invalid image
- [ ] Commit and push changes
- [ ] Wait for CI failure
- [ ] Verify healing issue created with Docker error
- [ ] Review issue labels and priority
- [ ] Verify Copilot assignment

## Demo Scenario 3: Deployment Failure

- [ ] Create branch: `git checkout -b demo/deployment-failure`
- [ ] Temporarily modify workflow with invalid parameter
- [ ] Commit and push changes
- [ ] Wait for CD failure
- [ ] Verify healing issue for deployment
- [ ] Check issue includes deployment error details

## Demo Scenario 4: Health Check Failure

- [ ] Create branch: `git checkout -b demo/health-failure`
- [ ] Comment out health endpoint in `src/app.js`
- [ ] Commit and push changes
- [ ] Wait for deployment
- [ ] Verify health check fails
- [ ] Trigger monitor or wait for scheduled run
- [ ] Verify healing issue for health check failure

## Monitoring Verification

- [ ] Check GitHub Issues tab for created issues
- [ ] Verify issue titles follow pattern: `🔧 [Self-Healing] <Failure Type>`
- [ ] Verify labels are appropriate
- [ ] Check issue bodies contain:
  - [ ] Failure type and category
  - [ ] Error logs and details
  - [ ] Copilot assignment marker
  - [ ] Links to failed workflows

## Cleanup (After Demo)

- [ ] Delete demo branches
- [ ] Close/archive demo issues
- [ ] Verify main branch is clean
- [ ] (Optional) Keep Azure resources for ongoing testing
- [ ] (Optional) Delete Azure resources if no longer needed:
  ```bash
  az group delete --name rg-self-healing-pipeline-demo
  ```

## Final Verification

- [ ] All secrets configured correctly
- [ ] All workflows enabled and validated
- [ ] Initial pipeline run successful
- [ ] Container App is running and healthy
- [ ] Monitor detects healthy state
- [ ] Demo scenarios tested (at least one)
- [ ] Documentation reviewed

## Troubleshooting Checklist

If something doesn't work:

- [ ] Check GitHub Actions workflow logs
- [ ] Verify all secrets are set correctly
- [ ] Verify Azure resources exist: `az group show --name rg-self-healing-pipeline-demo`
- [ ] Check Container App status: `az containerapp show --name <app-name> --resource-group <rg-name>`
- [ ] Review Azure resource logs
- [ ] Verify GitHub Copilot is enabled and accessible
- [ ] Check repository settings for Actions permissions
- [ ] Verify service principal has correct permissions

## Additional Resources

- Documentation: See `README.md`
- Demo Guide: See `DEMO_SCENARIOS.md`
- Implementation Plan: See `plan.md`
- Summary: See `IMPLEMENTATION_SUMMARY.md`

---

**Status:** Ready for setup  
**Last Updated:** October 22, 2025  
**Est. Setup Time:** 30-45 minutes
