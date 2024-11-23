{ config, pkgs, ... }:
{

    environment.systemPackages = with pkgs; [
        go
        jetbrains.goland

        php83
        symfony-cli
        jetbrains.phpstorm        
    ];

    programs.adb.enable = true;
    users.users.decima.extraGroups = ["adbusers"];
    
}