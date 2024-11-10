# nixConfig

My nixOs Configurations


**DISCLAIMER: This readme and this project is still a work in progress, use it at your own risks.**

## Getting started

You have a fresh machine running a fresh NixOS install.
Clone this repo in your home directory, in .dotfiles.
```
nix-shell -p git --command "git clone https://github.com/decima/nixConfig.git .dotfiles"
cd .dotfiles
```

Then add your new machine/reconfigure a machine

## How to add a new machine/reconfigure a machine

You can skip all these steps just by running utils/add_machine.sh

### Create a git branch

```
git checkout -b MY_HOSTNAME/base-config
```


### Skip this step if your machine is already configured.
First, you'll need to create a new folder `MY_HOSTNAME` in machines containing one file : `configuration.nix`.

This file should contains at least :  
```nix
{ config, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ../../configuration.nix
    ];
    networking.hostName = "MY_HOSTNAME"; # Define your hostname.
    # #Add any machine specific configuration here
    # swapDevices = [{
    #     device = "/swapfile";
    #     size = 2 * 1024; # 16GB
    # }];
}
```

Then, add the following config in `flake.nix`, in outputs : 
```
    nixosConfigurations = {
        MY_HOSTNAME = lib.nixosSystem {
            inherit system;
            modules = [./machines/MY_HOSTNAME/configuration.nix];
        };
    };
```

### launch  install configuration

Run the following command: 
```
nix-shell -p gnumake --command "make rebuildHardware host=MY_HOSTNAME"
```

Don't forget to commit with : 
```
git add flake.nix machines/MY_HOSTNAME
git commit -m "config(MY_HOSTNAME): adding configuration"
```

This will add a hardware-configuration.nix to your files.

Finally, run:
```
nix-shell -p gnumake --command "make systemRebuildSpecific host=MY_HOSTNAME"
```
