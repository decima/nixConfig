{ config, pkgs, ... }:
{
    home.file = {
        ".wallpapers/1.png".source = ./wallhaven-rdkeoq.png;
        ".wallpapers/2.png".source = ./wallhaven-qd6175.png;
        ".wallpapers/3.png".source = ./wallhaven-5d2wl8.png;
        ".wallpapers/4.png".source = ./wallhaven-nkz927.png;
    };

    imports = [
      (import ./managers/hyprpaper.nix { 
        wallpaper = "/home/decima/.wallpapers/4.png";
        alternative = "/home/decima/.wallpapers/2.png";
      })
    ];
    
}