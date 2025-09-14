{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ vim git curl ];
  services.openssh.enable = true;
  system.stateVersion = "25.05";
  networking.networkmanager.enable = true;
  # Common system-wide config
}