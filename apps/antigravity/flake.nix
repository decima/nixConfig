{
  description = "Google Antigravity - Agentic IDE Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      packages.${system}.default = pkgs.stdenv.mkDerivation rec {
        pname = "antigravity";
        version = "1.11.3";

        src = pkgs.fetchurl {
          url = "https://edgedl.me.gvt1.com/edgedl/release2/j0qc3/antigravity/stable/1.11.3-6583016683339776/linux-x64/Antigravity.tar.gz";
          # LANCE: nix-prefetch-url <URL> pour avoir le bon hash
          sha256 = "0nv1ln2cndd2kn7kgs7jmk0q44r0104vqxfcw9a736krz49aap82"; 
        };

        nativeBuildInputs = with pkgs; [
          autoPatchelfHook
          makeWrapper
          copyDesktopItems
        ];

        buildInputs = with pkgs; [
          alsa-lib
          at-spi2-atk
          at-spi2-core
          cairo
          cups
          dbus
          expat
          gdk-pixbuf
          glib
          gtk3
          libdrm
          libxkbcommon
          mesa
          nspr
          nss
          pango
          systemd
          libsecret
          libappindicator-gtk3
          libkrb5 # Ajout préventif pour les modules node
          xorg.libX11
          xorg.libXcomposite
          xorg.libXdamage
          xorg.libXext
          xorg.libXfixes
          xorg.libXrandr
          xorg.libxcb
          xorg.libxshmfence
          xorg.libxkbfile # <--- LA CORRECTION EST ICI
        ];

        desktopItems = [
          (pkgs.makeDesktopItem {
            name = "antigravity";
            desktopName = "Google Antigravity";
            exec = "antigravity %U";
            icon = "antigravity";
            comment = "Agentic IDE by Google";
            categories = [ "Development" "IDE" ];
          })
        ];

        installPhase = ''
          runHook preInstall

          mkdir -p $out/share/antigravity
          mkdir -p $out/bin

          cp -r * $out/share/antigravity/

          if [ -f $out/share/antigravity/Antigravity ]; then
            ln -s $out/share/antigravity/Antigravity $out/bin/antigravity
          elif [ -f $out/share/antigravity/antigravity ]; then
            ln -s $out/share/antigravity/antigravity $out/bin/antigravity
          else
            echo "ERREUR: Binaire Antigravity introuvable."
            exit 1
          fi

          if [ -d "$out/share/antigravity/resources" ]; then
            ICON_PATH=$(find $out/share/antigravity/resources -name "icon.png" -o -name "app.png" | head -n 1)
            if [ -n "$ICON_PATH" ]; then
              mkdir -p $out/share/icons/hicolor/512x512/apps
              cp "$ICON_PATH" $out/share/icons/hicolor/512x512/apps/antigravity.png
            fi
          fi

          runHook postInstall
        '';

        postFixup = ''
          wrapProgram $out/bin/antigravity \
            --prefix LD_LIBRARY_PATH : ${pkgs.lib.makeLibraryPath [ pkgs.systemd pkgs.libglvnd pkgs.libsecret pkgs.xorg.libxkbfile ]} \
            --add-flags "--disable-gpu-sandbox"
        '';

        meta = with pkgs.lib; {
          description = "Google Antigravity IDE";
          homepage = "https://deepmind.google/technologies/antigravity/";
          license = licenses.unfree;
          platforms = [ "x86_64-linux" ];
        };
      };
    };
}