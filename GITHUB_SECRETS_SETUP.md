# GitHub Secrets Setup Guide

## Required Secrets

To enable automated deployment, you need to configure these secrets in your GitHub repository:

### 1. Navigate to GitHub Secrets
- Go to: https://github.com/Junaid91/agents2automate.com/settings/secrets/actions
- Click "New repository secret" for each of the following:

### 2. Add These Secrets

#### Secret 1: `EC2_HOST`
- **Name**: `EC2_HOST`
- **Value**: `98.84.96.36`

#### Secret 2: `EC2_USER`
- **Name**: `EC2_USER`
- **Value**: `ubuntu`

#### Secret 3: `EC2_SSH_KEY`
- **Name**: `EC2_SSH_KEY`
- **Value**: Copy the content from `PRIVATE_KEY.txt` file in this directory

**IMPORTANT**: 
- Open the `PRIVATE_KEY.txt` file in this directory
- Copy the ENTIRE content (including `-----BEGIN OPENSSH PRIVATE KEY-----` and `-----END OPENSSH PRIVATE KEY-----`)
- Paste it as the value for the `EC2_SSH_KEY` secret
- The corresponding public key has already been added to the EC2 server

---

## After Adding Secrets

Once all three secrets are configured:
1. Go to: https://github.com/Junaid91/agents2automate.com/actions
2. Click on "Deploy to EC2" workflow
3. Click "Run workflow" → "Run workflow" to trigger a manual deployment
4. Monitor the deployment progress

The deployment should complete in 1-2 minutes and your changes will be live!
