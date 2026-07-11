{
  lib,
  stdenv,
  fetchgit,
  cmake,
  gfortran16,
  python3,

  # REFPROP.tar.xz is NIST's proprietary distribution (REFPROP/FORTRAN/...
  # inside). It can't be fetched automatically or tracked by git, and a
  # flake only sees git-tracked files anyway -- so it must live outside
  # the repo. Defaults to where `recipes.sh` already expects it.
  tarball ? /home/stasta/.local/opt/REFPROP.tar.xz,
}:

let
  # REFPROP-cmake glues NIST's proprietary FORTRAN sources into a CMake
  # build; pinned to a specific commit since upstream has no releases.
  refpropCmakeSrc = fetchgit {
    url = "https://github.com/usnistgov/REFPROP-cmake.git";
    rev = "2be41f6d243c1cc40e13ed8fd6deda707cb8082f";
    fetchSubmodules = true;
    hash = "sha256-Hk9AK92CjvbnZ6RJ9pB2AUGkKWc2EiCha3eNlG2z1w8=";
  };
in
if !builtins.pathExists tarball then
  throw ''
    REFPROP.tar.xz not found at ${toString tarball}.

    REFPROP is proprietary and cannot be fetched automatically. Obtain a
    copy yourself and place it there (or pass `tarball = /path/to/REFPROP.tar.xz;`
    via callPackage) before building.
  ''
else
stdenv.mkDerivation {
  pname = "refprop";
  version = "10.0";

  src = tarball;

  nativeBuildInputs = [ cmake gfortran16 (python3.withPackages (ps: [ ps.numpy ps.six ])) ];

  unpackPhase = ''
    runHook preUnpack

    tar -xJf "$src" REFPROP/FORTRAN
    cp -r --no-preserve=mode,ownership ${refpropCmakeSrc} source
    cp -r REFPROP/FORTRAN source/FORTRAN

    runHook postUnpack
  '';

  sourceRoot = "source";

  cmakeBuildType = "Release";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib" "$out/include" "$out/share/refprop"
    cp -v librefprop.* "$out/lib/"
    cp -v *.h "$out/include/"

    # FORTRAN is only needed to build the library; everything else in the
    # tarball (FLUIDS, MIXTURES, ...) is runtime data REFPROP looks up
    # relative to its own install directory, so ship it alongside the lib.
    tar -xJf "$src" --exclude='REFPROP/FORTRAN' -C "$out/share/refprop" --strip-components=1

    # Some consumers expect the built library and header next to the
    # runtime data instead of in lib/ and include/.
    ln -s "$out/lib"/librefprop.* "$out/share/refprop/"
    ln -s "$out/include"/*.h "$out/share/refprop/"

    runHook postInstall
  '';

  postFixup = ''
    mkdir -p "$out/nix-support"
    cat > "$out/nix-support/setup-hook.sh" <<EOF
    export COOLPROP_REFPROP_ROOT="$out/share/refprop"
    EOF
  '';

  meta = with lib; {
    description = "NIST REFPROP thermophysical property library, built via REFPROP-cmake";
    homepage = "https://github.com/usnistgov/REFPROP-cmake";
    license = licenses.unfree;
    platforms = platforms.unix;
  };
}
