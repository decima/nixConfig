{ config, pkgs, inputs, ... }:
{
    imports = [
        ./hardware-configuration.nix
        ../../commons/multimedia.nix
        ../../commons/gaming.nix
        ../../commons/development.nix
        ../../commons/temp.nix
        ../../configuration.nix
        ./graphics.nix
    ];

    
    networking.hostName = "zeus"; # Define your hostname.


    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    environment.systemPackages = with pkgs; [
        libnotify
        waybar
        inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
        transmission_4-qt
    ];

    programs.light.enable = true;
  
    programs.hyprland.enable = true;
    programs.hyprlock.enable = true;

    fonts.packages = with pkgs; [
        nerd-fonts.ubuntu
        nerd-fonts.fira-code
        nerd-fonts.droid-sans-mono
        nerd-fonts.space-mono
    ];


    services.udev.extraRules=''
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="100", TAG+="uaccess", TAG+="udev-acl"
    '';

    
    # #configure swapfiles and other machine specific configuration here: 
    # swapDevices = [{
    #     device = "/swapfile";
    #     size = 2 * 1024; # 16GB
    # }];

}
