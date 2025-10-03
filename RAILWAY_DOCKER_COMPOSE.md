# Deploy to Railway with Docker Compose

Quick deployment guide using Docker Compose drag-and-drop on Railway.

## Method 1: Drag and Drop (Easiest - 2 minutes)

### Step 1: Prepare the File

Download or use the file: `docker-compose.railway.yml`

### Step 2: Deploy to Railway

1. **Go to Railway**: https://railway.app
2. **Switch Organization**: Select **chagas-ai** (top-left dropdown)
3. **Create New Project**: Click "New Project" button
4. **Drag and Drop**:
   - Drag `docker-compose.railway.yml` onto the Railway canvas
   - Railway will automatically import the service configuration
   - A new service named "wppconnect" will be created

### Step 3: Configure Environment Variables

Railway will automatically detect the required variables. Add them:

1. Click on the **wppconnect** service
2. Go to **Variables** tab
3. Click **"+ New Variable"**
4. Add the following:

**Required:**
```
SECRET_KEY=a49e2163f1a58e0c082982e00b7910371eab4dde7e2e7a70dd5b7c34e15034a0
```

**Optional:**
```
NODE_ENV=production
WEBHOOK_URL=https://your-webhook.com/endpoint
WEBHOOK_SECRET=your_webhook_secret
LOG_LEVEL=info
```

### Step 4: Generate Domain

1. Go to **Settings** → **Networking**
2. Click **"Generate Domain"**
3. Copy your domain (e.g., `wppconnect-production.up.railway.app`)

### Step 5: Deploy

1. Railway will automatically start building
2. Check **Deployments** tab for progress
3. Wait for "Deployment succeeded" message (~3-5 minutes)

### Step 6: Verify

Open your browser:
```
https://your-domain.railway.app/api-docs
```

Test health endpoint:
```bash
curl https://your-domain.railway.app/api/health
```

Expected response:
```json
{"status":"ok","timestamp":"2025-10-03T..."}
```

---

## Method 2: Deploy from GitHub (Recommended for Updates)

If you want automatic deployments on code changes:

1. **Railway Dashboard** → **New Project**
2. **Deploy from GitHub repo**
3. Select: `chagas-ai/chagas-wppconnect`
4. Railway auto-detects `Dockerfile` and builds from source
5. Add environment variables (same as above)
6. Generate domain
7. Deploy!

**Benefits:**
- Auto-redeploy on `git push`
- Full control over source code
- No need for pre-built Docker image

---

## Docker Compose Configuration Details

### Image Source

```yaml
image: davivilela/wppconnect:latest
```

Railway will:
- Pull from Docker Hub (once image is published)
- Or build from Dockerfile if image not found
- Cache for faster subsequent deployments

### Persistent Storage

```yaml
volumes:
  - wppconnect_tokens:/usr/src/wpp-server/tokens
```

Railway automatically creates and manages volumes for session token persistence.

**Important**: Railway volumes are **ephemeral** by default. For production:
- Consider using Railway PostgreSQL for token storage
- Or implement external storage (S3, etc.)

### Health Check

```yaml
healthcheck:
  test: ["CMD", "wget", "--quiet", "--tries=1", "--spider", "http://localhost:21465/api/health"]
  interval: 30s
  timeout: 10s
  retries: 3
  start_period: 40s
```

Railway uses this to:
- Verify deployment success
- Auto-restart failed containers
- Show service health status

### Port Configuration

```yaml
ports:
  - "21465:21465"
```

WPPConnect uses port **21465** by default. Railway will:
- Expose this port internally
- Proxy external traffic via generated domain
- Handle SSL/TLS automatically

---

## Environment Variables Reference

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `SECRET_KEY` | ✅ Yes | - | Secret key for API token generation |
| `NODE_ENV` | ❌ No | production | Environment mode |
| `PORT` | ❌ No | 21465 | Internal server port |
| `WEBHOOK_URL` | ❌ No | - | Webhook endpoint for messages |
| `WEBHOOK_SECRET` | ❌ No | - | Webhook authentication |
| `LOG_LEVEL` | ❌ No | info | Logging level (debug, info, warn, error) |

---

## Troubleshooting

### Build Fails

**Issue**: Docker image not found
**Solution**:
1. Wait for GitHub Actions to publish image: https://github.com/chagas-ai/chagas-wppconnect/actions
2. Or deploy from GitHub repo instead (Railway builds from source)

### Service Unhealthy

**Issue**: Health check failing
**Solution**:
1. Check deployment logs for errors
2. Verify `SECRET_KEY` is set
3. Ensure port 21465 is exposed
4. Check if container is actually starting

### Session Tokens Lost

**Issue**: WhatsApp sessions reset on redeploy
**Solution**:
- This is expected with Railway's ephemeral volumes
- For persistence, use PostgreSQL token storage
- Or accept re-authentication after deploys

### Port Issues

**Issue**: Can't access the service
**Solution**:
1. Verify domain is generated
2. Check deployment logs for port binding
3. Ensure service is listening on 21465
4. Railway will proxy external traffic automatically

---

## Post-Deployment

### 1. Test API

```bash
# Health check
curl https://your-domain.railway.app/api/health

# View Swagger docs
open https://your-domain.railway.app/api-docs
```

### 2. Generate API Token

Via Swagger UI or curl:

```bash
curl -X POST https://your-domain.railway.app/api/mySession/generate-token \
  -H "Content-Type: application/json" \
  -d '{"secret": "YOUR_SECRET_KEY"}'
```

### 3. Start WhatsApp Session

```bash
curl -X POST https://your-domain.railway.app/api/mySession/start-session \
  -H "Authorization: Bearer YOUR_TOKEN"
```

Scan the returned QR code with WhatsApp.

---

## Monitoring

### View Logs

```bash
# Using Railway CLI
railway logs --tail

# Or in Railway Dashboard
# Click service → Observability → Logs
```

### Check Metrics

Railway Dashboard → Service → Metrics

Monitor:
- CPU usage
- Memory usage
- Network traffic
- Request count

---

## Updating

### Update Docker Image

When a new image is published:

1. Railway Dashboard → Service
2. Deployments → "Redeploy"
3. Railway pulls latest `davivilela/wppconnect:latest`

### Update from GitHub

If deployed from GitHub:
- Just `git push` to main branch
- Railway auto-deploys

---

## Cost Estimate

**Railway Pricing (2025)**:
- Hobby Plan: $5/month (512MB RAM)
- Pro Plan: Pay-as-you-go

**Estimated Costs**:
- Single instance (1GB RAM): ~$10-15/month
- Includes: Compute, networking, storage
- Free $5 credit for new accounts

---

## Resources

- [Railway Docs](https://docs.railway.com/)
- [WPPConnect API Docs](https://wppconnect.io/)
- [GitHub Repository](https://github.com/chagas-ai/chagas-wppconnect)
- [Docker Image](https://hub.docker.com/r/davivilela/wppconnect)

---

## Quick Commands

```bash
# Generate SECRET_KEY
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"

# Test health locally
curl http://localhost:21465/api/health

# View Railway logs
railway logs

# Redeploy service
railway redeploy
```

---

## Success Checklist

- ✅ Docker Compose file uploaded to Railway
- ✅ Environment variables configured
- ✅ Domain generated
- ✅ Deployment succeeded
- ✅ Health check passing
- ✅ Swagger UI accessible
- ✅ API token generated
- ✅ WhatsApp session started

**You're ready to use WPPConnect on Railway!** 🚀
