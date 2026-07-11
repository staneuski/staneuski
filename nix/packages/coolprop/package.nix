{
  lib,
  stdenv,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
}:

let
  version = "8.0.0";
  baseUrl = "https://sourceforge.net/projects/coolprop/files/CoolProp/${version}/shared_library";

  header = fetchurl {
    url = "${baseUrl}/CoolPropLib.h";
    hash = "sha256-PGvW4d9XR6P2Ho00DioABv5wHBmZig5JEXwb+qP8+Y8=";
  };

  libName = "libCoolProp${stdenv.hostPlatform.extensions.sharedLibrary}";

  library =
    if stdenv.hostPlatform.isDarwin then
      fetchurl {
        url = "${baseUrl}/Darwin/64bit/${libName}";
        hash = "sha256-P+Gm6xgKb7hXMrVRJhesQ2Qtvzt19WiDDC0vurzgOm0=";
      }
    else
      fetchurl {
        url = "${baseUrl}/Linux/64bit/${libName}";
        hash = "sha256-+VSKnSxX4B8kWhwvizzSgJ8MFrX2vsPOfjTs37SMHIM=";
      };
in
stdenvNoCC.mkDerivation {
  pname = "coolprop";
  inherit version;

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/include" "$out/lib"
    cp ${header} "$out/include/CoolPropLib.h"

    cp ${library} "$out/lib/${libName}"
    chmod +x "$out/lib/${libName}"
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool -id "$out/lib/${libName}" "$out/lib/${libName}"
  '' + ''

    runHook postInstall
  '';

  meta = with lib; {
    description = "Open-source thermophysical property library (prebuilt shared library, not compiled from source)";
    homepage = "https://coolprop.org";
    license = licenses.mit;
    platforms = platforms.unix;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
