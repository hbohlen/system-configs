#./modules/system/hardware/asus-zephyrus-m16.nix
{ config, pkgs,... }:

{
  imports = [
    # Import the kernel patch for the 12th gen Intel suspend bug
   ./sleep.patch
  ];

  # Use the CachyOS kernel for optimal performance and hardware support
  boot.kernelPackages = pkgs.linuxPackages_cachyos;

  # NVIDIA Drivers with PRIME Offload
  services.xserver.videoDrivers = [ "modesetting" "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false; # Use the proprietary driver
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload.enable = true;
      enableOffloadCmd = true;
      # ❗ CRITICAL: Replace these with your actual Bus IDs!
      # Run `lspci | grep -E "VGA|3D"` in the installer to find them.
      intelBusId = "PCI:0:2:0";    # Example: 00:02.0
      nvidiaBusId = "PCI:1:0:0";   # Example: 01:00.0
    };
  };

  # ASUS Platform Tools
  services.asusd.enable = true;
  services.supergfxd.enable = true;

  # Battery charge limit to preserve health
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="power_supply", ATTR{charge_control_end_threshold}="80"
  '';

  # Power management daemon that works well with asusctl
  services.power-profiles-daemon.enable = true;

  # Bluetooth and Wi-Fi stability tweaks for the Intel AX211 card
  hardware.bluetooth.enable = true;
  boot.extraModprobeConfig = ''
    options iwlwifi bt_coex_active=0
  '';
}
