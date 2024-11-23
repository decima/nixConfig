{ config, pkgs, ... }:
{

    environment.systemPackages = with pkgs; [
        jetbrains.goland
        jetbrains.phpstorm
        php83
        go
    ];

    programs.adb.enable = true;
    users.users.decima.extraGroups = ["adbusers"];
    
}