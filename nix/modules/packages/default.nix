{
  flake.overlays.default =
    final: prev:
    {
      paraview = final.callPackage ../../packages/paraview/package.nix { };
    }
    // prev.lib.optionalAttrs prev.stdenv.hostPlatform.isLinux {
      openfoam = final.callPackage ../../packages/openfoam/package.nix {
        rev = "6c08ce895";
        hash = "sha256-W6pnW0to8G94zEZLgZJlScyaQ8+a8xDOeG2GcbhHlc8=";
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
