#!/usr/bin/env bash

export PREFIX=${PREFIX:-$HOME/.local}
export TMPDIR=${TMPDIR:-/tmp}

export STOW_PKGS=${STOW_PKGS:-$PREFIX/stow}
export SPACK_ROOT=${SPACK_ROOT:-$PREFIX/opt/spack}

export BASH_COMPLETION_USER_DIR=${BASH_COMPLETION_USER_DIR:-$PREFIX/share/bash-completion/completions}

mkdir -p "${PREFIX}/"{bin,include,lib{,64},opt,share/{applications,doc,icons,fonts,man/man{1,2,3,4,5,6,7,8,9}},state} \
  "${BASH_COMPLETION_USER_DIR}" "${STOW_PKGS}"

#: stow
(
  set -euo pipefail
  PKG=stow
  SRC="${TMPDIR}/${USER}/${PKG}"

  # cpan Test::Output
  mkdir -p "${SRC}"
  curl -sL 'http://ftp.gnu.org/gnu/stow/stow-latest.tar.gz' |
    tar -C "${SRC}/" --strip-components=1 -xvz

  cd "${SRC}"
  "${SRC}/configure" --prefix="${STOW_PKGS}/${PKG}"
  make install

  ./bin/stow --dir="${STOW_PKGS}" --target="${PREFIX}" --restow "${PKG}"
  rm -rf "${SRC}"
)

#: CoolProp
(
  set -euo pipefail
  VER=8.0.0
  PKG=CoolProp
  DST="${STOW_PKGS}/${PKG}"

  SRC="https://sourceforge.net/projects/coolprop/files/CoolProp/${VER}/shared_library"

  curl -LO "${SRC}/CoolPropLib.h" --output-dir "${DST}/include" --create-dirs
  curl -LO "${SRC}/$(uname)/64bit/libCoolProp.so" --output-dir "${DST}/lib" --create-dirs

  chmod +x "${DST}/lib/libCoolProp.so"
  ln -sf libCoolProp.so "${DST}/lib/libCoolProp.so.${VER}"
  ln -sf libCoolProp.so "${DST}/lib/libCoolProp.so.${VER%%.*}"

  stow --dir=$(dirname "${DST}") --target="${PREFIX}" --restow "${PKG}"
  # https://coolprop.org/coolprop/wrappers/SharedLibrary/index.html#linux
  # g++ -std=c++23 -Wall -O0 -o main -DCOOLPROP_LIB -I"${PREFIX}/include" main.cpp "${PREFIX}/lib/libCoolProp.so" -ldl
)

#: doublecmd
(
  set -euo pipefail
  VER=1.1.32
  DST="${PREFIX}/opt/doublecmd"
  ARCH=$(uname -m)

  mkdir -p "${DST}"
  curl -sL "https://github.com/doublecmd/doublecmd/releases/download/v${VER}/doublecmd-${VER}.gtk2.${ARCH}.tar.xz" |
    tar -C "${DST}" --strip-components 1 -xJ
  curl -LO 'https://github.com/doublecmd/doublecmd/raw/refs/heads/master/install/linux/doublecmd.desktop' \
    --output-dir "${DST}/"
  command -v desktop-file-edit >/dev/null &&
    desktop-file-install --dir="${PREFIX}/share/applications" \
      --set-icon="${DST}/doublecmd.png" \
      --set-key=Exec --set-value="${DST}/doublecmd %f" \
      "${DST}/doublecmd.desktop"

  ln -sf "${DST}/doublecmd" "${PREFIX}/bin/"
)

#: entr
(
  set -euo pipefail
  VER=5.8
  PKG=entr
  SRC="${TMPDIR}/${USER}/${PKG}"

  mkdir -p "${SRC}"
  curl -sL "https://github.com/eradman/entr/archive/refs/tags/${VER}.tar.gz" |
    tar -C "${SRC}/" --strip-components=1 -xvz

  cd "${SRC}"
  ./configure
  PREFIX="${STOW_PKGS}/${PKG}" make install

  stow --dir="${STOW_PKGS}" --target="${PREFIX}" --restow "${PKG}"
  rm -rf "${SRC}"
)

#: git-lfs
(
  set -euo pipefail
  VER=3.7.1
  PKG=git-lfs
  SRC="${TMPDIR}/${USER}/${PKG}"

  mkdir -p "${SRC}" "${STOW_PKGS}/${PKG}"
  curl -sL "https://github.com/git-lfs/git-lfs/releases/download/v${VER}/git-lfs-linux-amd64-v${VER}.tar.gz" |
    tar -C "${SRC}/" --strip-components=1 -xvz

  PREFIX="${STOW_PKGS}/${PKG}" "${SRC}/install.sh"

  stow --dir="${STOW_PKGS}" --target="${PREFIX}" --restow "${PKG}"
  rm -rf "${SRC}"
)

#: kitty
(
  set -euo pipefail
  PKG=kitty.app
  DST="${STOW_PKGS}/${PKG}"

  curl -L 'https://sw.kovidgoyal.net/kitty/installer.sh' |
    sh /dev/stdin dest="${STOW_PKGS}"

  sed -i "s|Icon=kitty|Icon=${STOW_PKGS}/${PKG}/share/icons/hicolor/256x256/apps/kitty.png|g" \
    "${STOW_PKGS}/${PKG}/share/applications/kitty"*.desktop
  sed -i "s|Exec=kitty|Exec=${STOW_PKGS}/${PKG}/bin/kitty|g" \
    "${STOW_PKGS}/${PKG}/share/applications/kitty"*.desktop
  echo 'kitty.desktop' >~/.config/xdg-terminals.list

  ln -sf "${STOW_PKGS}/${PKG}/bin/kitt"{en,y} "${PREFIX}/bin/"
  ln -sf "${STOW_PKGS}/${PKG}/share/applications/"*.desktop "${PREFIX}/share/applications/"
  # stow --dir=$(dirname "${DST}") --target="${PREFIX}" --restow "${PKG}"
)

#: lf
(
  PKG=lf
  DST="${STOW_PKGS}/${PKG}"

  mkdir -p "${DST}/bin"
  curl -sL 'https://github.com/gokcehan/lf/releases/latest/download/lf-linux-amd64.tar.gz' |
    tar -C "${DST}/bin" -xvz
  curl -sLO 'https://github.com/gokcehan/lf/raw/refs/heads/master/lf.1' \
    --output-dir "${DST}/man/man1" --create-dirs

  stow --dir=$(dirname "${DST}") --target="${PREFIX}" --restow "${PKG}"
)

#: NerdFonts
(
  set -euo pipefail
  PKG=NerdFonts
  SRC="${TMPDIR}/${USER}/${PKG}"
  DST="${STOW_PKGS}/${PKG}/share/fonts"

  mkdir -p "${DST}"
  for font in JetBrainsMono; do
    curl -LO "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font}.zip" \
      --output-dir "${SRC}" --create-dirs
    unzip -ojq "${SRC}/${font}.zip" -d "${DST}"
  done

  stow --dir="${STOW_PKGS}" --target="${PREFIX}" --restow "${PKG}"
  rm -rf "${SRC}/${PKG}"
)

#: nvm
(
  set -euo pipefail
  VER=0.40.5
  NVM_DIR=${NVM_DIR:-${PREFIX}/opt/nvm}

  mkdir -p "${NVM_DIR}"
  curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v${VER}/install.sh" |
    PROFILE=/dev/null NVM_DIR="${NVM_DIR}" bash
)

#: paraview
(
  set -euo pipefail
  VER=6.1.1
  PKG="ParaView-${VER%.*}"
  DST="${STOW_PKGS}/${PKG}"
  PY=3.12

  mkdir -p "${DST}"
  curl -sL "https://www.paraview.org/files/v${VER%.*}/ParaView-${VER}-MPI-Linux-Python${PY}-x86_64.tar.gz" |
    tar -C "${DST}" --strip-components 1 -xvz
  command -v desktop-file-edit >/dev/null &&
    desktop-file-install --dir="${DST}/share/applications" \
      --set-name="ParaView v${VER%.*}" \
      --set-icon="${DST}/share/icons/hicolor/96x96/apps/paraview.png" \
      --set-key=Exec --set-value="${DST}/bin/paraview %f" \
      --set-key=TryExec --set-value="${DST}/bin/paraview" \
      --set-key=StartupWMClass --set-value="${DST}/bin/paraview" \
      "${DST}/share/applications/org.paraview.ParaView.desktop"

  stow --dir=$(dirname "${DST}") --target="${PREFIX}" --restow "${PKG}"
)

#: pigz
(
  set -euo pipefail
  VER=2.8
  PKG=pigz
  SRC="${TMPDIR}/${USER}/${PKG}"
  DST="${STOW_PKGS}/${PKG}"

  mkdir -p "${SRC}"
  curl -sLk "https://github.com/madler/pigz/archive/refs/tags/v${VER}.tar.gz" |
    tar -C "${SRC}/" --strip-components=1 -xvz

  make -C "${SRC}"

  mkdir -p "${DST}/"{bin,share/man/man1}
  find "${SRC}" -maxdepth 1 -executable -type f -exec mv -f {} "${DST}/bin" \;
  mv -f "${SRC}/pigz.1" "${DST}/share/man/man1/"

  stow --dir=$(dirname "${DST}") --target="${PREFIX}" --restow "${PKG}"
  rm -rf "${SRC}"
)

#: REFPROP
(
  set -euo pipefail
  PKG=REFPROP
  SRC="${TMPDIR}/${USER}/${PKG}"
  DST="${PREFIX}/opt/${PKG}"

  # There should be REFPROP.tar.xz at the destination with REFPROP/FORTRAN/ inside
  tar -C $(dirname "${DST}") -xJvf "${DST}.tar.xz"
  git clone --recurse-submodules https://github.com/usnistgov/REFPROP-cmake.git "${SRC}"
  stow --dir="${DST}" --target="${SRC}" .

  mkdir -p "${SRC}/build"
  cd "${SRC}/build"

  uv venv --system-site-packages
  source .venv/bin/activate
  uv pip install numpy six

  cmake .. -DCMAKE_BUILD_TYPE=Release
  cmake --build . --config Release

  mv -f librefprop.* *.h "${DST}/"
  rm -rf "${SRC}"
)

#: spack
(
  set -euo pipefail
  VER=1.2.0

  mkdir -p "${SPACK_ROOT}"
  curl -sL "https://github.com/spack/spack/releases/download/v${VER}/spack-${VER}.tar.gz" |
    tar -C "${SPACK_ROOT}" --strip-components 1 -xvz

  source "${SPACK_ROOT}/share/spack/setup-env.sh"
  # module load triton/2025.1-gcc gcc/13.3.0 openmpi/5.0.3 patch/2.7.6 flex/2.6.4
  spack compiler find
)

#: vscode
(
  set -euo pipefail
  DST="${PREFIX}/opt/vscode"

  mkdir -p "${DST}"
  curl -sL 'https://code.visualstudio.com/sha/download?build=stable&os=linux-x64' |
    tar -C "${DST}" --strip-components 1 -xvz
  curl -LO https://github.com/microsoft/vscode/raw/refs/heads/main/resources/linux/code.desktop \
    --output-dir "${DST}/resources/app/resources/linux/"

  ln -sf "${DST}/bin/code" "${PREFIX}/bin/"
  sed "
    s|@@NAME_LONG@@|Visual Studio Code|g
    s|@@NAME@@|code|g
    s|@@NAME_SHORT@@|Code|g
    s|@@EXEC@@|${DST}/bin/code --no-sandbox|g
    s|@@ICON@@|${DST}/resources/app/resources/linux/code.png|g
  " "${DST}/resources/app/resources/linux/code.desktop" >"${PREFIX}/share/applications/code.desktop"

  ln -sf "${DST}/resources/completions/bash/code" "${BASH_COMPLETION_USER_DIR}/code.bash"
)
