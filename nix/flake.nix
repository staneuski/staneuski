{
  description = "Duke Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, config, ... }: {

      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs; [
        git
        git-lfs
        helix
        htop
        kitty
        mc
        neovim
        python3
        rclone
        syncthing
        virtualenv

        eza
        ice-bar
        maccy
        mkalias
        monitorcontrol
      ];

      homebrew = {
        enable = true;
        brews = [
          "ffmpeg"
          "imagemagick"
          "node@22"

          "mas"
        ];
        casks = [
          "firefox"
          "inkscape"
          "logseq"
          "paraview"
          "visual-studio-code"
          "vlc"
          "zotero"

          "amethyst"
          "coconutbattery"
          "hammerspoon"
          "logi-options+"
          "xquartz"
        ];
        masApps = {
          "Hush" = 1544743900;
          "Strongbox" = 897283731;
        };
        onActivation.autoUpdate = true;
        onActivation.cleanup = "zap";
        onActivation.upgrade = true;
      };

      fonts.packages = [
        pkgs.nerd-fonts.jetbrains-mono
      ];

      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        };
      in
        pkgs.lib.mkForce ''
        echo "setting up /Applications..." >&2
        rm -rf /Applications/Nix\ Apps
        mkdir -p /Applications/Nix\ Apps
        find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read -r src; do
          app_name=$(basename "$src")
          echo "copying $src" >&2
          ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
        done
      '';

      system.activationScripts.script.text = pkgs.lib.mkForce ''
        #!/usr/bin/env sh
        curl -sLo "/Users/stasta/Library/LaunchAgents/syncthing.plist" https://raw.githubusercontent.com/syncthing/syncthing/refs/heads/main/etc/macos-launchd/syncthing.plist &&
        sed -i "" "
          s|/Users/USERNAME/bin/syncthing|${pkgs.syncthing}/bin/syncthing|g;
          s|USERNAME|stasta|g
        " "/Users/stasta/Library/LaunchAgents/syncthing.plist" 
      '';

      system.defaults = {
        dock.autohide = true;
        dock.autohide-delay = 0.1;
        dock.autohide-time-modifier = 0.4;
        dock.largesize = 128;
        dock.magnification = true;
        dock.persistent-apps = [
          "/System/Cryptexes/App/System/Applications/Safari.app"
          "/System/Applications/Mail.app"
          "${pkgs.kitty}/Applications/Kitty.app"
          "/Applications/Visual Studio Code.app"
          "/Applications/Logseq.app"
        ];
        # finder.FXPreferredViewStyle = "clmv";
        loginwindow.GuestEnabled = false;
        NSGlobalDomain.AppleICUForce24HourTime = true;
        NSGlobalDomain.KeyRepeat = 2;
      };

      # Auto upgrade nix package and the daemon service.
      # services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "x86_64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#duke
    darwinConfigurations."duke" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            user = "stasta";
            autoMigrate = true;
          };
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."duke".pkgs;
  };
}
