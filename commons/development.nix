{ config, pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [

    openssl
    # utils
    insomnia

    # C
    gcc

    # golang
    go
    gccgo14
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
    nodePackages.nodejs
    nodePackages.npm
    nodePackages.yarn
    nodePackages.sass
    ### bun

    # jetbrains.datagrip

    # jetbrains-toolbox
    
    terminator

    (writeShellScriptBin "docker-compose" ''
      docker compose "$@"
    '')

  ];

  programs.adb.enable = true;
  users.users.decima.extraGroups = [ "adbusers" ];

  services.dnsmasq = {
    enable = true;
    settings.address = [ 
      "/dev.local/127.0.0.1"
     ];
  };
}
