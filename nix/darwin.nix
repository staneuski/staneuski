{
  pkgs,
  config,
  userName,
  commonPackages,
  ...
}:
{
  environment.systemPackages =
    commonPackages.cli
    ++ commonPackages.gui
    ++ (with pkgs; [
      eza
      ice-bar
      maccy
      monitorcontrol
    ]);
  fonts.packages = commonPackages.fonts;

  homebrew = {
    enable = true;
    brews = commonPackages.brews ++ [
      # archivebox
      "node@24"

      "mas"
    ];
    casks = commonPackages.casks ++ [
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

  # system.activationScripts.syncthing.text = '' <- does not work
  system.activationScripts.script.text = pkgs.lib.mkForce ''
    #!/usr/bin/env sh
    curl -sLo "/Users/${userName}/Library/LaunchAgents/syncthing.plist" \
      https://raw.githubusercontent.com/syncthing/syncthing/refs/heads/main/etc/macos-launchd/syncthing.plist &&
    sed -i "" "
      s|/Users/USERNAME/bin/syncthing|${pkgs.syncthing}/bin/syncthing|g;
      s|USERNAME|${userName}|g
    " "/Users/${userName}/Library/LaunchAgents/syncthing.plist" 
  '';

  system.primaryUser = userName;
  system.stateVersion = 6;
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
      "${pkgs.logseq}/Logseq.app"
    ];
    dock.persistent-others = [
      # "${config.system.build.applications}/Applications"
      "/Users/${userName}/Downloads"
    ];
    finder.FXPreferredViewStyle = "clmv";
    finder.ShowPathbar = true;
    loginwindow.GuestEnabled = false;
    NSGlobalDomain.AppleICUForce24HourTime = true;
    NSGlobalDomain.KeyRepeat = 2;
  };
}
