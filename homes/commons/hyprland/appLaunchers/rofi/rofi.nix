{ config, pkgs, ... }:
{

  home.packages = with pkgs; [
    rofi
  ];
  programs.rofi = {
    enable = true;
    theme = "Arc-Dark";
  };


  wayland.windowManager.hyprland.settings.windowrulev2 = [
    "float, class:Rofi"
    "pin, class:Rofi"
    "dimaround, class:Rofi"
    "center, class:Rofi"
    "stayfocused, class:Rofi"
  ];

  wayland.windowManager.hyprland.settings = {
    "$menu" = "rofi -show drun";
  };

}