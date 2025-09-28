{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,

  bash, bison, flex, gnumake, m4,
  boost, cgal, fftw, mpi, scotch, trilinos-mpi, zlib,
}:
let
  version = "13";
in
stdenv.mkDerivation {
  pname = "openfoam";
  inherit version;
  meta = with lib; {
    description = "Open source computational fluid dynamics toolkit";
    homepage = "https://openfoam.org";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ staneuski ];
    platforms = with platforms; [ "x86_64-linux" ];
  };

  src = fetchFromGitHub {
    owner = "OpenFOAM";
    repo = "OpenFOAM-${version}";
    rev = "master";
    sha256 = "sha256-3/QsQaMTqCGxA2I8sCEd/q++2QvRtojnFKl5X9LnVXQ=";
  };

  nativeBuildInputs = [ bash bison flex gnumake m4 ];
  buildInputs = [ boost cgal fftw mpi.dev scotch trilinos-mpi zlib ];

  passthru.updateScript = nix-update-script { };
  sourceRoot = ".";

  patchPhase = ''
    runHook prePatch

    export HOME=$PWD/nixbld
    export WM_PROJECT_DIR=$HOME/OpenFOAM/OpenFOAM-${version}
 
    mkdir -p $(dirname $WM_PROJECT_DIR)
    mv source $WM_PROJECT_DIR

    set +e
    for f in $WM_PROJECT_DIR/wmake/{,scripts/}*; do
      [ -f $f ] &&
        substituteInPlace $f --replace-quiet /bin/bash ${bash}/bin/bash
    done
    set -e

    rm $WM_PROJECT_DIR/etc/config.sh/bash_completion
    touch $WM_PROJECT_DIR/etc/config.sh/bash_completion

    echo "set +e" | cat $WM_PROJECT_DIR/etc/bashrc > tmp
    rm $WM_PROJECT_DIR/etc/bashrc
    mv tmp $WM_PROJECT_DIR/etc/bashrc

    echo "set +e" | cat $WM_PROJECT_DIR/Allwmake > tmp
    rm $WM_PROJECT_DIR/Allwmake
    mv tmp $WM_PROJECT_DIR/Allwmake

    alias wmRefresh="placeholder"
    find $WM_PROJECT_DIR -type f -name Allwmake -print -exec chmod +x {} +

    runHook postPatch
  '';
  configurePhase = ''
    runHook preConfigure
    (
      cd $WM_PROJECT_DIR
      ./bin/tools/foamConfigurePaths \
        --dependency PARMETIS=none \
        --dependency ParaView=none \
        --dependency SCOTCH=system \
        --dependency ZOLTAN=none
    )
    runHook postConfigure
  '';
  buildPhase = ''
    runHook preBuild

    source $WM_PROJECT_DIR/./etc/bashrc
    $WM_PROJECT_DIR/./Allwmake -j $NIX_BUILD_CORES -queue

    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/$(basename $WM_PROJECT_DIR)/
    cp -r $WM_PROJECT_DIR/* $out/opt/$(basename $WM_PROJECT_DIR)/

    runHook postInstall
  '';
}
