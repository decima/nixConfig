{ config, pkgs, ... }:
{
    home.file = {
      #".config/eww/eww.yuck".source = ./eww.yuck;
      #".config/eww/eww.scss".source = ./eww.scss;
      #".config/eww/getvol.sh".source = ./getvol.sh;
      #".config/eww/getWindowTitle.sh".source = ./getWindowTitle.sh;
    };

    home.packages = with pkgs; [
        eww
        
    ];

        wayland.windowManager.hyprland.settings."exec-once" = [
        "eww daemon"
        "eww open clock"
        "eww open music"
    ];
}