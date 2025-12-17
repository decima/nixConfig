#!/usr/bin/env bash

set -e

USER=$1
HOST=$2

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 <user> <host>"
  exit 1
fi

if [ -d "homes/${USER}_${HOST}" ]; then
  echo "Home configuration for '$USER@$HOST' already exists."
  exit 1
fi

echo "Creating initial home configuration for '$USER@$HOST' நான்காவது...

git checkout -b "$USER@$HOST/initial-home-config"

mkdir -p "homes/${USER}_${HOST}"

# GENERATE Machine specific config
cat > "homes/${USER}_${HOST}/home.nix" <<EOF
{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "$USER";
  home.homeDirectory = "/home/$USER";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
EOF

echo "Adding new home configuration to flake.nix..."

sed -i "/# homes configurations/a \\
        \"$USER@$HOST\" = home-manager.lib.homeManagerConfiguration { \\
          inherit pkgs; \\
          modules = [ ./homes/${USER}_${HOST}/home.nix ]; \\
        };" flake.nix

echo "Committing changes..."
git add "homes/${USER}_${HOST}" flake.nix
git commit -m "home($USER@$HOST): initial configuration"

echo "Done."
echo "You can now run 'make homeRebuild' to build the new home configuration."
