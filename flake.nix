{
    description = "My working Flake!";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-24.05";
        home-manager = {
            url = "github:nix-community/home-manager/release-24.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        hyprland.url = "github:hyprwm/Hyprland";

    };

    outputs = { self, nixpkgs, home-manager, ...}:
        let
            lib = nixpkgs.lib;
            system = "x86_64-linux";
            pkgs = nixpkgs.legacyPackages.${system};
            hyprlandModule = {
                wayland.windowManager.hyprland = {
                    enable = true;
                    # set the flake package
                    package = self.inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
                    settings = {
                        "$mod" = "SUPER";
                        bind =
                        [
                            "$mod, F, exec, firefox"
                            ", Print, exec, grimblast copy area"
                        ]
                        ++ (
                            # workspaces
                            # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
                            builtins.concatLists (builtins.genList (i:
                                let ws = i + 1;
                                in [
                                "$mod, code:1${toString i}, workspace, ${toString ws}"
                                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
                                ]
                            )
                            9)
                        );
                    };
                };
            };
        in {


            
            # homes configurations
            homeConfigurations = {
                decima = home-manager.lib.homeManagerConfiguration {
                    inherit pkgs;
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
                modules = [./machines/vm/configuration.nix];
            };
            ### DO NOT REMOVE OR MOVE THIS LINE : ADD MACHINE CONFIG OVER THIS LINE
        };
    };
}