# Mirror Setup Guide - GitLab & Codeberg

This document describes how to set up repository and container registry mirroring to GitLab and Codeberg.

## Overview

The audiobookshelf project automatically mirrors:
1. **Repository** - Full Git history to GitLab and Codeberg
2. **Container Images** - Docker images to GitLab Container Registry and Codeberg Registry

## Prerequisites

### GitLab Setup

1. **Create GitLab Account**
   - Go to https://gitlab.com
   - Create account or sign in

2. **Create GitLab Repository**
   - Create new project: `audiobookshelf`
   - Set to Public or Private as desired
   - Initialize empty (no README/License)

3. **Generate GitLab Access Token**
   - Go to: Settings → Access Tokens
   - Name: `GitHub Mirror Sync`
   - Scopes:
     - ✅ `write_repository` (for git push)
     - ✅ `write_registry` (for container push)
   - Expiration: 1 year (or as desired)
   - Click "Create personal access token"
   - **Save the token securely** - shown only once!

### Codeberg Setup

1. **Create Codeberg Account**
   - Go to https://codeberg.org
   - Create account or sign in

2. **Create Codeberg Repository**
   - Create new repository: `audiobookshelf`
   - Set to Public or Private
   - Initialize empty (no README/License)

3. **Generate Codeberg Access Token**
   - Go to: Settings → Applications → Manage Access Tokens
   - Generate New Token
   - Name: `GitHub Mirror Sync`
   - Scopes:
     - ✅ `write:repository` (for git push)
     - ✅ `write:package` (for container push)
   - Click "Generate Token"
   - **Save the token securely** - shown only once!

## GitHub Secrets Configuration

Add the following secrets to your GitHub repository:

**Navigate to:** Repository Settings → Secrets and variables → Actions → New repository secret

### Required Secrets

| Secret Name | Description | Example |
|-------------|-------------|---------|
| `GITLAB_USERNAME` | Your GitLab username | `mildman1848` |
| `GITLAB_TOKEN` | GitLab Personal Access Token | `glpat-xxxxxxxxxxxx` |
| `CODEBERG_USERNAME` | Your Codeberg username | `mildman1848` |
| `CODEBERG_TOKEN` | Codeberg Access Token | `xxxxxxxxxxxxxxxx` |

**Note:** These secrets are used by GitHub Actions workflows and are never exposed in logs.

## Workflows

### 1. Repository Mirror Sync (`.github/workflows/mirror-sync.yml`)

**Triggers:**
- Push to `main` or `develop` branches
- Tag creation (`v*`)
- Every 6 hours (scheduled)
- Manual dispatch

**What it does:**
- Mirrors full Git history to GitLab
- Mirrors full Git history to Codeberg
- Includes all branches and tags

**Manual Trigger:**
```bash
gh workflow run mirror-sync.yml
```

### 2. Container Registry Mirror (`.github/workflows/mirror-registry.yml`)

**Triggers:**
- After successful "Docker Build & Publish" workflow
- Release published
- Manual dispatch

**What it does:**
- Pulls images from GitHub Container Registry (GHCR)
- Pushes to GitLab Container Registry
- Pushes to Codeberg Container Registry
- Mirrors both version tags and `latest` tag

**Manual Trigger:**
```bash
gh workflow run mirror-registry.yml --field source_tag=2.30.0
```

## Accessing Mirrored Resources

### GitLab

**Repository:**
```
https://gitlab.com/<GITLAB_USERNAME>/audiobookshelf
```

**Container Registry:**
```bash
# Pull from GitLab
docker pull registry.gitlab.com/<GITLAB_USERNAME>/audiobookshelf:latest
docker pull registry.gitlab.com/<GITLAB_USERNAME>/audiobookshelf:2.30.0
```

### Codeberg

**Repository:**
```
https://codeberg.org/<CODEBERG_USERNAME>/audiobookshelf
```

**Container Registry:**
```bash
# Pull from Codeberg
docker pull codeberg.org/<CODEBERG_USERNAME>/audiobookshelf:latest
docker pull codeberg.org/<CODEBERG_USERNAME>/audiobookshelf:2.30.0
```

## Monitoring

### Check Mirror Status

**GitHub Actions:**
- Go to: Actions → Mirror Sync to GitLab and Codeberg
- Go to: Actions → Mirror Container Images to GitLab & Codeberg

**View Logs:**
```bash
# Recent mirror sync runs
gh run list --workflow=mirror-sync.yml --limit 5

# Recent container mirror runs
gh run list --workflow=mirror-registry.yml --limit 5

# View specific run
gh run view <run-id>
```

## Troubleshooting

### Repository Mirror Fails

**Check:**
1. GitLab/Codeberg repository exists and is accessible
2. Access tokens have correct permissions
3. GitHub secrets are correctly configured
4. Repository URLs in workflow match your setup

**Fix:**
```bash
# Test GitLab authentication locally
git clone https://gitlab.com/<USERNAME>/audiobookshelf.git
cd audiobookshelf
git remote add github https://github.com/mildman1848/audiobookshelf.git
git pull github main
git push origin main

# Test Codeberg authentication
git clone https://codeberg.org/<USERNAME>/audiobookshelf.git
```

### Container Mirror Fails

**Check:**
1. Container registries are enabled on GitLab/Codeberg
2. Access tokens have `write_registry`/`write:package` permissions
3. GHCR image exists and is public/accessible
4. Registry login credentials are correct

**Fix:**
```bash
# Test GitLab Container Registry access
echo $GITLAB_TOKEN | docker login registry.gitlab.com -u $GITLAB_USERNAME --password-stdin
docker pull ghcr.io/mildman1848/audiobookshelf:latest
docker tag ghcr.io/mildman1848/audiobookshelf:latest registry.gitlab.com/$GITLAB_USERNAME/audiobookshelf:latest
docker push registry.gitlab.com/$GITLAB_USERNAME/audiobookshelf:latest

# Test Codeberg Container Registry access
echo $CODEBERG_TOKEN | docker login codeberg.org -u $CODEBERG_USERNAME --password-stdin
docker pull ghcr.io/mildman1848/audiobookshelf:latest
docker tag ghcr.io/mildman1848/audiobookshelf:latest codeberg.org/$CODEBERG_USERNAME/audiobookshelf:latest
docker push codeberg.org/$CODEBERG_USERNAME/audiobookshelf:latest
```

### Token Expired

**Symptoms:**
- Mirror workflows fail with authentication errors
- Error: "Authentication failed" or "401 Unauthorized"

**Fix:**
1. Generate new access token on GitLab/Codeberg
2. Update GitHub secret with new token
3. Re-run failed workflow

## Security Considerations

1. **Access Tokens**
   - Store tokens as GitHub Secrets only
   - Never commit tokens to repository
   - Use tokens with minimum required permissions
   - Set expiration dates and rotate regularly

2. **Repository Access**
   - GitLab/Codeberg repositories can be private
   - Mirror workflows run with limited permissions
   - Secrets are masked in logs

3. **Container Registry**
   - GitLab/Codeberg registries support private images
   - Push authentication required
   - Pull can be public or private

## Benefits of Mirroring

1. **Redundancy** - Multiple backups across platforms
2. **Accessibility** - Users can choose their preferred platform
3. **Discoverability** - Increased project visibility
4. **Compliance** - Some organizations prefer specific platforms
5. **Regional Performance** - Closer servers for some users

## Maintenance

### Regular Tasks

- **Monthly:** Check mirror sync status
- **Quarterly:** Verify all mirrors are up to date
- **Yearly:** Rotate access tokens before expiration

### Disabling Mirrors

To disable mirroring:
1. Remove GitLab/Codeberg secrets from GitHub
2. Disable workflows in repository settings
3. Archive or delete mirrored repositories if no longer needed

---

**Last Updated:** 2025-10-12
**Maintained by:** mildman1848
**Related:** [README.md](../README.md), [CLAUDE.md](../CLAUDE.md)
