{ config, pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    spotify
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

  xdg.portal = {
    enable = true;
    # Specify the GNOME backend
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    # Optional: If you use GTK apps outside GNOME, or other environments
    # you might need xdg-desktop-portal-gtk as well, but for GNOME
    # -gnome should be sufficient.
};

}
