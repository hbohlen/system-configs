#./flake.nix
{
  description = "Hayden's Declarative NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    cachyos.url = "github:CachyOS/nixpkgs-cachyos";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, cachyos,... }@inputs: {
    nixosConfigurations = {
      "zephyrus-m16" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/zephyrus-m16/default.nix
        ];
      };
    };
  };
}
