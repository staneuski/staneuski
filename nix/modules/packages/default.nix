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
        rev = "198dd0e1083f";
        hash = "sha256-7YhqVU7GeTUIkBlrRW26p9p0S/SKFJZhdxhOlY/u4z4=";
      };
      openfoam14 = final.callPackage ../../packages/openfoam/package.nix {
        version = "14";
        rev = "ee3850434819";
        hash = "sha256-1Ox4VsRBfgWNHEpqHkjO1LQEjlqHYdwAKguPCWUCOBc=";
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
