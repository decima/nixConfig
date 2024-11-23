{ config, pkgs, ... }:
{

    programs.hyprlock = {
        enable = true;
        settings = {
            general = {
                disable_loading_bar = true;
                hide_cursor = false;
            };

            background = [
                {
                path = "/home/decima/.wallpapers/4.png";
                blur_passes = 0;
                blur_size = 4;
                color = "#fbdccb";
                brightness = 0.1;
                vibrancy = 1;

                }
            ];
            label = [
                {
                    text = "Hi there $USER";
                    font_size = "20";
                    font_family = "SpaceMono Nerd Font";
                    position = "0, 80";
                    halign = "center";
                    valign = "center";
                }
                {
                    text = ''cmd[update:1000] echo "<span>$(date)</span>"'';
                    font_size = "30";
                    font_family = "SpaceMono Nerd Font";
                    position = "0, 40";
                    halign = "center";
                    valign = "center";
                }
            ];
            input-field = [
                {
                size = "300, 50";
                position = "0, -80";
                monitor = "";
                dots_center = true;
                fade_on_empty = false;
                font_color = "##fbdccb";
                font_family = "SpaceMono Nerd Font";
                inner_color = "pink";
                outline_thickness = 0;
                placeholder_text = ''󰦝 Password required...'';
                dots_rounding = 0;
                }
            ];
        };
    };

    wayland.windowManager.hyprland.settings.bind = [
        "$mod, L, exec, hyprlock"
    ];

}