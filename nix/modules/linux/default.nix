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
      zlib
    ]
  );

  programs.nix-ld.enable = true;

  users.defaultUserShell = pkgs.zsh;

  wsl.defaultUser = "SST055"; # FIXME: info.userName;
  wsl.enable = true;
}
