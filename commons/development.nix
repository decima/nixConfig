{ config, pkgs, inputs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    inputs.antigravity.packages.${pkgs.system}.default
    openssl
    # utils
    insomnia

    # C
    gcc

    # golang
    go
    jetbrains.goland

    ### php 8.3
    #php83
    #php83Packages.composer

    ### php 8.4
    php84
    php84Packages.composer

    symfony-cli
    jetbrains.phpstorm

    ### deno (replacing node?)
    # deno
    nodePackages.nodejs
    nodePackages.npm
    nodePackages.yarn
    nodePackages.sass


    jetbrains.datagrip

    # jetbrains-toolbox
    
    terminator

    gemini-cli

    (writeShellScriptBin "docker-compose" ''
      docker compose "$@"
    '')
    
  ];

  programs.adb.enable = true;
  users.users.decima.extraGroups = [ "adbusers" ];

}
