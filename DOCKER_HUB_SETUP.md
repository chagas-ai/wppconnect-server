# Docker Hub Setup for GitHub Actions

## Step 1: Create Docker Hub Access Token

1. **Go to Docker Hub**: https://hub.docker.com/settings/security
2. **Click**: "New Access Token"
3. **Description**: `GitHub Actions - chagas-wppconnect`
4. **Access permissions**: Read, Write, Delete
5. **Click**: Generate
6. **Copy the token** (you won't see it again!)

## Step 2: Add Token to GitHub Secrets

1. **Go to GitHub Repository**: https://github.com/chagas-ai/chagas-wppconnect/settings/secrets/actions
2. **Click**: "New repository secret"
3. **Name**: `DOCKERHUB_TOKEN`
4. **Value**: Paste the token from Step 1
5. **Click**: "Add secret"

## Step 3: Verify Workflow

Once the secret is added, the workflow will publish to:

**Docker Hub**:
- `davivilela/wppconnect:latest`
- `davivilela/wppconnect:main`
- `davivilela/wppconnect:v1.0.0` (if you tag releases)

**GitHub Container Registry** (backup):
- `ghcr.io/chagas-ai/chagas-wppconnect:latest`

## Step 4: Trigger Build

After adding the secret, push the updated workflow:

```bash
git add .github/workflows/docker-publish.yml
git commit -m "Add Docker Hub publishing"
git push
```

Or manually trigger: https://github.com/chagas-ai/chagas-wppconnect/actions/workflows/docker-publish.yml

## Using the Image

### Pull from Docker Hub
```bash
docker pull davivilela/wppconnect:latest
```

### Run Container
```bash
docker run -d \
  -p 21465:21465 \
  -e SECRET_KEY=your_secret_key \
  davivilela/wppconnect:latest
```

### Railway Deployment

In Railway Dashboard, you can now use:
- **Docker Image**: `davivilela/wppconnect:latest`

Or deploy from GitHub (recommended) and Railway will build from source.

## Multi-Platform Support

The workflow builds for both:
- `linux/amd64` (x86_64) - For most servers
- `linux/arm64` (ARM) - For Apple Silicon, Raspberry Pi, etc.

## Available Tags

- `latest` - Latest build from main branch
- `main` - Same as latest
- `v1.0.0` - Specific version (when you tag releases)
- `v1.0` - Major.minor version
- `v1` - Major version only

## Check Build Status

https://github.com/chagas-ai/chagas-wppconnect/actions

## Docker Hub Repository

https://hub.docker.com/r/davivilela/wppconnect
