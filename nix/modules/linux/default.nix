{
  self,
  inputs,
  ...
}:
let
  userName = "stasta";
in
{
  flake = {
    nixosModules.systemPackages =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
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

          #TODO:devShell.openfoam
          # (pkgs.callPackage ../../packages/openfoam/package.nix { })
        ];
      };

    nixosModules.system =
      { pkgs, ... }:
      {
        programs.nix-ld.enable = true;
      };

    nixosConfigurations.wsl = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        self.nixosModules.default
        self.nixosModules.systemPackages
        self.nixosModules.system
        inputs.nixos-wsl.nixosModules.default
        (
          { pkgs, ... }:
          {
            system.stateVersion = "26.05";
            wsl.defaultUser = userName;
            wsl.enable = true;
          }
        )
      ];
    };
  };
}
