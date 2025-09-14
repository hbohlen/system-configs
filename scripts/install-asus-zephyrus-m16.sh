#!/usr/bin/env bash
set -euo pipefail

# --- CONFIGURATION ---
# ❗ IMPORTANT: Verify this is your target disk. Use `lsblk` to confirm.
DISK="/dev/nvme0n1"

# --- SCRIPT ---
HOSTNAME="zephyrus-m16"
GITHUB_REPO="hbohlen/system-configs"

echo "===================================================================="
echo "⚠️ WARNING: This script will ERASE ALL DATA on ${DISK}."
echo "Please double-check that this is the correct disk before proceeding."
echo "===================================================================="
read -p "Press ENTER to continue or Ctrl+C to abort."

echo "--> Partitioning ${DISK}..."
sgdisk --zap-all "${DISK}"
parted --script "${DISK}" -- mklabel gpt \
  mkpart ESP fat32 1MiB 1GiB \
  mkpart swap linux-swap 1GiB 33GiB \
  mkpart root ext4 33GiB 100%
parted --script "${DISK}" -- set 1 esp on

# Wait for partitions to be recognized
sleep 2

# --- Formatting and Mounting ---
echo "--> Formatting partitions..."
mkfs.fat -F32 -n BOOT "${DISK}p1"
mkswap -L SWAP "${DISK}p2"
mkfs.ext4 -L ROOT "${DISK}p3"

echo "--> Mounting filesystems..."
mount /dev/disk/by-label/ROOT /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/BOOT /mnt/boot
swapon /dev/disk/by-label/SWAP

# --- NixOS Installation ---
echo "--> Generating hardware configuration..."
nixos-generate-config --root /mnt

echo "--> Cloning configuration from GitHub..."
# We need git to clone the repo
nix-shell -p git --command "git clone https://github.com/${GITHUB_REPO}.git /mnt/tmp-config"

echo "--> Preparing final configuration..."
# Move the generated hardware config into the cloned repo
mv /mnt/etc/nixos/hardware-configuration.nix /mnt/tmp-config/hosts/${HOSTNAME}/
# Replace the placeholder NixOS config with our own
rm -rf /mnt/etc/nixos
mv /mnt/tmp-config /mnt/etc/nixos

echo "--> Starting NixOS installation..."
# The --no-root-passwd flag is important for security
nixos-install --no-root-passwd --flake "/mnt/etc/nixos#${HOSTNAME}"

echo "✅ Installation complete! The system will reboot in 10 seconds."
sleep 10
reboot
