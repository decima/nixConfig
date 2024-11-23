{ wallpaper, ... }:
{ config, pkgs, ... }:
{



    wayland.windowManager.hyprland.settings."exec-once" = [
        "hyprpaper"
    ];

    services.hyprpaper = {
        enable = true;
            settings = {
                preload = [
                    wallpaper
                ];
                wallpaper = [
                ",${wallpaper}"
                ];
            };
        };

}