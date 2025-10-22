# 🚀 Self-Healing Pipeline Demo - Complete Project

Welcome to the **Self-Healing CI/CD Pipeline Demo**! This project showcases an intelligent, AI-assisted DevOps workflow that automatically detects, reports, and fixes issues.

---

## 📚 Documentation Index

Start here based on your role:

### 🎯 For First-Time Users
1. Start: **[README.md](README.md)** - Overview and quick start
2. Then: **[SETUP_CHECKLIST.md](SETUP_CHECKLIST.md)** - Step-by-step setup
3. Finally: **[DEMO_SCENARIOS.md](DEMO_SCENARIOS.md)** - Run the demo

### 👨‍💼 For Project Managers
- **[plan.md](plan.md)** - Implementation plan with status
- **[IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)** - Deliverables and metrics
- **[README.md](README.md)** - Architecture and overview

### 👨‍💻 For Developers
- **[README.md](README.md)** - Getting started
- **[SETUP_CHECKLIST.md](SETUP_CHECKLIST.md)** - Configuration
- **[src/app.js](src/app.js)** - Application code
- **[Dockerfile](Dockerfile)** - Container setup
- **[infra/main.bicep](infra/main.bicep)** - Infrastructure

### 🔧 For DevOps/Platform Engineers
- **[README.md](README.md)** - Architecture overview
- **.github/workflows/** - Workflow definitions:
  - [ci.yaml](.github/workflows/ci.yaml) - Build pipeline
  - [cd.yaml](.github/workflows/cd.yaml) - Deployment pipeline
  - [monitor.yaml](.github/workflows/monitor.yaml) - Monitoring
  - [heal.yaml](.github/workflows/heal.yaml) - Healing mechanism
- **[infra/main.bicep](infra/main.bicep)** - Infrastructure code
- **[azure.yaml](azure.yaml)** - AZD configuration

### 🎬 For Demo Presenters
- **[DEMO_SCENARIOS.md](DEMO_SCENARIOS.md)** - Complete demo guide
- **[README.md](README.md)** - Architecture diagram
- **[IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)** - Feature overview

---

## 📁 Project Structure

```
self-healing-pipeline-demo/
│
├── 📄 README.md                      ← Start here
├── 📄 SETUP_CHECKLIST.md             ← Setup instructions
├── 📄 DEMO_SCENARIOS.md              ← Demo guide
├── 📄 plan.md                        ← Implementation plan
├── 📄 IMPLEMENTATION_SUMMARY.md       ← Project summary
├── 📄 INDEX.md                       ← This file
│
├── 🔵 Application Code
│   ├── src/
│   │   ├── app.js                   ← Express.js app
│   │   ├── package.json             ← Dependencies
│   │   └── package-lock.json        ← Lock file
│   ├── Dockerfile                    ← Container config
│   └── .dockerignore
│
├── 🌩️ Infrastructure
│   ├── azure.yaml                    ← AZD config (points to infra/)
│   └── infra/
│       ├── main.bicep                ← Main Bicep template (subscription-level)
│       ├── abbreviations.json        ← Naming conventions
│       └── modules/
│           ├── logAnalytics.bicep    ← Log Analytics Workspace
│           ├── containerAppEnvironment.bicep ← Container App Environment
│           ├── containerRegistry.bicep ← Azure Container Registry
│           └── containerApp.bicep    ← Container App with health probes
│
├── ⚙️ GitHub Actions Workflows
│   └── .github/workflows/
│       ├── ci.yaml                   ← Build & push
│       ├── cd.yaml                   ← Deploy
│       ├── monitor.yaml              ← Monitoring
│       └── heal.yaml                 ← Issue creation
│
├── 📋 Git Configuration
│   ├── .gitignore
│   └── .github/
│       └── workflows/
│
└── 📦 Root Configuration
    └── azure.yaml
```

---

## 🎯 Quick Navigation

### By Task

**Setting Up the Project**
1. Read: [README.md](README.md) - Prerequisites
2. Follow: [SETUP_CHECKLIST.md](SETUP_CHECKLIST.md)
3. Deploy: Run `azd up`

**Running a Demo**
1. Setup complete? ✓
2. Follow: [DEMO_SCENARIOS.md](DEMO_SCENARIOS.md)
3. Choose: Scenario 1-4 based on failure type

**Understanding the Architecture**
1. View: [README.md](README.md) - Architecture diagram
2. Study: [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md) - Components
3. Review: Workflow files in `.github/workflows/`

**Troubleshooting Issues**
1. Check: [README.md](README.md) - Troubleshooting section
2. Review: Specific workflow logs in GitHub Actions
3. Verify: [SETUP_CHECKLIST.md](SETUP_CHECKLIST.md) - Verify configuration

---

## 🔄 Workflow Pipeline

The project implements a complete CI/CD pipeline with self-healing:

```
┌─────────────────┐
│   Code Push     │
└────────┬────────┘
         ↓
    ┌─────────────────────────────────────┐
    │  CI Pipeline (ci.yaml)              │
    │  - Build, Test, Scan, Push         │
    └────────┬────────────────────────────┘
             ↓
    ┌─────────────────────────────────────┐
    │  CD Pipeline (cd.yaml)              │
    │  - Deploy, Health Check, Verify    │
    └────────┬────────────────────────────┘
             ↓
    ┌─────────────────────────────────────┐
    │  Monitor (monitor.yaml)             │
    │  - Check Health, Detect Failures   │
    └────────┬────────────────────────────┘
             ↓ [On Failure]
    ┌─────────────────────────────────────┐
    │  Heal (heal.yaml)                   │
    │  - Create Issue, Assign Copilot    │
    └────────┬────────────────────────────┘
             ↓
    ┌─────────────────────────────────────┐
    │  Copilot Coding Agent               │
    │  - Analyze, Fix, Create PR          │
    └────────┬────────────────────────────┘
             ↓
         ✅ RESOLVED
```

---

## 🎓 Key Concepts

### Self-Healing Pipeline
An automated CI/CD pipeline that can detect, diagnose, and remediate failures without human intervention.

### Failure Categories
- **Build Failures** (ci.yaml) - Code compilation, tests, linting
- **Deployment Failures** (cd.yaml) - Azure issues, configuration
- **Runtime Failures** (monitor.yaml) - Application health, endpoints
- **Infrastructure Failures** - Container App status

### GitHub Copilot Integration
- Receives structured issue with full context
- Analyzes failure logs and code
- Creates fixes automatically
- Opens and manages pull requests

### Continuous Monitoring
- Health checks every 15 minutes
- Endpoint verification
- Workflow status tracking
- Failure detection and categorization

---

## 📊 Implementation Status

| Component | Status | File |
|-----------|--------|------|
| Application Code | ✅ Complete | src/app.js |
| Infrastructure | ✅ Complete | infra/main.bicep |
| CI Workflow | ✅ Complete | .github/workflows/ci.yaml |
| CD Workflow | ✅ Complete | .github/workflows/cd.yaml |
| Monitor Workflow | ✅ Complete | .github/workflows/monitor.yaml |
| Healing Workflow | ✅ Complete | .github/workflows/heal.yaml |
| Documentation | ✅ Complete | README.md, etc. |
| Demo Scenarios | ✅ Complete | DEMO_SCENARIOS.md |

---

## 🚀 Getting Started (5 Minutes)

### 1. Read Documentation
```
Start: README.md (5 min)
```

### 2. Setup Project
```bash
# Prerequisites: Git, Node.js, Docker, Azure CLI, AZD
git clone <repo>
cd self-healing-pipeline-demo
npm install
```

### 3. Deploy Infrastructure
```bash
az login
azd up
```

### 4. Configure Secrets
```
Add 7 secrets to GitHub repository settings
(See SETUP_CHECKLIST.md)
```

### 5. Run Initial Pipeline
```
Push code to main → CI runs → CD deploys
```

---

## 💡 Demo in 15 Minutes

### Scenario: Syntax Error

1. **Create Branch** (1 min)
   ```bash
   git checkout -b demo/syntax-error
   ```

2. **Introduce Error** (2 min)
   - Edit app.js
   - Commit and push

3. **Observe Failure** (5 min)
   - Watch CI fail in GitHub Actions
   - Check workflow logs

4. **Healing Triggered** (5 min)
   - Monitor detects failure (or manual trigger)
   - GitHub issue created
   - Copilot assignment visible

5. **Review Results** (2 min)
   - Check created issue
   - See error logs
   - Observe Copilot marker

---

## 📖 Documentation Breakdown

### README.md
- **Purpose:** Main documentation
- **Contains:** Overview, setup, troubleshooting
- **Read Time:** 15-20 minutes
- **Best For:** Everyone

### SETUP_CHECKLIST.md
- **Purpose:** Step-by-step setup guide
- **Contains:** Checkbox items for each step
- **Read Time:** 30-45 minutes (to execute)
- **Best For:** First-time setup

### DEMO_SCENARIOS.md
- **Purpose:** Demo walkthrough guide
- **Contains:** 4 failure scenarios with steps
- **Read Time:** 10 minutes (to review)
- **Execution Time:** 20-30 minutes per scenario
- **Best For:** Presenters and demo runners

### plan.md
- **Purpose:** Implementation plan and progress
- **Contains:** Phases, tasks, status
- **Read Time:** 10 minutes
- **Best For:** Project managers, stakeholders

### IMPLEMENTATION_SUMMARY.md
- **Purpose:** Project completion summary
- **Contains:** Deliverables, metrics, features
- **Read Time:** 15 minutes
- **Best For:** Executives, stakeholders

### INDEX.md (This File)
- **Purpose:** Navigation and overview
- **Contains:** Quick links and structure
- **Read Time:** 5 minutes
- **Best For:** All users

---

## 🔗 External Resources

### GitHub Actions
- [Official Docs](https://docs.github.com/actions)
- [Workflow Syntax](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)
- [Best Practices](https://docs.github.com/en/actions/guides)

### Azure
- [Container Apps](https://learn.microsoft.com/azure/container-apps)
- [Container Registry](https://learn.microsoft.com/azure/container-registry)
- [Bicep](https://learn.microsoft.com/azure/azure-resource-manager/bicep)
- [AZD CLI](https://learn.microsoft.com/azure/developer/azure-developer-cli)

### GitHub Copilot
- [Copilot Docs](https://docs.github.com/copilot)
- [Coding Agent](https://docs.github.com/en/copilot/using-github-copilot/using-github-copilot-coding-agent)

---

## ❓ FAQ

### Q: Do I need GitHub Copilot?
**A:** No, the demo works without it. Copilot adds automated fix capability, but issues will still be created and you can fix manually.

### Q: How much does this cost?
**A:** Minimal cost:
- GitHub Actions: Free tier included
- Azure: ~$5-10/month for basic resources
- GitHub Copilot: ~$20/month (optional)

### Q: How long does deployment take?
**A:** ~5-10 minutes total:
- Infrastructure setup: 2-3 min
- Initial pipeline run: 5-7 min

### Q: Can I modify the demo?
**A:** Absolutely! The code and workflows are fully customizable. See [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md) for enhancement ideas.

### Q: What if a workflow fails?
**A:** Check [README.md](README.md) troubleshooting section or review workflow logs in GitHub Actions.

---

## 🎯 Next Steps

### For Users
1. ✅ Read [README.md](README.md)
2. ⏳ Complete [SETUP_CHECKLIST.md](SETUP_CHECKLIST.md)
3. 🎬 Run [DEMO_SCENARIOS.md](DEMO_SCENARIOS.md)
4. 🧪 Customize and extend

### For Developers
1. ✅ Review code files
2. ✅ Understand workflows
3. 🔧 Modify and test
4. 🚀 Deploy your version

### For Presenters
1. ✅ Study [README.md](README.md) architecture
2. ✅ Review [DEMO_SCENARIOS.md](DEMO_SCENARIOS.md)
3. 🎬 Practice one scenario
4. 📊 Prepare presentation

---

## 📞 Support

### If You Get Stuck

1. **Check Documentation First**
   - [README.md](README.md) - Troubleshooting section
   - [SETUP_CHECKLIST.md](SETUP_CHECKLIST.md) - Verification steps

2. **Review Logs**
   - GitHub Actions: Repository → Actions tab
   - Azure: Azure Portal or CLI
   - Local: Terminal output

3. **Common Issues**
   - Secrets not set → Check repository settings
   - Workflows not triggering → Check branch name
   - Deployment failing → Check Azure resources

---

## ✨ Key Features

✅ **Automated CI/CD Pipeline**
- Multi-stage builds
- Container vulnerability scanning
- Automated deployment

✅ **Continuous Monitoring**
- 15-minute health checks
- Multi-endpoint verification
- Workflow status tracking

✅ **Intelligent Failure Detection**
- 4+ failure categories
- Log analysis and context preservation
- Root cause identification

✅ **AI-Assisted Remediation**
- Automatic GitHub issue creation
- GitHub Copilot integration
- Automated PR generation

✅ **Infrastructure as Code**
- Bicep templates
- AZD compatibility
- Reproducible deployments

---

## 🏆 Project Highlights

This demo showcases:
- **Modern DevOps** - Separated CI/CD pipelines
- **Cloud Native** - Azure Container Apps
- **AI Integration** - GitHub Copilot Coding Agent
- **Automation** - End-to-end self-healing
- **Best Practices** - Monitoring, logging, security

---

## 📝 License

MIT License - Free to use and modify

---

## 🎉 You're Ready!

You now have everything you need to:
1. ✅ Understand the self-healing pipeline
2. ✅ Set up the demo environment
3. ✅ Run demonstration scenarios
4. ✅ Extend and customize for your needs

**Start with:** [README.md](README.md)

**Happy Learning! 🚀**

---

**Last Updated:** October 22, 2025  
**Project Status:** ✅ Complete and Ready for Deployment  
**Version:** 1.0.0
