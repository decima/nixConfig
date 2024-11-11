{ config, pkgs, ... }:
{

    environment.systemPackages = with pkgs; [
        jetbrains.goland
        jetbrains.phpstorm
    ];
    
}