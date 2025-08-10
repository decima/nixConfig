{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../commons/multimedia.nix
    ../../commons/gaming.nix
    ../../commons/development.nix
    ../../commons/keyboard.nix
    ../../configuration.nix
    ./graphics.nix
  ];

  networking.hostName = "zeus"; # Define your hostname.

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.systemPackages = with pkgs; [
    libnotify
    # waybar
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    transmission_4-qt
    nerd-fonts.ubuntu
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.space-mono
  ];

  programs.light.enable = true;

  programs.hyprland.enable = false;
  programs.hyprlock.enable = false;

  # #configure swapfiles and other machine specific configuration here:
  # swapDevices = [{
  #     device = "/swapfile";
  #     size = 2 * 1024; # 16GB
  # }];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
