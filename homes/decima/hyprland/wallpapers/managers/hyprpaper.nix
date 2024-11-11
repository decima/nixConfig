{ wallpaper, alternative, ... }:
{ config, pkgs, ... }:
{



    wayland.windowManager.hyprland.settings."exec-once" = [
        "hyprpaper"
    ];

    services.hyprpaper = {
        enable = true;
            settings = {
                preload = [
                    alternative
                    wallpaper
                ];
                wallpaper = [

                    ",${alternative}"
                    "eDP-1,${wallpaper}"
                ];
            };
        };

}