#!/usr/bin/env bash
set -euo pipefail
trap 'echo "ERROR at line $LINENO. Check /tmp/nixos-install.log" >&2' ERR

DISK="$1"
LOGFILE="/tmp/nixos-install.log"

if [[ -z "$DISK" ]]; then
  echo "Usage: $0 /dev/nvme0n1 or /dev/sda"
  exit 1
fi

exec > >(tee -a "$LOGFILE") 2>&1

echo "Partitioning disk $DISK..."

sgdisk --zap-all "$DISK"
parted --script "$DISK" mklabel gpt
parted --script "$DISK" \
  mkpart ESP fat32 1MiB 1025MiB \
  mkpart swap linux-swap 1025MiB 41825MiB \
  mkpart primary ext4 41825MiB 100%

parted --script "$DISK" set 1 boot on
parted --script "$DISK" set 1 esp on

mkfs.fat -F32 "${DISK}p1"
mkswap "${DISK}p2"
swapon "${DISK}p2"
mkfs.ext4 -F "${DISK}p3"

mount "${DISK}p3" /mnt
mkdir -p /mnt/boot
mount "${DISK}p1" /mnt/boot

nixos-generate-config --root /mnt

# Optional: clone your config repo here
# git clone https://github.com/youruser/system-configs.git /mnt/etc/nixos

nixos-install --no-root-passwd

echo "Installation complete. Logs at $LOGFILE"