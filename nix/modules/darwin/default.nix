{
  lib,
  config,
  pkgs,
  self,
  ...
}:
let
  userName = "stasta"; # FIXME: define once
in
{
  imports = [
    ../common
  ];

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "x86_64-darwin";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = lib.mkAfter (
    with pkgs;
    [
      #: Darwin, CLI
      eza

      #: Darwin, GUI
      ice-bar
      maccy
      monitorcontrol
    ]
  );

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
      "visual-studio-code"
      "vlc"

      "amethyst"
      "anydesk"
      "coconutbattery"
      "hammerspoon"
      "logi-options+"
      "xquartz"
      "zen"

      # "/Users/${userConfig.name}/.config/homebrew/Casks/paraview@5.13.rb"
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

  # https://mynixos.com/nix-darwin/options/system
  system.defaults = {
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
        "/Applications/Visual Studio Code.app"
        "${pkgs.logseq}/Applications/Logseq.app"
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

  launchd = {
    user = {
      agents = {
        # Reproduce https://github.com/syncthing/syncthing/blob/main/etc/macos-launchd/syncthing.plist
        syncthing = {
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
    };
  };
}
