{ config, pkgs,pkgs-stable, ... }:
let
  nixpkgsCustom =
    import
      (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/21808d22b1cda1898b71cf1a1beb524a97add2c4.tar.gz";
        sha256 = "0v2z6jphhbk1ik7fqhlfnihcyff5np9wb3pv19j9qb9mpildx0cg";
      })
      {

        system = pkgs.system;
        config = config.nixpkgs.config;
      };
  golangciLintCustom = nixpkgsCustom.golangci-lint;

in
{

nixpkgs.overlays = [
    (final: prev: {
      # Recreate the 'jetbrains' attribute set,
      # but replace its 'jdk' with an overridden version.
      jetbrains = prev.jetbrains // {
        jdk = prev.jetbrains.jdk.overrideAttrs (oldJdk: {
          # This injects the missing BOOT_JDK variable.
          preConfigure = ''
            export BOOT_JDK=${prev.jdk11}
          '' + (oldJdk.preConfigure or "");
        });
      };
    })
  ];


  environment.systemPackages = with pkgs; [
    slack
    teams-for-linux
    kubectl
    kubectx
    kubelogin
    kubernetes-helm
    (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    #azure-cli
    postgresql_14

    asdf-vm
    python312Full
    
    python312Packages.uv
    python312Packages.pyenchant
    python312Packages.venvShellHook
    python312Packages.psycopg2
    python312Packages.pylint
    python312Packages.typer
    fzf
    jetbrains.pycharm-community

    golangciLintCustom
    gofumpt

    mesa
    libGL
    libGLU

    lens
    # kind
    argocd

    yq-go
    pkgs-stable.azure-cli

    burpsuite

  ];

  programs.nix-ld.enable = true;

}
