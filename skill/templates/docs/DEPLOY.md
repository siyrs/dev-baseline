# Deployment Guide

## Document Info
- Current version:
- Last updated:
- Deployment target:

## Deployment Overview
- 

## Runtime Topology
```text
Client -> Reverse Proxy -> Frontend -> Backend -> Database
```

## Environment Matrix

### Local
- 

### Staging
- 

### Production
- 

## Prerequisites
- Runtime:
- Database:
- External services:
- Secrets:

## Build
```bash
# build command
```

## Configuration
See [`./CONFIG.md`](./CONFIG.md)

## Run

### Local
```bash
# local start command
```

### Production
```bash
# production start command
```

## Health Check Commands
```bash
# Replace host and port with the real service address
curl -f http://localhost:<port>/health
```

## Verification Checklist
- [ ] Service starts successfully
- [ ] Health checks pass
- [ ] Core APIs work
- [ ] Logs look normal

## Rollback Plan
- Trigger:
- Steps:
- Data considerations:

## Troubleshooting

### 1. Issue
- Cause:
- Resolution:

## Related Release Notes
- See [`./CHANGELOG.md`](./CHANGELOG.md)
