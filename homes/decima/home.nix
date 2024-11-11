{ config, pkgs, ... }:
let 
  editor = "vim";
  shellAliases = {
      ".." = "cd ..";
    };
in
{
  
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "decima";
  home.homeDirectory = "/home/decima";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    tig
    jq
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    (writeShellScriptBin "jjqn" ''
      jq --unbuffered -R -r ". as \$line | try fromjson catch {\"jjq_error\": \$line}" | jq --unbuffered "''${1:-.}"
    '')
    (writeShellScriptBin "kmlt" ''
    	curl -s https://kaamelott.chaudie.re/api/random | jjqn
    '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
      ".wallpapers/1.png" = "./wallpapers/wallhaven-rdkeoq.png";
    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

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
  home.sessionVariables = {
    EDITOR = editor;
    NIXOS_OZONE_WL = 1;
  };

  programs.bash  = {
    inherit shellAliases;
    enable = true;
  };

  programs.zsh  = {
    inherit shellAliases;
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "gnzh";
      plugins = [
        "git"
        "sudo"
      ];
    };
  };

  programs.git = {
    enable = true;
    userName = "decima";
    userEmail = "h.larget@gmail.com";
    aliases = {
      logadog = "log --all --decorate --oneline --graph";
      br = "branch";
      co = "checkout";
      st = "status";
      tempo = "commit -a -m tempo";
      su = "submodule update --init --recursive";
      cp = "cherry-pick";
      please = "push --force-with-lease --force-if-includes";
      master = "!git checkout master && git pull && git checkout -";
    };
    extraConfig = {
      core.editor = editor;
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      url."git@github.com".insteadOf = "https://github.com";
      "tig \"bind\"".generic = [
        "r !git rebase -i %(commit)^"
        "p @sh -c \"echo -n %(commit) | xclip\""
      ]; 
      
    };

  };
  
  nixpkgs.config.allowUnfree = true;


  programs.vscode = {
  enable = true;
  extensions = with pkgs.vscode-extensions; [
    bbenoist.nix
  ];
};

  programs.kitty.enable = true; # required for the default Hyprland config
  wayland.windowManager.hyprland = {
    enable = true;
    settings =  {
      "$mod" = "SUPER";
      bind = [
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
    plugins = [
      pkgs.hyprlandPlugins.hyprbars
    ];

  };

  services.hyprpaper = {
    enable = true;
    ipc = "on";
    splash = false;
    splash_offset = 2.0;
    settings = {
        splash = false;
        wallpaper = [
          ",/home/decima/.wallpapers/1.png"
        ];
  };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;


}
