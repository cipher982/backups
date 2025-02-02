# Backup Management

## Current Setup
- Daily kopia snapshot of entire system (/)
- Repository: `/mnt/nas/backups`
- Exclusions in `kopia-excludes.txt`

## Backup Sources
- Full root filesystem (/) with smart exclusions
- Key areas:
  - System configs and software
  - User data and settings
  - Custom configurations
  - Important documents

## Include/Exclude
See `kopia-excludes.txt` for detailed exclusions:
- Virtual/temp filesystems
- Regeneratable data (caches, docker, etc)
- Separate mount points
- Development artifacts

## Quick Reference
- Check recent: `kopia snapshot list --show-identical=false`
- GUI available on desktop
- Recovery process:
  1. Fresh Ubuntu install
  2. Mount NAS
  3. Restore system files
