{ config, pkgs, inputs, ... }:
{
    imports = [
        ./hardware-configuration.nix
        ../../commons/multimedia.nix
        ../../commons/gaming.nix
        ../../commons/development.nix
        ../../configuration.nix
    ];

    
    networking.hostName = "zeus"; # Define your hostname.

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    environment.systemPackages = with pkgs; [

        xfce.thunar
        waybar
        inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    ];

    programs.light.enable = true;
  
    programs.hyprland = {
        enable = true;
    };

    fonts.packages = with pkgs; [
        (nerdfonts.override { fonts = [ "Ubuntu" "FiraCode" "DroidSansMono" "SpaceMono" ]; })
    ];

    
    # #configure swapfiles and other machine specific configuration here: 
    # swapDevices = [{
    #     device = "/swapfile";
    #     size = 2 * 1024; # 16GB
    # }];

}
