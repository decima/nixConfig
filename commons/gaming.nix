{ config, pkgs, ... }:
{

    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [
        xorg.libX11
        xorg.libXcursor
        xorg.libXext
        #xorg.libXi.dev
        xorg.libXi
        # Add any missing dynamic libraries for unpackaged programs
        # here, NOT in environment.systemPackages
    ];

    environment.systemPackages = with pkgs; [
        discord-ptb
        prismlauncher #this is minecraft launcher
        bsdgames
        angband
    ];


      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };

    
}
