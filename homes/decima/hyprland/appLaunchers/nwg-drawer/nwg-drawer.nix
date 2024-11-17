{ config, pkgs, ... }:
{

  home.packages = with pkgs; [
    nwg-drawer
  ];



  wayland.windowManager.hyprland.settings.windowrulev2 = [
    "float, class:nwg-drawer"
    "pin, class:nwg-drawer"
    "dimaround, class:nwg-drawer"
    "center, class:nwg-drawer"
    "stayfocused, class:nwg-drawer"
  ];

  wayland.windowManager.hyprland.settings = {
    "$menu" = "nwg-drawer";
  };

}