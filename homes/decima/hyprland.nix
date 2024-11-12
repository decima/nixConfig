{ config, pkgs, ... }:
{
    home.file = {
      ".wallpapers/1.png".source = ./wallpapers/wallhaven-rdkeoq.png;
      ".wallpapers/2.png".source = ./wallpapers/wallhaven-qd6175.png;
      ".config/waybar/config.jsonc".source = ./waybar.jsonc;
      ".config/waybar/style.css".source = ./waybar.css;
    };

    home.packages = with pkgs; [
        rofi
    ];

    programs.rofi = {
        enable = true;
        theme = "Arc-Dark";
    };

    wayland.windowManager.hyprland = {
        enable = true;
        settings =  {
            "$terminal" = "kitty";
            "$fileManager" = "thunar";
            "$menu" = "rofi -show drun";
            "$mod" = "SUPER";
            
            windowrulev2 = [  
                  "size 800 600, class:xdg-desktop-portal-gtk"            
                  "float, class:xdg-desktop-portal-gtk"
                  "float, class:Rofi"
                  #"size 300 300, class:Rofi"
                  "center, class:Rofi"
                  "stayfocused, class:Rofi"
                  "plugin:hyprbars:nobar, floating:1"
                  #"float, class:.*"
            ];

            general = { 
                gaps_in = 5;
                gaps_out = 15;

                border_size = 2;

                # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
                "col.active_border" = "rgba(ff3399ee) rgba(9933ffee) 45deg";
                "col.inactive_border" = "rgba(595959aa)";

                # Set to true enable resizing windows by clicking and dragging on borders and gaps
                resize_on_border = true; 
                no_border_on_floating = true;


                # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
                allow_tearing = false;
                layout = "dwindle";
            };

            decoration ={
                rounding = 4;

                # Change transparency of focused and unfocused windows
                active_opacity = 1.0;
                inactive_opacity = 1.0;

                drop_shadow = true;
                shadow_range = 4;
                shadow_render_power = 3;
                "col.shadow" = "rgba(1a1a1aee)";

                # https://wiki.hyprland.org/Configuring/Variables/#blur
                blur = {
                    enabled = true;
                    size = 3;
                    passes = 1;
                    vibrancy = 0.1696;
                };
            };

            "input" = {
                "kb_options" = "compose:ralt";
            };

            "exec-once" = [
                "hyprpaper"
                "waybar"
            ];

        monitor = [
                "eDP-1, 1920x1080, 0x0, 1"
            ];
    

            bind = [
                "$mod, Q, exec, $terminal"
                "$mod, M, exit"
                "$mod, E, exec, $fileManager"
                "$mod, C, killactive,"
                "$mod, F, exec, firefox"
                ", Print, exec, grimblast copy area"
                "$mod, B, exec, google-chrome-stable"
                "$mod, Space, exec,$menu"
                "$mod, grave, hyprexpo:expo, toggle"
                "ALT, Tab, cyclenext,"
                "ALT, Tab, bringactivetotop,"
                ]
            ++ (
                # workspaces
                # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
                builtins.concatLists (builtins.genList (i:
                    let ws = i + 1;
                    in [
                        "$mod, code:1${toString i}, workspace, ${toString ws}"
                        "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
                    ]
                    )
                    9)
            );
            plugin={
                hyprbars={
                    # example config
                    bar_height = 24;
                    bar_part_of_window = true;
                    bar_precedence_over_border = true;
                    # hyprbars-button = color, size, on-click
                    hyprbars-button = [
                        "rgba(3c3c3c00), 16, 󰖭, hyprctl dispatch killactive"
                        "rgba(3c3c3c00), 16, 󰖯, hyprctl dispatch fullscreen 1"
                    ];
                };
                hyprexpo = {
                    workspace_method = "first 1";
                    enable_gesture = true; # laptop touchpad, 4 fingers
                    gesture_distance = 300; # how far is the "max"
                    gesture_positive = true; # positive = swipe down. Negative = swipe up.

                };
            };

        };


        plugins = [
            pkgs.hyprlandPlugins.hyprbars
            pkgs.hyprlandPlugins.hyprexpo
        ];

    };

    services.hyprpaper = {
        enable = true;
        settings = {
            preload = "/home/decima/.wallpapers/2.png";
            wallpaper = [
            ",/home/decima/.wallpapers/2.png"
            ];
        };
    };


}