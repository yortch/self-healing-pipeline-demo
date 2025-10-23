# GitHub Copilot Coding Agent Setup

## Prerequisites

To use the self-healing pipeline with GitHub Copilot Coding Agent, you need:

1. ✅ **GitHub Copilot Subscription** (Pro, Business, or Enterprise)
2. ✅ **Personal Access Token** with specific permissions

## Step 1: Create a Personal Access Token (PAT)

The default `GITHUB_TOKEN` in GitHub Actions has insufficient permissions to assign issues to Copilot. You need to create a custom PAT.

### Creating the PAT:

1. Go to **GitHub Settings** → **Developer settings** → **Personal access tokens** → **Fine-grained tokens**
   - Or visit: https://github.com/settings/tokens?type=beta

2. Click **Generate new token**

3. Configure the token:
   - **Token name:** `copilot-coding-agent-token`
   - **Expiration:** Choose your preferred expiration (90 days or custom)
   - **Repository access:** Select "Only select repositories" → Choose `self-healing-pipeline-demo`

4. **Required Permissions** (Repository permissions):
   - ✅ **Actions:** Read and write
   - ✅ **Contents:** Read and write
   - ✅ **Issues:** Read and write
   - ✅ **Pull requests:** Read and write
   - ✅ **Metadata:** Read-only (automatically selected)

5. Click **Generate token** and **copy the token immediately** (you won't see it again!)

## Step 2: Add Token to Repository Secrets

1. Go to your repository: `https://github.com/yortch/self-healing-pipeline-demo`

2. Navigate to **Settings** → **Secrets and variables** → **Actions**

3. Click **New repository secret**

4. Configure the secret:
   - **Name:** `COPILOT_TOKEN`
   - **Value:** Paste the PAT you created in Step 1

5. Click **Add secret**

## Step 3: Verify Setup

Run the healing workflow to verify it works:

```bash
gh workflow run heal.yaml \
  --field failure-type="Test failure" \
  --field failure-category="build"
```

Check the workflow logs to confirm:
- ✅ Copilot bot ID is found
- ✅ Issue is successfully assigned to `copilot-swe-agent`
- ✅ No permission errors

## Expected Behavior

Once configured correctly, the workflow will:

1. 🔍 Detect failures in CI/CD pipelines
2. 📋 Create a GitHub issue with failure details
3. 🤖 Assign the issue to GitHub Copilot Coding Agent
4. ⏳ Copilot analyzes the issue and creates a PR with the fix
5. 👀 You receive a notification to review the PR

## Troubleshooting

### Error: "Insufficient permissions to assign Copilot"

**Cause:** The `COPILOT_TOKEN` secret is missing or has incorrect permissions.

**Solution:**
- Verify the token exists in repository secrets
- Ensure the token has all 4 required permissions (Actions, Contents, Issues, Pull requests)
- Check that the token hasn't expired

### Error: "Copilot Coding Agent not available in this repository"

**Cause:** GitHub Copilot is not enabled for your account or repository.

**Solution:**
- Verify you have an active Copilot subscription (Pro/Business/Enterprise)
- Check that Copilot is enabled in repository settings
- Visit: https://github.com/settings/copilot

### Issue created but Copilot doesn't respond

**Possible causes:**
1. Copilot may take a few minutes to start working
2. The issue description may not be clear enough
3. Copilot might be experiencing service issues

**Solution:**
- Wait 5-10 minutes for Copilot to process the issue
- Check the [GitHub Status Page](https://www.githubstatus.com/) for Copilot service status
- Manually assign additional context in issue comments if needed

## Security Best Practices

- 🔒 Use **fine-grained tokens** instead of classic PATs
- ⏰ Set token **expiration** (don't use "No expiration")
- 🎯 Limit token to **specific repositories** only
- 🔄 **Rotate tokens** periodically (before expiration)
- 📊 Review token usage in GitHub settings regularly

## Alternative: GitHub App Authentication

For organization-wide deployments, consider using a GitHub App instead of PATs:

1. Create a GitHub App with required permissions
2. Install the app in your organization
3. Use app authentication in workflows
4. Benefits: Better security, audit logging, and centralized management

See: https://docs.github.com/en/apps/creating-github-apps

## Documentation References

- [Creating a PAT](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)
- [Copilot Coding Agent Docs](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/create-a-pr)
- [GitHub Actions Secrets](https://docs.github.com/en/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions)
