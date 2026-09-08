{
  flake.overlays.default =
    final: prev:
    {
      paraview = final.callPackage ../../packages/paraview/package.nix { };
      coolprop = final.callPackage ../../packages/coolprop/package.nix { };
      refprop = final.callPackage ../../packages/refprop/package.nix { };
    }
    // prev.lib.optionalAttrs prev.stdenv.hostPlatform.isLinux {
      openfoam = final.callPackage ../../packages/openfoam/package.nix {
        version = "dev";
        rev = "20260907";
        hash = "sha256-5iCJNZShUNUDUWWAF+MQ2nWypsaDw0qzNe78VFe0DWU=";
      };
      openfoam14 = final.callPackage ../../packages/openfoam/package.nix {
        version = "14";
        rev = "29ee7bdbeca9";
        hash = "sha256-ZXdxY9AgqjhQl3JUm/kcsyLvovUqNshbUjogX2wAIG0=";
      };
    };

  perSystem =
    { pkgs, ... }:
    {
      packages = {
        inherit (pkgs) paraview coolprop refprop;
      }
      // pkgs.lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
        inherit (pkgs) openfoam openfoam14;
      };
    };
}
