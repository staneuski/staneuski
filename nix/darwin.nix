{ pkgs, commonPackages, ... }: {
  environment.systemPackages = commonPackages ++ (with pkgs; [
    # archivebox
    logseq
    kitty
    syncthing
    vscode
    zotero

    eza
    ice-bar
    maccy
    monitorcontrol
  ]);

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  homebrew = {
    enable = true;
    brews = [
      "ffmpeg"
      "gawk"
      "wget"

      "imagemagick"
      "node@24"

      "mas"
    ];
    casks = [
      "vlc"

      "inkscape"
      "meshlab"
      "paraview"
      "zen"

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

  system.defaults = {
    dock = {
      autohide = true;
      autohide-delay = 0.1;
      autohide-time-modifier = 0.4;
      largesize = 128;
      magnification = true;
      persistent-apps = [
        "/System/Applications/Safari.app"
        "/System/Applications/Mail.app"
        "${pkgs.kitty}/Applications/Kitty.app"
        "/Applications/Visual Studio Code.app"
        "/Applications/Logseq.app"
      ];
    };
    loginwindow.GuestEnabled = false;
    NSGlobalDomain = {
      AppleICUForce24HourTime = true;
      KeyRepeat = 2;
    };
  };

  system.activationScripts.syncthing.text = ''
    curl -sLo "/Users/${builtins.getEnv "USER"}/Library/LaunchAgents/syncthing.plist" https://raw.githubusercontent.com/syncthing/syncthing/refs/heads/main/etc/macos-launchd/syncthing.plist &&
    sed -i "" "
      s|/Users/USERNAME/bin/syncthing|${pkgs.syncthing}/bin/syncthing|g;
      s|USERNAME|${builtins.getEnv "USER"}|g
    " "/Users/${builtins.getEnv "USER"}/Library/LaunchAgents/syncthing.plist"
  '';

  users.defaultUserShell = pkgs.zsh;
}
