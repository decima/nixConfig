{ config, pkgs, ... }:

{

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [ bbenoist.nix ];
    userSettings = {
      "window.autoDetectColorScheme" = true; # use light theme when os is light
      "files.autoSave" = "afterDelay";
    };

  };

}
