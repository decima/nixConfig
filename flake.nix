{
    description = "My working Flake!";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-24.05";
        home-manager = {
            url = "github:nix-community/home-manager/release-24.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        hyprland.url = "git+https://github.com/hyprwm/Hyprland/v0.42.0";
        hyprland-plugins = {
            url = "github:hyprwm/hyprland-plugins";
            inputs.hyprland.follows = "hyprland";
            };
    };

    outputs = { self, nixpkgs, home-manager,hyprland, ...}:
        let
            lib = nixpkgs.lib;
            system = "x86_64-linux";
            pkgs = nixpkgs.legacyPackages.${system};
            hyprlandModule = {
                wayland.windowManager.hyprland = {
                    enable = true;
                    # set the flake package
                    package = self.inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
                };
            };
        in {


            
            # homes configurations
            homeConfigurations = {
                decima = home-manager.lib.homeManagerConfiguration {
                    inherit pkgs;
                    extraSpecialArgs = {
                        inputs = self.inputs;
                    };
                    modules = [
                        hyprlandModule
                        ./homes/decima.nix
                    ];
                };
            };
        

        # system config
        nixosConfigurations = {
            vm = lib.nixosSystem {
                inherit system;
                extraArgs = {inputs = self.inputs;};
                modules = [./machines/vm/configuration.nix];
            };
            ### DO NOT REMOVE OR MOVE THIS LINE : ADD MACHINE CONFIG OVER THIS LINE
        };
    };
}