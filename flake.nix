{
  description = "My system flake";

  inputs = {
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixvim,
      nix-darwin,
      nix-homebrew,
      self,
      ...
    }:
    {
      nixosConfigurations.flo-gaming = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/flo-gaming/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.florian.imports = [
              ./hosts/flo-gaming/home
              nixvim.homeModules.nixvim
            ];
          }
        ];
      };

      darwinConfigurations."Florians-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit self; };
        modules = [
          ./hosts/macbook-pro/configuration.nix
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;

              # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
              enableRosetta = true;

              # User owning the Homebrew prefix
              user = "florianstutzky";

            };
          }
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.florianstutzky.imports = [
              ./hosts/macbook-pro/home
              nixvim.homeModules.nixvim
            ];
          }
        ];
      };

    };
}
