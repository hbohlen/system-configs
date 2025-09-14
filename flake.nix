{
  description = "Multi-device NixOS configurations";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

  outputs = { self, nixpkgs }: {
    nixosConfigurations = {
      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./modules/base.nix ./modules/laptop.nix ./hardware/laptop.nix ];
      };
      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./modules/base.nix ./modules/desktop.nix ./hardware/desktop.nix ];
      };
      vps = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./modules/base.nix ./modules/vps.nix ./hardware/vps.nix ];
      };
    };
  };
}