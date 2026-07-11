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
        rev = "20260710";
        hash = "sha256-jxp6OLRqG3NCQmX48UuL/l3XWXvSRnu4hsPbK/QWtGc=";
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
