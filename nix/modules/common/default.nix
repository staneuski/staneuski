{
  lib,
  config,
  pkgs,
  self,
  info,
  ...
}:
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    #: Common, CLI
    btop
    git
    git-lfs
    gnupg
    nixfmt-tree
    python314
    uutils-coreutils-noprefix
    uutils-diffutils
    uutils-findutils
    uutils-sed
    uv
    zsh

    #: Common, GUI
    syncthing
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = info.system;
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # darwin?

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;
}
