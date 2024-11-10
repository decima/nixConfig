HOST=$1

if [ -z "$1" ]
  then
    echo "No argument supplied"
    exit 1
fi

LINE_FLAKE_NIX=$(cat flake.nix |grep -n "ADD MACHINE CONFIG OVER THIS LINE" | cut -d : -f 1)

# NEW BRANCH
git checkout -b $HOST/initial-config

# New Machine folder
mkdir -p machines/$HOST

# GENERATE Machine specific config
echo "{ config, pkgs, ... }:
{
    imports = [
        ./hardware-configuration.nix
        ../../configuration.nix
    ];
    networking.hostName = \"$HOST\"; # Define your hostname.

    # #configure swapfiles and other machine specific configuration here: 
    # swapDevices = [{
    #     device = \"/swapfile\";
    #     size = 2 * 1024; # 16GB
    # }];
}" >  machines/$HOST/configuration.nix


# GENERATE HARDWARE
nixos-generate-config --dir machines/$HOST


# ADD new hardware to flake.nix config
sed -i "${LINE_FLAKE_NIX}i\ \ \ \ \ \ \ \ \ \ \ \ $HOST = lib.nixosSystem { \n\
                inherit system; \n\
                modules = [./machines/$HOST/configuration.nix]; \n\
            };" flake.nix


# Commit everything
git add machines/$HOST
git add flake.nix
git commit -m "machine($HOST): initial configuration"

