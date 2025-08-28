{
  lib,
  config,
  pkgs,
  self,
  ...
}:
{
  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  system = {
    primaryUser = "stasta"; # FIXME: define once
    # Set Git commit hash for darwin-version.
    configurationRevision = self.rev or self.dirtyRev or null;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 5;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

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
    zsh

    #: Common, GUI
    kitty
    logseq
    syncthing
    # vscode
    zotero
  ];
}
