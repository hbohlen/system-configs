#./modules/home-manager/hbohlen.nix
{ pkgs,... }:

{
  home.username = "hbohlen";
  home.homeDirectory = "/home/hbohlen";
  home.stateVersion = "25.05";

  # User-level packages
  home.packages = with pkgs; [
    neovim
  ];

  # Git configuration
  programs.git = {
    enable = true;
    userName = "Hayden Bohlen";
    userEmail = "bohlenhayden@gmail.com";
  };

  # Zsh shell configuration
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      update = "sudo nixos-rebuild switch --flake ~/system-configs#zephyrus-m16";
      ll = "ls -alh";
    };
  };

  programs.home-manager.enable = true;
}
