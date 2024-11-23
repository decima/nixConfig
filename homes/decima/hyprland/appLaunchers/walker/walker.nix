{ config, pkgs, ... }:
{

  home.packages = with pkgs; [
    walker
  ];



  wayland.windowManager.hyprland.settings.windowrulev2 = [
    "float, class:Walker"
    "pin, class:Walker"
    "dimaround, class:Walker"
    "center, class:Walker"
    "stayfocused, class:Walker"
  ];

  wayland.windowManager.hyprland.settings = {
    "$menu" = "walker";
  };

}