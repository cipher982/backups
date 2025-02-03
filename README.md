# Backup Management

## Repository Structure
```
.
├── hosts/
│   ├── jelly/          # Home server
│   │   ├── config/     # Kopia config and scripts
│   │   └── logs/       # Backup logs
│   └── clifford/       # Hetzner VPS
│       ├── config/     # Kopia config and scripts
│       └── logs/       # Backup logs
└── shared/             # Shared configurations and scripts
```

## Hosts

### Jelly (Home Server)
- Daily kopia snapshot of entire system (/)
- Repository: `/mnt/nas/backups`
- Exclusions in `hosts/jelly/config/kopia-excludes.txt`

### Clifford (Hetzner VPS)
- Configuration pending
- Will use B2 for remote storage

## Common Configuration
- Full root filesystem (/) backup with smart exclusions
- Key areas backed up:
  - System configs and software
  - User data and settings
  - Custom configurations
  - Important documents

## Quick Reference
- Check recent: `kopia snapshot list --show-identical=false`
- Recovery process:
  1. Fresh OS install
  2. Install kopia
  3. Connect to backup repository
  4. Restore system files
