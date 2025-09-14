#./modules/system/gnome.nix
{ pkgs,... }:

{
  # Enable GNOME Desktop Environment
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # System-level applications
  environment.systemPackages = with pkgs; [
    git
    vivaldi
    zed-editor
  ];
}
