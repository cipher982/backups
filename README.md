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

## Backup Architecture

### Jelly (Home Server) 🏃
- Root filesystem (/) backup (~105GB)
- Targets (in priority order):
  - ✅ Local HDD (`/mnt/nas/backups`)
  - 🔜 Synology NAS (via Tailscale)
  - 📅 B2 Cloud (planned)
- Current: Kopia GUI scheduler
- Planned: Migration to CLI + systemd
- Exclusions in `hosts/jelly/config/kopia-excludes.txt`

### Clifford (Hetzner VPS) 🆕
- Root filesystem (/) backup
- Targets (in priority order):
  - 🔜 Local disk (`/mnt/backup`, 60GB)
  - 🔜 Synology NAS (via Tailscale)
  - 📅 B2 Cloud (planned)
- Implementation: CLI + systemd
- Configuration pending

### Synology NAS 🆕
- Central off-site backup location
- Receives backups via Tailscale from:
  - 🔜 Jelly
  - 🔜 Clifford
- Benefits:
  - True off-site storage
  - Fast access via Tailscale
  - No egress costs

### B2 Cloud Storage 📅
- Final tier disaster recovery
- Optional for both systems
- Lowest priority implementation

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

## Legend
- ✅ Complete
- 🏃 In Progress
- 🔜 Next Up
- 🆕 New Addition
- 📅 Future Plan
