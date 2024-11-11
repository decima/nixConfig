{ config, pkgs, ... }:
{

    environment.systemPackages = with pkgs; [
        discord-ptb
        dwarf-fortress
        dwarf-fortress-packages.dwarf-fortress-full
        prismlauncher #this is minecraft launcher
        fallout-ce
        quake3e
        freeciv
    ];


      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };

    
}