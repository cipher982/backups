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

### Jelly (Home Server) ✅
- Root filesystem (/) backup (~105GB)
- Targets (in priority order):
  - ✅ Local HDD (`/mnt/nas/backups`)
  - ✅ Synology NAS (via Tailscale)
  - 📅 B2 Cloud (planned)
- Implementation: CLI + systemd
- Configuration:
  - Exclusions: `hosts/jelly/config/kopia-excludes.txt`
  - Policy: `hosts/jelly/config/kopia-policy.json`
  - Schedule: Daily at 3 AM via systemd timer
  - Replication: Automatic after backup via `kopia-replicate.service`

### Clifford (Hetzner VPS) ✅
- Root filesystem (/) backup (~20GB compressed)
- Targets (in priority order):
  - ✅ Local disk (`/mnt/backup`, 60GB)
  - 🔜 Synology NAS (via Tailscale)
  - 📅 B2 Cloud (planned)
- Implementation: CLI + systemd
- Configuration:
  - Exclusions: `hosts/clifford/config/kopia-excludes.txt`
  - Policy: `hosts/clifford/config/kopia-policy.json`
  - Schedule: Daily at 3 AM via systemd timer

### Synology NAS ✅
- Central off-site backup location
- Receives backups via Tailscale from:
  - ✅ Jelly (`/drose/backups/kopia_sync`)
  - 🔜 Clifford
- Benefits:
  - True off-site storage
  - Fast access via Tailscale
  - No egress costs
- Implementation:
  - Native Kopia replication
  - SSH key authentication
  - Automatic sync after backups

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
- Check replication: `kopia repository sync-to sftp --host=richmcbnas --username=richmcb --path=/drose/backups/kopia_sync --keyfile=$HOME/.ssh/id_ed25519 --known-hosts=$HOME/.ssh/known_hosts --delete`
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
