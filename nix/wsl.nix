{
  pkgs,
  config,
  userName,
  commonPackages,
  toPkgs,
  ...
}:
{
  environment.systemPackages =
    commonPackages.cli
    ++ toPkgs pkgs commonPackages.brews
    ++ (with pkgs; [
      bc
      file
      gcc
      gnumake
      pigz
      toybox
      unzip
      vim
      zlib
  ]);

  system.stateVersion = "25.11";

  programs.nix-ld.enable = true;
  users.defaultUserShell = pkgs.zsh;

  wsl.defaultUser = "SST055"; # TODO: user;
  wsl.enable = true;
}
