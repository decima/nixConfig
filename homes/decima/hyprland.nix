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

    wayland.windowManager.hyprland.enable = true;
    wayland.windowManager.hyprland.plugins = [
        # pkgs.hyprlandPlugins.hyprbars
        pkgs.hyprlandPlugins.hyprexpo
    ];

     wayland.windowManager.hyprland.settings.plugins ={
        # hyprbars={
        #     # example config
        #     bar_height = 24;
        #     bar_part_of_window = true;
        #     bar_precedence_over_border = true;
        #     # hyprbars-button = color, size, on-click
        #     hyprbars-button = [
        #         "rgba(3c3c3c00), 16, 󰖭, hyprctl dispatch killactive"
        #         # "rgba(3c3c3c00), 16, 󰖯, hyprctl dispatch fullscreen 1"
        #     ];
        # };
        hyprexpo = {
            workspace_method = "first 1";
            enable_gesture = true; # lapmtop touchpad, 4 fingers
            gesture_distance = 300; # how far is the "max"
            gesture_positive = true; # positive = swipe down. Negative = swipe up.

        };
     };


    wayland.windowManager.hyprland.settings.monitor = [
        "eDP-1, 1920x1080, 0x0, 1"
    ];
    
    wayland.windowManager.hyprland.settings.windowrulev2 = [
        "float, class:xdg-desktop-portal-gtk"
        "float, class:Rofi"
        #"size 300 300, class:Rofi"
        "center, class:Rofi"
        "stayfocused, class:Rofi"
        "plugin:hyprbars:nobar, class:Rofi"
        "plugin:hyprbars:nobar, class:xdg-desktop-portal-gtk"
        "float, class:.*"
        "size 800 600, class:xdg-desktop-portal-gtk"
    ];



    wayland.windowManager.hyprland.settings."exec-once" = [
        "hyprpaper"
        "waybar"
    ];


    wayland.windowManager.hyprland.settings = {
         # "$deltaWindowSize" = "54"; # with hyprbars
        "$deltaWindowSize"="34"; # with waybar
        "$moveStep" = "50";
        "$terminal" = "kitty";
        "$fileManager" = "thunar";
        "$menu" = "rofi -show drun";
        "$mod" = "SUPER";

        general = { 
            gaps_in = 5;
            gaps_out = 15;

            border_size = 4;

            # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
            "col.active_border" = "rgba(9cE0C8ff) rgba(B594B5ff) 45deg";
            "col.inactive_border" = "rgba(595959aa)";

            # Set to true enable resizing windows by clicking and dragging on borders and gaps
            resize_on_border = true; 
            extend_border_grab_area= 15;


            # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
            allow_tearing = false;
            layout = "dwindle";
        };

        decoration ={
            rounding = 4;

            # Change transparency of focused and unfocused windows
            active_opacity = 1.0;
            inactive_opacity = 1.0;

            drop_shadow = false;
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
    };

    wayland.windowManager.hyprland.settings.bindl=[
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ];

    wayland.windowManager.hyprland.settings.bindel=[
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86MonBrightnessUp, exec, light -A 5"
        ",XF86MonBrightnessDown, exec, light -U 5"
    ];
    
    wayland.windowManager.hyprland.settings.bind = [
        "$mod, Q, exec, $terminal"
        "$mod, M, exit"
        "$mod, E, exec, $fileManager"
        "$mod, C, killactive,"
        "$mod, F, exec, firefox"
        ", Print, exec, grimblast copy area"
        "$mod, B, exec, google-chrome-stable"
        "$mod, Space, exec,$menu"
        "$mod, grave, hyprexpo:expo, toggle"
        "$mod, Left, resizeactive, exact 50% 100%"
        "$mod, Left, resizeactive, 0 -$deltaWindowSize"
        "$mod, Left, moveactive, exact 0 $deltaWindowSize"
        
        "$mod, Right, resizeactive, exact 50% 100%"
        "$mod, Right, resizeactive, 0 -$deltaWindowSize"
        "$mod, Right, moveactive, exact 50% $deltaWindowSize"
        "$mod, Up, resizeactive, exact 100% 100%"
        "$mod, Up, resizeactive, 0 -$deltaWindowSize"
        "$mod, Up, moveactive, exact 0 $deltaWindowSize"

        "$mod, Down, resizeactive, exact 60% 60%"
        "$mod, Down, centerwindow,"
        "$mod Shift, Left, moveactive, -$moveStep 0"
        "$mod Shift, Right, moveactive, $moveStep 0"
        "$mod Shift, Up, moveactive, 0 -$moveStep"
        "$mod Shift, Down, moveactive, 0 $moveStep"
        "$mod Control_L, Left, resizeactive, $moveStep 0"
        "$mod Control_L, Left, moveactive, -$moveStep 0"
        "$mod Control_L, Right, resizeactive, $moveStep 0"
        "$mod Control_L, Up, resizeactive, 0 $moveStep"
        "$mod Control_L, Up, moveactive, 0 -$moveStep"
        "$mod Control_L, Down, resizeactive, 0 $moveStep"


        "$mod Shift Control_L, Right, resizeactive, -50 0"
        "$mod Shift Control_L, Right, moveactive, 50 0"
        "$mod Shift Control_L, Left, resizeactive, -50 0"
        "$mod Shift Control_L, Down, resizeactive, 0 -50"
        "$mod Shift Control_L, Down, moveactive, 0 50"
        "$mod Shift Control_L, Up, resizeactive, 0 -50"
        "ALT, Tab, cyclenext,"
        "ALT, Tab, bringactivetotop,"
        ",$mod, hyprexpo:expo, toggle"
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