host ?= $(shell bash -c 'read -p "Host: " host; echo $$host')
user ?= $(shell bash -c 'read -p "User: " user; echo $$user')

homeRebuild:
	home-manager switch --flake .

homeRebuildSpecific:
	home-manager switch --flake .#$(user)@$(host)

systemRebuild:
	sudo nixos-rebuild switch --flake .

systemRebuildSpecific:
	sudo nixos-rebuild switch --flake .#$(host)

updateSystem: 
	nix flake update

rebuild: systemRebuild homeRebuild

homeGenerations:
	home-manager generations

clearHistory:
	@echo -n "Are you sure? [y/N] " && read ans && if [ $${ans:-'N'} = 'y' ]; then 	nix-collect-garbage --delete-old; fi

rebuildHardware:
	nixos-generate-config --dir machines/$(host)

