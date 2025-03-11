{ config, pkgs, ... }:
{

    home.packages = with pkgs; [
        mako
    ];


    wayland.windowManager.hyprland.settings."exec-once" = [
        "mako"
    ];
    
    services.mako = {
        enable = true;
        anchor = "top-left";
        
    };
}