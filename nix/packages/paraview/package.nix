{
  lib,
  stdenv,
  fetchurl,
  callPackage,
}:

let
  pname = "paraview";
  version = "5.13.3";
  meta = {
    homepage = "https://www.paraview.org";
    description = "3D Data analysis and visualization application";
    mainProgram = "paraview";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      guibert
      qbisi
    ];
  };
in
if stdenv.hostPlatform.isDarwin then
  callPackage ./darwin.nix { inherit pname version meta; }
else
  callPackage ./linux.nix { inherit pname version meta; }
