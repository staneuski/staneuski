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
        rev = "737ba0998f73";
        hash = "sha256-JRruI3SBLWiByohqP+n57SUaMN6DcYCx18VE9WXCKgE=";
      };
    };

  perSystem =
    { pkgs, ... }:
    {
      packages = {
        inherit (pkgs) paraview coolprop refprop;
      }
      // pkgs.lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
        inherit (pkgs) openfoam;
      };
    };
}
