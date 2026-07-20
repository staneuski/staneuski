{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,

  bash, bison, flex, gnumake, m4,
  boost, cgal, fftw, mpi, scotch, metis, parmetis, trilinos-mpi, zlib,

  version ? "14",
  rev ? "e6a60ffdbde578fc62e62449e04659b7612dca26",
  hash ? "sha256-gfAK9adIMD9YHdp1VVDh3FuAgIP9dkqUxSEn7tF6nC4=",
}:
let
  ptscotch = scotch.override { withPtScotch = true; };
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
    inherit rev hash;
  };

  nativeBuildInputs = [ bash bison flex gnumake m4 ];
  buildInputs = [ boost cgal fftw ptscotch metis parmetis trilinos-mpi zlib ];
  propagatedBuildInputs = [ mpi mpi.dev ];
  propagatedUserEnvPkgs = [ mpi mpi.dev ];

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
        --dependency METIS=system \
        --dependency PARMETIS=system \
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

    mkdir -p $out
    cp -r $WM_PROJECT_DIR/* $out/

    substituteInPlace $out/bin/foamEtcFile \
      --replace-fail \
        'OpenFOAM-*)' '*-openfoam-*)' \
      --replace-fail \
        '##OpenFOAM-}' '##*-openfoam-}'
    substituteInPlace $out/etc/bashrc \
      --replace-fail \
        'export WM_PROJECT_DIR=$WM_PROJECT_INST_DIR/$WM_PROJECT-$WM_PROJECT_VERSION' \
        "export WM_PROJECT_DIR=$out" \
      --replace-fail \
        'export WM_THIRD_PARTY_DIR=$WM_PROJECT_INST_DIR/$WM_THIRD_PARTY-$WM_PROJECT_VERSION' \
        'export WM_THIRD_PARTY_DIR=$HOME/.local/share/OpenFOAM/ThirdParty'
    substituteInPlace $out/wmake/wmake --replace-fail \
      'export WM_COLLECT_DIR=$WM_PROJECT_DIR/platforms/''${WM_OPTIONS}/''${PWD////_}' \
      'export WM_COLLECT_DIR=''${TMPDIR:-/tmp}/wmakeCollect/''${WM_OPTIONS}/''${PWD////_}'

    mkdir -p $out/etc/profile.d
    cat > $out/etc/profile.d/foam${version}.sh <<EOF
    foam${version}() {
      if [ -n "\$ZSH_VERSION" ]; then
        setopt local_options no_nomatch
      fi
      export PATH="${mpi}/bin:\$PATH"
      source "$out/etc/bashrc"
    }
    EOF

    runHook postInstall
  '';
}
