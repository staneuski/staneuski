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
    git
    git-lfs
    htop
    nixfmt-tree
    python313
    python313Packages.ipykernel
    python313Packages.pip
    python313Packages.virtualenv
    vim
    zsh
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
