{ config, pkgs, ... }:
{
    home.file = {
      ".config/eww/eww.yuck".source = ./eww.yuck;
      ".config/eww/eww.scss".source = ./eww.scss;
      ".config/eww/getvol.sh".source = ./getvol.sh;
      ".config/eww/getWindowTitle.sh".source = ./getWindowTitle.sh;
    };
}