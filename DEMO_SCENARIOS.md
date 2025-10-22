# Demo Scenarios Guide

This guide walks through different failure scenarios to demonstrate the self-healing pipeline capabilities.

## Prerequisites

- Repository cloned and pushed to GitHub
- All GitHub secrets configured
- Azure resources deployed
- Initial successful pipeline run completed

## Scenario 1: Syntax Error (CI Failure)

### Setup

This scenario introduces a syntax error that will be caught during linting.

**Steps to reproduce:**

1. Create a new branch:
```bash
git checkout -b demo/syntax-error
```

2. Edit `app.js` and introduce a syntax error:
```bash
# Around line 12, change:
# res.status(200).json({
# To:
res.status(200).json({SYNTAX_ERROR

# This will fail linting
```

3. Commit and push:
```bash
git add app.js
git commit -m "demo: introduce syntax error for self-healing demo"
git push origin demo/syntax-error
```

### Expected Behavior

1. **CI Pipeline Fails** ❌
   - Linting step fails with syntax error
   - Pipeline stops, doesn't push to ACR
   - Check: `.github/workflows/ci.yaml` execution

2. **Monitor Detects Failure** 📊
   - Runs on schedule (15 minutes) or manually
   - Detects failed CI workflow
   - Categorizes as "build" failure

3. **Healing Issue Created** 🎯
   - GitHub Issue #XX created
   - Title: `🔧 [Self-Healing] CI Pipeline Failure`
   - Labels: `ci-failure`, `self-healing`, `automated`, `high`
   - Includes Copilot assignment comment

4. **Copilot Fixes the Issue** 🤖
   - Copilot Coding Agent analyzes the issue
   - Creates a new branch `copilot/fix-issue-XX`
   - Fixes the syntax error
   - Opens PR with reference to issue

5. **Pipeline Succeeds** ✅
   - PR is merged
   - CI runs and succeeds
   - CD deploys to Azure Container App
   - Application is live

### Verification

```bash
# Check CI workflow status
gh run list --workflow ci.yaml --limit 5

# View specific failure
gh run view <run-id> --log

# Check created issue
gh issue list --label ci-failure
```

---

## Scenario 2: Docker Build Failure (CI Failure)

### Setup

This scenario introduces an invalid Docker base image.

**Steps to reproduce:**

1. Create a new branch:
```bash
git checkout -b demo/docker-failure
```

2. Edit `Dockerfile` and use invalid image:
```dockerfile
# Change line 1 from:
# FROM node:18-alpine
# To:
FROM invalid-registry.azurecr.io/nonexistent:latest

# This will fail Docker build
```

3. Commit and push:
```bash
git add Dockerfile
git commit -m "demo: introduce Docker build failure for self-healing demo"
git push origin demo/docker-failure
```

### Expected Behavior

1. **CI Pipeline Fails** ❌
   - Docker build step fails
   - Cannot find base image
   - Pipeline stops

2. **Monitor Detects Failure** 📊
   - Detects failed CI workflow
   - Extracts Docker error logs
   - Categorizes as "build" failure

3. **Healing Process**
   - Issue created with Docker error details
   - Copilot analyzes and fixes
   - Correct image reference restored

4. **Pipeline Succeeds** ✅
   - Fix merged and deployed

---

## Scenario 3: Deployment Failure (CD Failure)

### Setup

This scenario simulates a deployment issue by using invalid Azure parameters.

**Steps to reproduce:**

1. Create a new branch:
```bash
git checkout -b demo/deployment-failure
```

2. Edit `.github/workflows/cd.yaml` temporarily:
```yaml
# Around line 68, change:
# --name ${{ env.CONTAINER_APP_NAME }}
# To:
--name invalid-container-app-name-xyz

# This will cause deployment to fail
```

3. Commit and push:
```bash
git add .github/workflows/cd.yaml
git commit -m "demo: introduce deployment failure for self-healing demo"
git push origin demo/deployment-failure
```

### Expected Behavior

1. **CI Succeeds** ✅
   - Application code is fine
   - Docker image builds successfully

2. **CD Pipeline Fails** ❌
   - Tries to deploy to non-existent Container App
   - Gets error from Azure

3. **Monitor Detects CD Failure** 📊
   - Identifies "deployment" failure category
   - Extracts Azure error details

4. **Healing Creates Issue** 🎯
   - Issue created with deployment error
   - Labels: `cd-failure`, `high` priority

5. **Copilot Fixes** 🤖
   - Analyzes deployment logs
   - Identifies invalid resource name
   - Fixes to correct Container App name

6. **Pipeline Succeeds** ✅
   - CD succeeds, application deployed

---

## Scenario 4: Application Health Check Failure (Runtime Failure)

### Setup

This scenario makes the health endpoint unresponsive.

**Steps to reproduce:**

1. Create a new branch:
```bash
git checkout -b demo/health-check-failure
```

2. Edit `app.js` and comment out health endpoint:
```javascript
// Around line 12, comment out:
// app.get('/health', (req, res) => {
//   res.status(200).json({...});
// });

// This makes /health endpoint unavailable
```

3. Commit and push:
```bash
git add app.js
git commit -m "demo: introduce health check failure for self-healing demo"
git push origin demo/health-check-failure
```

### Expected Behavior

1. **CI Pipeline Succeeds** ✅
   - Tests pass (we have dummy tests)
   - Docker builds

2. **CD Pipeline Fails** ⚠️
   - Deployment succeeds
   - Health checks fail

3. **Monitor Detects Health Failure** 📊
   - Identifies "runtime" failure category
   - Endpoint health check returns 404

4. **Healing Creates Issue** 🎯
   - Issue created with health check failure details
   - Labels: `runtime-error`, `medium` priority

5. **Copilot Fixes** 🤖
   - Analyzes error
   - Restores health endpoint
   - Creates PR with fix

6. **Pipeline Recovers** ✅
   - Health checks pass
   - Application healthy

---

## Manual Testing

### Trigger Monitor Manually

```bash
# Run monitor workflow manually
gh workflow run monitor.yaml --ref main

# Check status
gh run list --workflow monitor.yaml --limit 1
```

### Trigger Healing Manually

```bash
# Manually trigger healing (if needed)
gh workflow run heal.yaml \
  --ref main \
  -f failure-type="test-failure" \
  -f failure-category="unknown"
```

### View Issues

```bash
# List all self-healing issues
gh issue list --label self-healing

# View specific issue
gh issue view <issue-number>

# View issue comments
gh issue view <issue-number> --comments
```

### Cleanup After Demo

```bash
# Delete demo branches
git branch -D demo/syntax-error
git branch -D demo/docker-failure
git branch -D demo/deployment-failure
git branch -D demo/health-check-failure

# Push deletions
git push origin --delete demo/syntax-error
git push origin --delete demo/docker-failure
git push origin --delete demo/deployment-failure
git push origin --delete demo/health-check-failure

# Close demo issues
gh issue list --label self-healing --state open | while read issue; do
  gh issue close $issue
done
```

---

## Observing the Self-Healing Process

### Real-Time Monitoring

**Terminal 1 - Watch workflows:**
```bash
gh run list --workflow ci.yaml --limit 10 --watch
```

**Terminal 2 - Watch issues:**
```bash
gh issue list --label self-healing --watch
```

**Terminal 3 - Watch deployment:**
```bash
az containerapp logs show \
  --name <app-name> \
  --resource-group <rg-name> \
  --follow
```

### Dashboard Views

**GitHub Actions:**
- Navigate to: Repository > Actions
- See all workflows in real-time
- Click workflow to view details

**GitHub Issues:**
- Navigate to: Repository > Issues
- Filter by `self-healing` label
- See created issues and Copilot PRs

**Azure Portal:**
- Container App > Deployments
- See container updates
- View revision history

---

## Expected Timelines

| Event | Expected Time |
|-------|----------------|
| Code push | T+0 |
| CI starts | T+0-10s |
| CI completes (success) | T+2-5min |
| CI completes (failure) | T+1-3min |
| CD starts (if CI success) | T+5-15min |
| CD completes | T+10-20min |
| Monitor detects (scheduled) | T+15min (next run) |
| Monitor detects (manual) | T+1-2min |
| Healing issue created | T+2-3min |
| Copilot starts analyzing | T+3-5min |
| Copilot PR created | T+5-10min |
| PR auto-merged | T+10-15min |
| New pipeline run starts | T+15-20min |

---

## Troubleshooting Demo Issues

### Issue: CI never triggers

**Solution:**
```bash
# Check branch is correct
git branch -vv

# Verify workflow syntax
gh workflow view ci.yaml

# Check workflow is enabled
gh workflow enable ci.yaml
```

### Issue: Monitor not detecting failures

**Solution:**
```bash
# Run monitor manually
gh workflow run monitor.yaml --ref main

# Check monitor logs
gh run view <run-id> --log

# Verify secrets are set
gh secret list
```

### Issue: Healing issue not created

**Solution:**
```bash
# Check heal workflow logs
gh run list --workflow heal.yaml -L 1

# Verify GitHub token has permissions
gh auth status

# Check issue creation permission
gh api user -q .permissions
```

### Issue: Copilot not responding

**Solution:**
- Ensure GitHub Copilot subscription is active
- Verify Copilot has access to repository
- Check if organization has Copilot enabled
- Review issue has proper hashtag: `#github-pull-request_copilot-coding-agent`

---

## Key Observations

During the demo, observe:

1. **Automatic Detection** - How the monitor catches failures within 15 minutes
2. **Context Preservation** - Issue includes all relevant logs and context
3. **Intelligent Assignment** - Copilot receives structured failure information
4. **Automated Remediation** - Fix is created without manual intervention
5. **Pipeline Recovery** - After merge, pipeline runs and succeeds
6. **Continuous Monitoring** - System continues monitoring post-recovery

---

## Next Steps

After running through scenarios:

1. Review the GitHub Issues created
2. Examine the PRs generated by Copilot
3. Check the pipeline execution history
4. Verify Container App deployments
5. Review monitoring logs in Azure
6. Extend with custom scenarios

---

**Happy Healing! 🔧✨**
