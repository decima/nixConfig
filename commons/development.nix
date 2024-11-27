{ config, pkgs, ... }:
{

    environment.systemPackages = with pkgs; [
        go
        jetbrains.goland

        ### php 8.3
        php83
        php83Packages.composer

        ### php 8.4
        # php84
        # php84Packages.composer

        symfony-cli
        jetbrains.phpstorm

        ### deno (replacing node?)
        # deno
        nodePackages.nodejs
        nodePackages.npm
        nodePackages.yarn
        nodePackages.sass

    ];

    programs.adb.enable = true;
    users.users.decima.extraGroups = ["adbusers"];
    
}