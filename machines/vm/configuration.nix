{ config, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ../../configuration.nix
    ];
    networking.hostName = "vm"; # Define your hostname.
    swapDevices = [{
        device = "/swapfile";
        size = 2 * 1024; # 16GB
    }];
}