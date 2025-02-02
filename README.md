# Backup Management

## Current Setup
- Daily kopia snapshot at 4am: `/home/drose`
- Repository: `/mnt/nas/backups`
- Logs in `backup.log`

## Backup Sources
- `/home` (286G used)
- `/gemini` (6.1T used)
- `/rocket` (mostly empty, new)
- `/reel` (47G used)

## Include/Exclude
Include:
- Personal configs (~/.config, ~/.local)
- Custom scripts and tools
- Important documents
- System configs (/etc)

Skip:
- Git repos (.git)
- Conda envs
- AI models/datasets
- System dirs (/dev, /proc, /sys, /tmp, /run, /mnt, /media)
- Logs and cache (/var/log, /var/cache)

## Quick Reference
- Check recent: `kopia snapshot list --show-identical=false`
- GUI available on desktop
