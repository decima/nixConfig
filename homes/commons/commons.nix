{ config, pkgs, ... }:
let
  editor = "vim";
  shellAliases = {
    ".." = "cd ..";
  };
in
{

  imports = [
    ./git.nix
    ./vscode.nix
    ./hyprland/hyprland.nix
    ./kitty/kitty.nix

  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "decima";
  home.homeDirectory = "/home/decima";

  # dangerous stuff happens here.
  home.enableNixpkgsReleaseCheck = false;

  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    tig
    jq
    libheif
    gdrive3
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
    (writeShellScriptBin "ducks" (builtins.readFile ./scripts/ducks.sh))
    (writeShellScriptBin "jjqn" (builtins.readFile ./scripts/jjqn.sh))
    (writeShellScriptBin "kmlt" (builtins.readFile ./scripts/kmlt.sh))
  ];

  home.sessionVariables = {
    EDITOR = editor;
    NIXOS_OZONE_WL = 1;
  };

  programs.bash = {
    inherit shellAliases;
    enable = true;
  };

  programs.zsh = {
    inherit shellAliases;
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "gnzh";
      plugins = [
        "git"
        "sudo"
        "kubectl"
        "kubectx"
      ];
    };
  };

  dconf = {
    settings = {
      "org/gnome/mutter" = {
        "edge-tiling" = true;
      };
      "org/gnome/desktop/interface" = {
        "accent-color" = "pink";
        "color-scheme" = "default";
      };
    };
  };

  nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
