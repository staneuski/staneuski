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
    user = "stasta";
    configuration = { pkgs, config, ... }: {

      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs; [
        htop
        zsh

        git
        git-lfs
        helix
        mc
        python313
        python313Packages.ipykernel
        python313Packages.pip
        python313Packages.virtualenv
        rclone

        vscode

        kitty
        syncthing
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
          "wget"

          "ffmpeg"
          "imagemagick"
          "node@22"

          "mas"
        ];
        casks = [
          "vlc"

          "inkscape"
          "logseq"
          "meshlab"
          "paraview"

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

      # https://mynixos.com/nix-darwin/options/system 
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
          "${pkgs.vscode}/Applications/Visual Studio Code.app"
          "/Applications/Logseq.app"
        ];
        dock.persistent-others = [
          "${config.system.build.applications}/Applications"
          "/Users/${user}/Downloads"
        ];
        # finder.FXPreferredViewStyle = "clmv";
        finder.ShowPathbar = true;
        loginwindow.GuestEnabled = false;
        NSGlobalDomain.AppleICUForce24HourTime = true;
        NSGlobalDomain.KeyRepeat = 2;
      };
      system.activationScripts.script.text = pkgs.lib.mkForce ''
        #!/usr/bin/env sh
        curl -sLo "/Users/${user}/Library/LaunchAgents/syncthing.plist" \
          https://raw.githubusercontent.com/syncthing/syncthing/refs/heads/main/etc/macos-launchd/syncthing.plist &&
        sed -i "" "
          s|/Users/USERNAME/bin/syncthing|${pkgs.syncthing}/bin/syncthing|g;
          s|USERNAME|${user}|g
        " "/Users/${user}/Library/LaunchAgents/syncthing.plist" 
      '';

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
    # $ darwin-rebuild build --flake .#amd64
    darwinConfigurations."amd64" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            user = user;
            autoMigrate = true;
          };
        }
        mac-app-util.darwinModules.default
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."amd64".pkgs;
  };
}
