{ config, pkgs, ... }:
{
    home.file = {
      ".config/waybar/config.jsonc".source = ./waybar/waybar.jsonc;
      ".config/waybar/style.css".source = ./waybar/waybar.css;
      ".config/waybar/spotify_art.sh".source = ./scripts/spotify_art.sh;
    };
}