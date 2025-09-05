{
  lib,
  stdenv,
  fetchurl,

  pname,
  version,
  meta,

  makeWrapper,
  undmg,
}:
let
  osxVersion = if stdenv.hostPlatform.isArmv7 then "11.0" else "10.15";
  pyVersion = "3.12";
in
stdenv.mkDerivation rec {
  inherit pname version meta;

  src = fetchurl {
    url = "${meta.homepage}/files/v${lib.versions.majorMinor version}/ParaView-${version}-MPI-OSX${osxVersion}-Python${pyVersion}-${stdenv.hostPlatform.darwinArch}.dmg";
    hash = "sha256-YnINeE14k5FMBfut0qA01KFpbnPcidOil/eCBVm1g0o=";
  };
  sourceRoot = ".";

  nativeBuildInputs = [ makeWrapper undmg ];

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications/ParaView.app
    cp -r ParaView-${version}.app/* $out/Applications/ParaView.app/

    makeWrapper $out/Applications/ParaView.app/Contents/MacOS/paraview $out/bin/paraview
    makeWrapper $out/Applications/ParaView.app/Contents/bin/pvbatch $out/bin/pvbatch
    makeWrapper $out/Applications/ParaView.app/Contents/bin/pvdataserver $out/bin/pvdataserver
    makeWrapper $out/Applications/ParaView.app/Contents/bin/pvpython $out/bin/pvpython
    makeWrapper $out/Applications/ParaView.app/Contents/bin/pvrenderserver $out/bin/pvrenderserver
    makeWrapper $out/Applications/ParaView.app/Contents/bin/pvserver $out/bin/pvserver

    runHook postInstall
  '';
}
