{ config, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ../../configuration.nix
    ];
    networking.hostName = "vm"; # Define your hostname.
    boot.loader.grub.enable = true;
    boot.loader.grub.device = "/dev/sda";
    boot.loader.grub.useOSProber = true;

    swapDevices = [{
        device = "/swapfile";
        size = 2 * 1024; # 16GB
    }];
}
