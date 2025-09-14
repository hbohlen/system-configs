#./modules/system/hardware/asus-zephyrus-m16.nix
{ inputs, config, pkgs,... }:

{
  imports = [
    # Import the kernel patch for the 12th gen Intel suspend bug
    ./sleep.patch

    # NixOS hardware modules for better compatibility
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-prime
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  # Use the CachyOS kernel for optimal performance and hardware support
  # boot.kernelPackages = inputs.cachyos.legacyPackages.${pkgs.system}.linuxPackages_cachyos;

  # NVIDIA PRIME configuration
  hardware.nvidia.prime = {
    # ❗ CRITICAL: Replace these with your actual Bus IDs!
    # Run `lspci | grep -E "VGA|3D"` in the installer to find them.
    intelBusId = "PCI:0:2:0";    # Example: 00:02.0
    nvidiaBusId = "PCI:1:0:0";   # Example: 01:00.0
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
