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

      #: linux, CLI
      bc
      file
      gcc
      gnumake
      pigz
      toybox
      unzip
      vim
      zlib

      #: linux, GUI
      (pkgs.callPackage ../../packages/openfoam/package.nix { })
    ]
  );

  networking.firewall.allowedTCPPorts = [ 8384 ];

  programs.nix-ld.enable = true;

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
  };

  system.stateVersion = "26.05";

  users.defaultUserShell = pkgs.zsh;
}
