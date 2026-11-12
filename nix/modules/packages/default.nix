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
        rev = "3e5731fafd24";
        hash = "sha256-NWPTX7+dOjxDNRTm87BZrSAr3DN2lrGvcE+dqqilLwI=";
      };
      openfoam14 = final.callPackage ../../packages/openfoam/package.nix {
        version = "14";
        rev = "64cfdf5481e1";
        hash = "sha256-Q1xCluGVS/cD1bQmM234bi2N1AD4Gex+e+jaep/uRUI=";
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
