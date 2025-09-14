{ config, pkgs, ... }:
{
  services.tlp.enable = true;  # Power management
  services.xserver.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  hardware.bluetooth.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_6_12;  # Newer kernel for hardware support
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;
  boot.kernelParams = [ "amd_iommu=on" "quiet" ];
  zramSwap.enable = true;
  swapDevices = [{ device = "/swapfile"; size = 24 * 1024; }];
  # Additional laptop-specific tweaks
}