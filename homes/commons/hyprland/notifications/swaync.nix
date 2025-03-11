{ config, pkgs, ... }:
{

    home.packages = with pkgs; [
        swaynotificationcenter
    ];
    wayland.windowManager.hyprland.settings."exec-once" = [
        "swaync"
    ];


    services.swaync.enable = true;
    
    services.swaync.style = ''
        .notification-row {
            outline: none;
        }
        
        .notification-row:focus,
        .notification-row:hover {
            background: #3399ff;
        }
        
        .notification {
            border-radius: 0px;
            margin: 6px 12px;
            padding: 0;
        }
    '';

    services.swaync.settings = {
        positionX = "right";
        positionY = "top";
        layer = "overlay";
        control-center-layer = "top";
        layer-shell = true;
        cssPriority = "application";
        control-center-margin-top = 60;
        control-center-margin-bottom = 30;
        control-center-margin-left = 0;
        control-center-margin-right = 10;
        notification-2fa-action = true;
        notification-inline-replies = false;
        notification-icon-size = 64;
        notification-body-image-height = 100;
        notification-body-image-width = 200;
    };
    


}