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

    (pkgs.wrapOBS {
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi #optional AMD hardware acceleration
      obs-gstreamer
      obs-vkcapture
    ];
  })
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
