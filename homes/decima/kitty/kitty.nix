{ config, pkgs, ... }:
let 
    theme = ./themes/peachBubblegum.conf;
in
{

    
    programs.kitty = {
        enable = true;
        extraConfig = (builtins.readFile theme);
    };
}