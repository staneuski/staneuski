{
  self,
  inputs,
  withSystem,
  moduleWithSystem,
  ...
}:
{
  flake = {
    darwinModules.systemPackages = moduleWithSystem (
      perSystem@{ config, ... }:
      { pkgs, ... }:
      {
        environment.systemPackages = [
          #: Common, GUI
          pkgs.kitty
          perSystem.config.packages.paraview
          pkgs.syncthing
          pkgs.vscode
          pkgs.zotero

          #: Darwin, CLI
          pkgs.eza

          #: Darwin, GUI
          pkgs.ice-bar
          pkgs.maccy
          pkgs.monitorcontrol
        ];

        homebrew = {
          enable = true;
          brews = [
            "imagemagick"
            "ffmpeg"
            "gawk"
            "wget"

            "mas"
          ];
          casks = [
            "inkscape"
            "meshlab"
            "ungoogled-chromium"
            "vlc"

            "amethyst"
            "anydesk"
            "coconutbattery"
            "hammerspoon"
            "logi-options+"
            "xquartz"
          ];
          masApps = {
            "Hush" = 1544743900;
            "Strongbox" = 897283731;
          };
          onActivation = {
            autoUpdate = true;
            cleanup = "zap";
            upgrade = true;
          };
        };
      }
    );

    darwinModules.system =
      {
        pkgs,
        userName,
        ...
      }:
      {
        system = {
          primaryUser = userName;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          stateVersion = 5;

          # https://mynixos.com/nix-darwin/options/system
          defaults = {
            NSGlobalDomain = {
              AppleICUForce24HourTime = true;
              KeyRepeat = 2;
            };

            dock = {
              autohide = true;
              autohide-delay = 0.1;
              autohide-time-modifier = 0.4;
              largesize = 128;
              magnification = true;
              persistent-apps = [
                "/System/Cryptexes/App/System/Applications/Safari.app"
                "/System/Applications/Mail.app"
                "${pkgs.kitty}/Applications/Kitty.app"
                "${pkgs.vscode}/Applications/Visual Studio Code.app"
                "/Applications/Chromium.app"
              ];
              persistent-others = [
                "/Users/${userName}/Downloads"
              ];
            };
            finder = {
              # FXPreferredViewStyle = "clmv";
              ShowPathbar = true;
            };
            loginwindow.GuestEnabled = false;
          };
        };

        # Reproduce https://github.com/syncthing/syncthing/blob/main/etc/macos-launchd/syncthing.plist
        launchd.user.agents.syncthing = {
          command = "${pkgs.syncthing}/bin/syncthing";
          serviceConfig = {
            EnvironmentVariables = {
              HOME = "/Users/${userName}";
              STNORESTART = "1";
            };
            KeepAlive = true;
            LowPriorityIO = true;
            ProcessType = "Background";
            StandardOutPath = "/Users/${userName}/Library/Logs/Syncthing.log";
            StandardErrorPath = "/Users/${userName}/Library/Logs/Syncthing-Errors.log";
          };
        };
      };

    darwinConfigurations.duke = withSystem "x86_64-darwin" (
      { pkgs, ... }:
      inputs.nix-darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = [
          { nixpkgs.pkgs = pkgs; }
          self.nixosModules.default
          self.darwinModules.systemPackages
          self.darwinModules.system
          inputs.nix-homebrew.darwinModules.nix-homebrew
          (
            { userName, ... }:
            {
              nix-homebrew = {
                autoMigrate = true;
                enable = true;
                enableRosetta = false;
                user = userName;
              };
            }
          )
        ];
      }
    );
  };
}
