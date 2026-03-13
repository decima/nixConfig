{ config, pkgs,pkgs-stable,lib, ... }:
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
programs.bash.shellAliases = {
  "sbire" = "VERTEX_LOCATION=global GOOGLE_CLOUD_PROJECT=lumapps-dev-ai-tooling opencode";
};

programs.zsh.shellAliases = {
  "sbire" = "VERTEX_LOCATION=global GOOGLE_CLOUD_PROJECT=lumapps-dev-ai-tooling opencode";
};
services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # 2. Enable XDG Desktop Portals
  # This acts as the bridge between Chrome and the OS
  
  services.gnome.gnome-remote-desktop.enable = true;
      # services.displayManager.gdm = {
      #     enable = true;
      #     wayland = true;
      # };  services.desktopManager.gnome.enable = true;
  services.xserver.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
  };




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
    albert
    xdg-desktop-portal-gnome
    xfce.xfce4-xkb-plugin
    xfce.xfce4-battery-plugin
    xfce.xfce4-windowck-plugin
    xfce.xfce4-whiskermenu-plugin
    skippy-xd

    opencode
    
    pidgin
    slack
    teams-for-linux
    kubectl
    kubectx
    kubelogin
    kubernetes-helm
    (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    #azure-cli
    postgresql_17

    asdf-vm
    python3
    
    python3Packages.uv
    python3Packages.pyenchant
    python3Packages.venvShellHook
    python3Packages.psycopg2
    python3Packages.pylint
    python3Packages.typer
    fzf
    jetbrains.pycharm

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

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];

  fonts.fontconfig.enable = true;

  programs.nix-ld.enable = true;

}
