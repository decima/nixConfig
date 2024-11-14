{ config, pkgs, ... }:
{
    imports = [
        ../eww/eww.nix
    ];

    home.file = {
      ".wallpapers/1.png".source = ./wallpapers/wallhaven-rdkeoq.png;
      ".wallpapers/2.png".source = ./wallpapers/wallhaven-qd6175.png;
      ".wallpapers/3.png".source = ./wallpapers/wallhaven-5d2wl8.png;
      ".wallpapers/4.png".source = ./wallpapers/wallhaven-nkz927.png;
    };

    home.packages = with pkgs; [
        rofi
        
        (writeShellScriptBin "awt" (builtins.readFile ./scripts/awt.sh))    
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
    ];


    wayland.windowManager.hyprland.settings = {
         # "$deltaWindowSize" = "54"; # with hyprbars
        #"$deltaWindowSize"="34"; # with waybar
        "$deltaWindowSize" = 60;
        "$moveStep" = "50";
        "$terminal" = "kitty";
        "$fileManager" = "thunar";
        "$menu" = "rofi -show drun";
        "$mod" = "SUPER";

        general = { 
            gaps_in = 5;
            gaps_out = "34,4,4,4";

            border_size = 6;

            # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
            #"col.active_border" = "rgba(ffffff66) rgba(00000066) 45deg";
            "col.active_border" = "rgba(ffffff99) rgba(ffffff66) 45deg";
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

        "$mod Shift, Left, exec,  awt move left"
        "$mod Shift, Right, exec, awt move right"
        "$mod Shift, Up, exec,    awt move top"
        "$mod Shift, Down, exec,  awt move bottom"
        "$mod Control_L, Left, exec,  awt expand left"
        "$mod Control_L, Right, exec, awt expand right"
        "$mod Control_L, Up, exec,    awt expand top"
        "$mod Control_L, Down, exec,  awt expand bottom"
        "$mod Shift Control_L, Right, exec, awt expand right"
        "$mod Shift Control_L, Left, exec,  awt expand left"
        "$mod Shift Control_L, Down, exec,  awt expand down"
        "$mod Shift Control_L, Up, exec,    awt expand top"
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

        "$mod, Left, exec, awt splash left"
        "$mod, Right, exec, awt splash right"
        "$mod, Up, exec, awt splash top"
        "$mod, Down, exec, awt splash bottom"
    
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