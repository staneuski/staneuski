{
  lib,
  config,
  pkgs,
  self,
  info,
  ...
}:
{
  imports = [
    ../common
  ];

  environment.systemPackages = lib.mkAfter (
    with pkgs;
    [
      #: Common, GUI
      kitty
      (pkgs.callPackage ../../packages/paraview/package.nix { })
      syncthing
      # vscode
      zotero

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
      "logseq"
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

  system = {
    primaryUser = info.userName;

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
          "/Applications/Visual Studio Code.app"
          "/Applications/Logseq.app"
        ];
        persistent-others = [
          "/Users/${info.userName}/Downloads"
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
        HOME = "/Users/${info.userName}";
        STNORESTART = "1";
      };
      KeepAlive = true;
      LowPriorityIO = true;
      ProcessType = "Background";
      StandardOutPath = "/Users/${info.userName}/Library/Logs/Syncthing.log";
      StandardErrorPath = "/Users/${info.userName}/Library/Logs/Syncthing-Errors.log";
    };
  };
}
