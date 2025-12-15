{ config, pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    #    spotify
    pulseaudioFull
    pavucontrol
    sway-contrib.grimshot # screenshots
    playerctl
    alsa-utils
    v4l-utils
  ];


  security.rtkit.enable = true;    # Recommended for real-time scheduling

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want jack support:
    # jack.enable = true;
  };



}
