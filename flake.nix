{
      description = "My system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin = { url = "github:catppuccin/nix/release-25.05"; };
  };

  outputs = { nixpkgs, home-manager, nixvim, catppuccin, ... }: {
    nixosConfigurations.flo-gaming = nixpkgs.lib.nixosSystem {
      modules = [
        ./hosts/flo-gaming/configuration.nix
        catppuccin.nixosModules.catppuccin
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.florian.imports = [
            ./home
            nixvim.homeModules.nixvim
            catppuccin.homeModules.catppuccin
          ];
        }
      ];
    };

  };
}
