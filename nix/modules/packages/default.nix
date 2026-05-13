{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        paraview = pkgs.callPackage ../../packages/paraview/package.nix { };
      }
      // pkgs.lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
        openfoam = pkgs.callPackage ../../packages/openfoam/package.nix { };
      };
    };
}
