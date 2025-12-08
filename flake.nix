{
  description = "My working Flake!";

  inputs = {
    #nixpkgs.url = "nixpkgs/nixos-24.11";
    #home-manager.url = "github:nix-community/home-manager/release-24.11";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-25.05";

    antigravity.url = "path:./apps/antigravity";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      ...
    }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      inputs = self.inputs;
      pkgs = nixpkgs.legacyPackages.${system};
      nixpkgsStable = nixpkgs-stable;
    in
    {

      # homes configurations
      homeConfigurations = {
        "decima@zeus" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./homes/decima_zeus/home.nix ];
        };
        "decima@lumie" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./homes/decima_lumie/home.nix ];
        };
      };

      # system config
      nixosConfigurations = {
        vm = lib.nixosSystem {
          inherit system;
          modules = [ ./machines/vm/configuration.nix ];
        };
        zeus = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [ ./machines/zeus/configuration.nix ];
        };
        lumie = lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            pkgs-stable = import nixpkgsStable {
              inherit system;
              config.allowUnfree = true;
            };
          };
          modules = [ ./machines/lumie/configuration.nix ];
        };
        ### DO NOT REMOVE OR MOVE THIS LINE : ADD MACHINE CONFIG OVER THIS LINE
      };
    };
}
