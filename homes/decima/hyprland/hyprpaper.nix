{ config, pkgs, ... }:
{

    home.file = {
        ".wallpapers/1.png".source = ./wallpapers/wallhaven-rdkeoq.png;
        ".wallpapers/2.png".source = ./wallpapers/wallhaven-qd6175.png;
        ".wallpapers/3.png".source = ./wallpapers/wallhaven-5d2wl8.png;
        ".wallpapers/4.png".source = ./wallpapers/wallhaven-nkz927.png;
    };

    wayland.windowManager.hyprland.settings."exec-once" = [
        "hyprpaper"
    ];

    services.hyprpaper = {
        enable = true;
            settings = {
                preload = [
                    "/home/decima/.wallpapers/4.png"
                ];
                wallpaper = [
                ",/home/decima/.wallpapers/4.png"
                ];
            };
        };

}