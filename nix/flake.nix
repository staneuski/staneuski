{
  description = "Nix flake for macOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable"; # NixOS/nixpkgs/nixos-24.11";
    nix-darwin = {
      url = "github:LnL7/nix-darwin"; # LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, mac-app-util }:
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
        python313
        python313Packages.numpy
        python313Packages.virtualenv
        rclone
        zsh

        firefox
        logseq
        syncthing
        vscode
        zotero

        eza
        ice-bar
        maccy
        mkalias
        monitorcontrol
      ];

      homebrew = {
        enable = true;
        brews = [
          "gawk"
          "ffmpeg"
          "imagemagick"
          "node@22"
          "wget"

          "mas"
        ];
        casks = [
          "inkscape"
          "paraview"
          "vlc"

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

      fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
      ];

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
          "${pkgs.firefox}/Applications/Firefox.app"
          "/System/Applications/Mail.app"
          "${pkgs.kitty}/Applications/Kitty.app"
          "${pkgs.vscode}/Applications/Visual Studio Code.app"
          "${pkgs.logseq}/Applications/Logseq.app"
        ];
        # finder.FXPreferredViewStyle = "clmv";
        loginwindow.GuestEnabled = false;
        NSGlobalDomain.AppleICUForce24HourTime = true;
        NSGlobalDomain.KeyRepeat = 2;
      };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs = {
        zsh.enable = true;
        # fish.enable = true;
      };

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
        mac-app-util.darwinModules.default
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."duke".pkgs;
  };
}
