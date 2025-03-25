{ config, pkgs, ... }:
{
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="100", TAG+="uaccess", TAG+="udev-acl"
  '';

}
