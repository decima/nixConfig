{ config, pkgs, lib, ... }:
let 
  novar="novar";
in
{

  imports = [
    ../commons/commons.nix
  ];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".shtools".source=./scripts.sh;
  };

  home.packages = with pkgs; [
    gnomeExtensions.forge
  ];

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/decima/etc/profile.d/hm-session-vars.sh
  #
  programs.bash.enable=true;
  programs.zsh.initExtraFirst=''
    export PATH=$PATH:/home/decima/projects/lumapps/core-go/scripts
    export PATH=$PATH:/home/decima/projects/lumapps/core-go/services/winston/scripts
    mkdir -p /home/decima/.local/bin/
    ln -sf /home/decima/projects/lumapps/core/local/scripts/open_psql_shell.py /home/decima/.local/bin/kubectl-psqlc
    export PATH=$PATH:/home/decima/.local/bin
    source /home/decima/.shtools
    '';

  dconf.settings = {
    "org/gnome/desktop/background" = {
        "picture-uri" = "/home/decima/.wallpapers/5.png";
    };
    "org/gnome/desktop/input-sources" = {
      show-all-sources = true;
      sources = [ (lib.hm.gvariant.mkTuple [ "xkb" "fr" ]) (lib.hm.gvariant.mkTuple [ "xkb" "us" ]) ];
      xkb-options=["compose:ralt"];
    };
  };

}
