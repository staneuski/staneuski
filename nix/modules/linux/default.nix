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
      #: formulae, CLI
      imagemagick
      ffmpeg
      gawk
      wget

      #: Linux, CLI
      bc
      file
      gcc
      gnumake
      pigz
      toybox
      unzip
      vim
      zlib
    ]
  );

  programs.nix-ld.enable = true;

  system.stateVersion = "25.11";

  users.defaultUserShell = pkgs.zsh;
}
