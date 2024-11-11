{ config, pkgs, ... }:
{

    environment.systemPackages = with pkgs; [
        jetbrains.goland
        jetbrains.phpstorm
        php83
        go
    ];
    
}