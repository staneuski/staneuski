{
  description = "OpenFOAM custom build via Nix and fetchFromGitHub";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    packages.${system}.openfoam = pkgs.stdenv.mkDerivation {
      pname = "openfoam";
      version = "13";

      src = pkgs.fetchFromGitHub {
        owner = "OpenFOAM";
        repo = "OpenFOAM-13"; # ${version}";
        rev = "master";
        sha256 = "sha256-bwtrrFkrajp5AYPsw+0X4Ga+zsIq572TxkWsWrfPjqY=";
      };

      nativeBuildInputs = with pkgs; [ bash m4 flex bison ripgrep ];
      buildInputs = with pkgs; [ fftw mpi scotch boost cgal zlib ];

      patches = [ ];

      postPatch = ''
        rg --files-with-matches '#!/bin/bash' |
          while read -r file; do
            substituteInPlace "$file" --replace-quiet '#!/bin/bash' '${pkgs.bash}/bin/bash'
            substituteInPlace "$file" --replace-quiet '#!/bin/sh' '${pkgs.bash}/bin/bash'
          done
      '';

      configurePhase = ''
        export WM_ARCH_OPTION=64
        export WM_PRECISION_OPTION=DP
        export WM_LABEL_SIZE=32
        export WM_COMPILE_OPTION=Opt

        export build=$(pwd)
        export WM_PROJECT=OpenFOAM # $pname}
        export WM_PROJECT_VERSION=13 # $version}
        export WM_PROJECT_DIR=$(pwd)
        export WM_THIRD_PARTY_DIR=$WM_PROJECT_DIR

        case "${pkgs.stdenv.buildPlatform.system}" in
          *linux | aarch64-linux)
            export WM_ARCH="linuxArm$WM_ARCH_OPTION"
            export WM_COMPILER_LIB_ARCH=$WM_ARCH_OPTION
            export WM_CC="gcc"
            export WM_COMPILER="Gcc"
            export WM_CXX="g++"
            export WM_CFLAGS="-fPIC"
            export WM_CXXFLAGS="-fPIC -std=c++17"
            export WM_LDFLAGS=""
            ;&
          x86_64-linux)
            export WM_ARCH=linux$WM_ARCH_OPTION
            export WM_CFLAGS="-m$WM_ARCH_OPTION -fPIC"
            export WM_CXXFLAGS="-m$WM_ARCH_OPTION $WM_CXXFLAGS"
            export WM_LDFLAGS="-m$WM_ARCH_OPTION $WM_LDFLAGS"
            ;;
          *)
            echo "Unsupported build platform: ${pkgs.stdenv.buildPlatform.system}" >&2
            exit 1
            ;;
        esac
        export WM_DIR=$WM_PROJECT_DIR/wmake
        export WM_LINK_LANGUAGE=c++
        export WM_LABEL_OPTION=Int$WM_LABEL_SIZE
        export WM_OPTIONS=$WM_ARCH$WM_COMPILER$WM_PRECISION_OPTION$WM_LABEL_OPTION$WM_COMPILE_OPTION
        export FOAM_APPBIN=$WM_PROJECT_DIR/platforms/$WM_OPTIONS/bin
        export FOAM_LIBBIN=$WM_PROJECT_DIR/platforms/$WM_OPTIONS/lib
        export FOAM_EXT_LIBBIN=$FOAM_LIBBIN

        export MPI_ARCH_PATH=${pkgs.mpi.dev}
        export WM_MPLIB=SYSTEMOPENMPI

        export WM_NCOMPPROCS=$NIX_BUILD_CORES

        bin/tools/foamConfigurePaths \
          --dependency SCOTCH=system \
          --dependency ZOLTAN_TYPE=system
      '';

      buildPhase = ''
        HOME=$TMPDIR \
        PATH="$WM_DIR:$PATH" \
        LD_LIBRARY_PATH="$FOAM_LIBBIN:$FOAM_LIBBIN/openmpi-system:$FOAM_LIBBIN/dummy:$LD_LIBRARY_PATH" \
          ./Allwmake -j$NIX_BUILD_CORES
      '';

      installPhase = ''
        mkdir -p $out
        cp -Ra ./platforms/linux64Gcc/lib $out
        cp -Ra ./platforms/linux64Gcc/lib/dummy/* $out/lib
        cp -Ra ./platforms/linux64Gcc/lib/openmpi-system/* $out/lib
        cp -Ra ./platforms/linux64Gcc/bin $out
        cp -Ra ./etc $out
      '';
    };

    defaultPackage.${system} = self.packages.${system}.openfoam;
  };
}
