{ config, pkgs, ... }:
{
    imports = [
        ./hardware-configuration.nix
        ../../commons/development.nix
        ../../configuration.nix
    ];
    networking.hostName = "zeus"; # Define your hostname.

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    environment.systemPackages = with pkgs; [
        discord-ptb
    ];

    programs.steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };
    # #configure swapfiles and other machine specific configuration here: 
    # swapDevices = [{
    #     device = "/swapfile";
    #     size = 2 * 1024; # 16GB
    # }];
}
