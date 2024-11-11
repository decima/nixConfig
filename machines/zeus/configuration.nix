{ config, pkgs, ... }:
{
    imports = [
        ./hardware-configuration.nix
        ../../configuration.nix
    ];
    networking.hostName = "zeus"; # Define your hostname.

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    environment.systemPackages = with pkgs; [
        discord-ptb
    ];

    # #configure swapfiles and other machine specific configuration here: 
    # swapDevices = [{
    #     device = "/swapfile";
    #     size = 2 * 1024; # 16GB
    # }];
}
