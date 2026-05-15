{
  flake.overlays.default =
    final: prev:
    {
      paraview = final.callPackage ../../packages/paraview/package.nix { };
    }
    // prev.lib.optionalAttrs prev.stdenv.hostPlatform.isLinux {
      openfoam = final.callPackage ../../packages/openfoam/package.nix {
        rev = "5884ffc80";
        hash = "sha256-7ajjNpxCsj9rORLa25m4ip4G0KTjtIjA21QTyVX1p3M=";
      };
    };

  perSystem =
    { pkgs, ... }:
    {
      packages = {
        inherit (pkgs) paraview;
      }
      // pkgs.lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
        inherit (pkgs) openfoam;
      };
    };
}
