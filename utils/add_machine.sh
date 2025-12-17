#!/usr/bin/env bash

set -e

HOST=$1

if [ -z "$1" ]; then
  echo "No argument supplied"
  exit 1
fi

if [ -d "machines/$HOST" ]; then
  echo "Machine '$HOST' already exists."
  exit 1
fi

echo "Creating initial configuration for machine '$HOST'..."

git checkout -b "$HOST/initial-config"

mkdir -p "machines/$HOST"

# GENERATE Machine specific config
cat > "machines/$HOST/configuration.nix" <<EOF
{ config, pkgs, ... }:
{
    imports = [
        ./hardware-configuration.nix
        ../../configuration.nix
    ];
    networking.hostName = "$HOST"; # Define your hostname.
    # #configure swapfiles and other machine specific configuration here:
    # swapDevices = [{
    #     device = "/swapfile";
    #     size = 2 * 1024; # 16GB
    # }];
}
EOF

echo "Generating hardware configuration..."
nixos-generate-config --dir "machines/$HOST"

echo "Adding new machine to flake.nix..."

sed -i "/### DO NOT REMOVE OR MOVE THIS LINE : ADD MACHINE CONFIG OVER THIS LINE/i \
        $HOST = lib.nixosSystem { \
          inherit system; \
          modules = [./machines/$HOST/configuration.nix]; \
        };" flake.nix

echo "Committing changes..."
git add "machines/$HOST" flake.nix
git commit -m "machine($HOST): initial configuration"

echo "Done."
echo "You can now run 'make rebuild' to build the new system."