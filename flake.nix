{
    description = "My working Flake!";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-24.05";
        home-manager.url = "github:nix-community/home-manager/release-24.05";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
        hyprland-contrib = {
            url = "github:hyprwm/contrib";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, home-manager, ...}:
        let
            lib = nixpkgs.lib;
            system = "x86_64-linux";
            inputs = self.inputs;
            pkgs = nixpkgs.legacyPackages.${system};
        in {


            
            # homes configurations
            homeConfigurations = {
                decima = home-manager.lib.homeManagerConfiguration {
                    inherit pkgs;
                    modules = [./homes/decima/home.nix];
                };
            };
        

        # system config
        nixosConfigurations = {
            vm = lib.nixosSystem {
                inherit system;
                modules = [./machines/vm/configuration.nix];
            };
            zeus = lib.nixosSystem { 
                inherit system; 
                specialArgs = {inherit inputs;};
                modules = [./machines/zeus/configuration.nix]; 
            };

            ### DO NOT REMOVE OR MOVE THIS LINE : ADD MACHINE CONFIG OVER THIS LINE
        };
    };
}
