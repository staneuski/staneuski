{ config, pkgs, commonPackages, user, ... }: {
  environment.systemPackages = commonPackages ++ (with pkgs; [
    bc
    file
    gcc
    gnumake
    pigz
    toybox
    unzip
    vim
    zlib

    ffmpeg
    gawk
    wget
  ]);

  system.stateVersion = "25.11";

  programs.nix-ld.enable = true;
  users.defaultUserShell = pkgs.zsh;

  wsl.defaultUser = "SST055"; # TODO: user;
  wsl.enable = true;
}

