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
- Root filesystem (/) backup (~108.5GB)
- Targets (in priority order):
  - ✅ Local HDD (`/mnt/nas/backups`)
  - ✅ Synology NAS (via Tailscale)
  - 📅 B2 Cloud (planned)
- Implementation: CLI + systemd
- Configuration:
  - Exclusions: Symlinked from repo to `/.kopiaignore`
    ```bash
    # Critical: This symlink enables excludes to work
    /.kopiaignore -> /home/drose/git/backups/hosts/jelly/config/kopia-excludes.txt
    ```
  - Policy: `hosts/jelly/config/kopia-policy.json`
  - Schedule: Daily at 3 AM via systemd timer
  - Replication: Automatic after backup via `kopia-sync.service`

### Clifford (Hetzner VPS) ✅
- Root filesystem (/) backup (~21GB compressed)
- Targets (in priority order):
  - ✅ Local disk (`/mnt/backup`, 64GB)
    - Auto-mounted via fstab
    - Repository initialized and working
    - Proper permissions handled by systemd service
  - ✅ Synology NAS (via Tailscale)
  - 📅 B2 Cloud (planned)
- Implementation: CLI + systemd
- Configuration:
  - ✅ Daily backups at 3 AM via systemd timer
  - ✅ Minimal exclusions (virtual fs, tmp, docker special files)
  - ✅ Policy configured for retention and compression
  - ✅ Replication setup and working

### Synology NAS ✅
- Central off-site backup location
- Receives backups via Tailscale from:
  - ✅ Jelly (`/drose/backups/jelly`)
  - 🔜 Clifford
- Benefits:
  - True off-site storage
  - Fast access via Tailscale
  - No egress costs
- Implementation:
  - Direct SFTP repository sync
  - SSH key authentication
  - Automatic sync after backups
- Path Structure:
  - SFTP access: `/drose/backups/...`
  - Filesystem: `/volume1/homes/richmcb/drose/backups/...`

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
- Check status: `./hosts/jelly/config/check-kopia.sh`
- Check recent: `sudo -u root kopia snapshot list --show-identical=false --all`
- Check replication: `sudo -u root kopia repository sync-to sftp --host=richmcbnas --username=richmcb --path=/drose/backups/jelly --keyfile=$HOME/.ssh/id_ed25519 --known-hosts=/home/drose/.ssh/known_hosts --delete`
- Check excludes are working:
  ```bash
  # Should show symlink to our excludes file
  ls -la /.kopiaignore
  ```
- Recovery process:
  1. Fresh OS install
  2. Install kopia
  3. Connect to backup repository
  4. Restore system files

## Important Notes
- Kopia uses `.kopiaignore` files for exclusions
- Our excludes MUST be symlinked to root as `/.kopiaignore`
- DO NOT add exclude flags to systemd services
- Test excludes with `kopia snapshot create --dry-run /`

## Legend
- ✅ Complete
- 🏃 In Progress
- 🔜 Next Up
- 🆕 New Addition
- 📅 Future Plan
