{ config, pkgs, ... }:
{

    environment.systemPackages = with pkgs; [
        spotify
        pulseaudioFull
        pavucontrol
        sway-contrib.grimshot #screenshots
        playerctl
        alsa-utils
    ];

    
}