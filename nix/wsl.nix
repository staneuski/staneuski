{ config, pkgs, commonPackages, ... }: {
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

  programs.nix-ld.enable = true;

  system.stateVersion = "25.11";

  users.defaultUserShell = pkgs.zsh;

  wsl.defaultUser = "SST055"; # TODO: Same user-name for all configuratuins

  wsl.enable = true;
}

