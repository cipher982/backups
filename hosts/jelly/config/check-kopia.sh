#!/bin/bash

echo "🔍 Checking Kopia Setup on Jelly"
echo "================================"

echo -e "\n1. User Config (should NOT exist):"
if [ -d "$HOME/.config/kopia" ]; then
    echo "❌ Warning: User-level Kopia config exists at $HOME/.config/kopia"
    echo "   This might cause confusion. Consider removing it with: rm -rf ~/.config/kopia"
else
    echo "✅ Good: No user-level Kopia config"
fi

echo -e "\n2. Root Config (should exist):"
if sudo test -f "/root/.config/kopia/repository.config"; then
    echo "✅ Good: Root Kopia config exists"
    echo "   Location: /root/.config/kopia/repository.config"
else
    echo "❌ Error: No root Kopia config found!"
fi

echo -e "\n3. Backup Directory:"
if [ -d "/mnt/nas/backups" ]; then
    echo "✅ Good: Backup directory exists"
    echo "   Location: /mnt/nas/backups"
    TOTAL_SIZE=$(sudo du -s /mnt/nas/backups | cut -f1)
    TOTAL_SIZE_HUMAN=$(numfmt --to=iec-i --suffix=B --format="%.1f" $(($TOTAL_SIZE * 1024)))
    echo "   Size: $TOTAL_SIZE_HUMAN"
else
    echo "❌ Error: Backup directory not found!"
fi

echo -e "\n4. Systemd Services:"
echo "a) Backup Service:"
systemctl status kopia-backup.service --no-pager | grep -E "Active:|●"
echo -e "\nb) Sync Service:"
systemctl status kopia-sync.service --no-pager | grep -E "Active:|●"

echo -e "\n5. Last Backup Status:"
sudo -u root kopia snapshot list --show-identical=false | tail -n 1

echo -e "\nDone!" 