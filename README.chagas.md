# Chagas AI - WPPConnect Server

Fork of [wppconnect-team/wppconnect-server](https://github.com/wppconnect-team/wppconnect-server) for Chagas AI project with Railway deployment.

## Changes from Upstream

- **GitHub Actions**: Automated Docker image publishing to GitHub Container Registry
- **Railway Configuration**: `railway.toml` for easy deployment
- **Docker Image**: Published at `ghcr.io/chagas-ai/chagas-wppconnect:latest`

## Quick Start

### Pull Docker Image

```bash
docker pull ghcr.io/chagas-ai/chagas-wppconnect:latest
```

### Run Locally

```bash
docker run -d \
  -p 21465:21465 \
  -e SECRET_KEY=your_secret_key \
  ghcr.io/chagas-ai/chagas-wppconnect:latest
```

### Deploy to Railway

1. Go to [Railway Dashboard](https://railway.app)
2. Switch to **chagas-ai** organization
3. **New Project** → **Deploy from GitHub repo**
4. Select: `chagas-ai/chagas-wppconnect`
5. Add environment variables:
   ```
   SECRET_KEY=<generate-random-key>
   NODE_ENV=production
   ```
6. Generate domain
7. Deploy!

Railway will use the existing `Dockerfile` and `railway.toml` configuration.

## Docker Image Publishing

The Docker image is automatically built and published when you push to `main` branch.

**Image Location**: `ghcr.io/chagas-ai/chagas-wppconnect:latest`

**Build Status**: Check [GitHub Actions](https://github.com/chagas-ai/chagas-wppconnect/actions)

## Environment Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `SECRET_KEY` | Yes | - | Secret for token generation |
| `NODE_ENV` | No | development | Environment mode |
| `PORT` | No | 21465 | Server port |

## API Documentation

Once deployed, access Swagger UI at:
```
https://your-domain.railway.app/api-docs
```

## Health Check

```bash
curl https://your-domain.railway.app/api/health
```

## Sync with Upstream

To sync with the original wppconnect-server repo:

```bash
# Add upstream remote
git remote add upstream https://github.com/wppconnect-team/wppconnect-server.git

# Fetch upstream changes
git fetch upstream

# Merge upstream main
git merge upstream/main

# Push to chagas-ai
git push origin main
```

This will trigger a new Docker image build automatically.

## Repository Structure

```
chagas-wppconnect/
├── .github/
│   └── workflows/
│       └── docker-publish.yml    # GitHub Actions for Docker builds
├── src/                          # WPPConnect source code
├── Dockerfile                    # Multi-stage Docker build
├── railway.toml                  # Railway deployment config
├── docker-compose.yml            # Local development
└── README.chagas.md             # This file
```

## License

Apache-2.0 (inherited from upstream wppconnect-server)

## Links

- **Upstream**: https://github.com/wppconnect-team/wppconnect-server
- **Docker Image**: https://github.com/chagas-ai/chagas-wppconnect/pkgs/container/chagas-wppconnect
- **Railway Project**: TBD
- **Original Docs**: https://wppconnect.io/

## Support

For WPPConnect-specific questions, refer to upstream:
- [WPPConnect Discord](https://discord.gg/wppconnect)
- [WPPConnect Docs](https://wppconnect.io/)

For Chagas AI deployment issues, contact the team.
