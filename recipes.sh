#!/usr/bin/env bash

export PREFIX=${PREFIX:-$HOME/.local}
export TMPDIR=${TMPDIR:-/tmp}

export STOW_PKGS=${STOW_PKGS:-$PREFIX/stow}
export SPACK_ROOT=${SPACK_ROOT:-$PREFIX/opt/spack}

export BASH_COMPLETION_USER_DIR=${BASH_COMPLETION_USER_DIR:-$PREFIX/share/bash-completion/completions}

mkdir -p "${PREFIX}/"{bin,etc/profile.d,include,lib{,64},opt,share/{applications,doc,icons,fonts,man/man{1,2,3,4,5,6,7,8,9}},state/{ba,z}sh}/ \
  "${BASH_COMPLETION_USER_DIR}" "${STOW_PKGS}"

#: stow
(
  set -euo pipefail
  PKG=stow
  SRC="${TMPDIR}/${USER}/${PKG}"
  DST="${STOW_PKGS}/${PKG}"

  mkdir -p "${SRC}/"
  curl -sL 'http://ftp.gnu.org/gnu/stow/stow-latest.tar.gz' |
    tar -C "${SRC}/" --strip-components=1 -xz

  cd "${SRC}"
  "${SRC}/configure" --prefix="${DST}"
  make install

  ./bin/stow --dir=$(dirname "${DST}") --target="${PREFIX}" --restow "${PKG}"
  rm -rf "${SRC}"
)

#: atuin
(
  set -euo pipefail
  PKG=atuin
  PLATFORM="unknown-$(uname -s | tr '[:upper:]' '[:lower:]')-musl" # "unknown-${OSTYPE}"
  ARCH=$(uname -p)
  DST="${STOW_PKGS}/${PKG}"

  mkdir -p "${DST}/"{bin,etc/profile.d,share/{bash-completion/completions,zsh/site-functions}}/
  curl -sL "https://github.com/atuinsh/${PKG}/releases/latest/download/${PKG}-${ARCH}-${PLATFORM}.tar.gz" |
    tar -C "${DST}/bin/" --strip-components=1 -xz --wildcards "*${PKG}"

  "${DST}/bin/${PKG}" gen-completions --shell bash >"${DST}/share/bash-completion/completions/${PKG}.bash"
  "${DST}/bin/${PKG}" gen-completions --shell zsh >"${DST}/share/zsh/site-functions/_${PKG}"
  "${DST}/bin/${PKG}" init bash >"${DST}/etc/profile.d/1c.${PKG}.bash"
  "${DST}/bin/${PKG}" init zsh >"${DST}/etc/profile.d/1c.${PKG}.zsh"
  chmod +x "${DST}/"{etc/profile.d,share/{bash-completion/completions,zsh/site-functions}}/*"${PKG}"*

  stow --dir=$(dirname "${DST}") --target="${PREFIX}" --restow "${PKG}"
)

#: bat
(
  set -euo pipefail
  VER=0.26.1
  PKG=bat
  ARCH=$(uname -p)
  PLATFORM="unknown-${OSTYPE}"
  DST="${STOW_PKGS}/${PKG}"

  mkdir -p "${DST}/"{bin,share/{bash-completion/completions,zsh/site-functions,man/man1}}/
  curl -sL "https://github.com/sharkdp/${PKG}/releases/download/v${VER}/${PKG}-v${VER}-${ARCH}-${PLATFORM}.tar.gz" |
    tar -C "${DST}/" --strip-components=1 -xz --wildcards-match-slash "*/${PKG}*"

  mv -f "${DST}/${PKG}" "${DST}/bin/${PKG}"
  mv -f "${DST}/autocomplete/"*.bash "${DST}/share/bash-completion/completions/"
  mv -f "${DST}/autocomplete/${PKG}.zsh" "${DST}/share/zsh/site-functions/_${PKG}"
  mv -f "${DST}/"*.1 "${DST}/share/man/man1/"
  rm -rf "${DST}/autocomplete/"

  stow --dir=$(dirname "${DST}") --target="${PREFIX}" --restow "${PKG}"
  "${PKG}" cache --build
)

#: entr
(
  set -euo pipefail
  VER=5.8
  PKG=entr
  SRC="${TMPDIR}/${USER}/${PKG}"
  DST="${STOW_PKGS}/${PKG}"

  mkdir -p "${SRC}/"
  curl -sL "https://github.com/eradman/entr/archive/refs/tags/${VER}.tar.gz" |
    tar -C "${SRC}/" --strip-components=1 -xz

  cd "${SRC}"
  ./configure
  PREFIX="${DST}" make install

  stow --dir=$(dirname "${DST}") --target="${PREFIX}" --restow "${PKG}"
  rm -rf "${SRC}"
)

#: eza
(
  set -euo pipefail
  VER=0.23.5
  PKG=eza
  PLATFORM="unknown-${OSTYPE}"
  ARCH=$(uname -p)
  DST="${STOW_PKGS}/${PKG}"

  mkdir -p "${DST}/"{bin,share/{bash-completion/completions,zsh/site-functions,man/man{1,5}}}/
  curl -sL "https://github.com/eza-community/${PKG}/releases/download/v${VER}/${PKG}_${ARCH}-${PLATFORM}.tar.gz" |
    tar -C "${DST}/bin/" --strip-components=1 -xz
  curl -sL "https://github.com/eza-community/${PKG}/releases/download/v${VER}/completions-${VER}.tar.gz" |
    tar -C "${DST}/share/zsh/site-functions/" --strip-components=3 -xz --wildcards "*${PKG}"
  curl -sL "https://github.com/eza-community/${PKG}/releases/download/v${VER}/man-${VER}.tar.gz" |
    tar -C "${DST}/share/man/man1/" --strip-components=3 -xz

  mv -f "${DST}/share/zsh/site-functions/${PKG}" "${DST}/share/bash-completion/completions/${PKG}.bash"
  mv -f "${DST}/share/man/man1/"*.5 "${DST}/share/man/man5/"

  stow --dir=$(dirname "${DST}") --target="${PREFIX}" --restow "${PKG}"
)

#: CoolProp
(
  set -euo pipefail
  VER=8.0.0
  PKG=CoolProp
  PLATFORM=$(uname -s)
  DST="${STOW_PKGS}/${PKG}"

  SRC="https://sourceforge.net/projects/coolprop/files/CoolProp/${VER}/shared_library"

  curl -sLO "${SRC}/CoolPropLib.h" --output-dir "${DST}/include" --create-dirs
  curl -sLO "${SRC}/${PLATFORM}/64bit/libCoolProp.so" --output-dir "${DST}/lib" --create-dirs

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
  VER=1.2.8
  PKG=doublecmd
  ARCH=$(uname -p)
  DST="${STOW_PKGS}/${PKG}"

  mkdir -p "${DST}/bin/"
  curl -sL "https://github.com/${PKG}/${PKG}/releases/download/v${VER}/${PKG}-${VER}.gtk2.${ARCH}.tar.xz" |
    tar -C "${DST}" --strip-components 1 -xJ
  curl -sLO "https://github.com/${PKG}/${PKG}/raw/refs/heads/master/install/linux/${PKG}.desktop" \
    --output-dir "${DST}/share/applications/" --create-dirs

  ln -sf "../${PKG}" "${DST}/bin/${PKG}"
  command -v desktop-file-edit >/dev/null &&
    desktop-file-install --dir="${DST}/share/applications" \
      --set-icon="${DST}/pixmaps/mainicon/alt/256px-doublecmd.png" \
      --set-key=Exec --set-value="${DST}/doublecmd %f" \
      "${DST}/share/applications/doublecmd.desktop"

  printf '^(?!/(bin|share)($|/)).*\n' >"${DST}/.stow-local-ignore"
  stow --dir=$(dirname "${DST}") --target="${PREFIX}" --restow "${PKG}"
)

#: entr
(
  set -euo pipefail
  VER=5.8
  PKG=entr
  SRC="${TMPDIR}/${USER}/${PKG}"

  mkdir -p "${SRC}"
  curl -sL "https://github.com/eradman/entr/archive/refs/tags/${VER}.tar.gz" |
    tar -C "${SRC}/" --strip-components=1 -xz

  cd "${SRC}"
  ./configure
  PREFIX="${STOW_PKGS}/${PKG}" make install

  stow --dir=$(dirname "${DST}") --target="${PREFIX}" --restow "${PKG}"
  rm -rf "${SRC}"
)

#: fd
(
  set -euo pipefail
  VER=10.4.2
  PKG=fd
  PLATFORM="unknown-${OSTYPE}"
  ARCH=$(uname -p)
  DST="${STOW_PKGS}/${PKG}"

  mkdir -p "${DST}/"{bin,share/{bash-completion/completions,zsh/site-functions,man/man1}}/
  curl -sL "https://github.com/sharkdp/${PKG}/releases/download/v${VER}/${PKG}-v${VER}-${ARCH}-${PLATFORM}.tar.gz" |
    tar -C "${DST}/" --strip-components=1 -xz --wildcards-match-slash '*/'{"${PKG}*","*${PKG}"}

  mv -f "${DST}/${PKG}" "${DST}/bin/${PKG}"
  mv -f "${DST}/autocomplete/"*.bash "${DST}/share/bash-completion/completions/"
  mv -f "${DST}/autocomplete/_${PKG}" "${DST}/share/zsh/site-functions/"
  mv -f "${DST}/"*.1 "${DST}/share/man/man1/"
  rm -rf "${DST}/autocomplete/"

  stow --dir=$(dirname "${DST}") --target="${PREFIX}" --restow "${PKG}"
)

#: fzf
(
  set -euo pipefail
  VER=0.74.2
  PKG=fzf
  PLATFORM=$(uname -s | tr '[:upper:]' '[:lower:]')
  ARCH=$(uname -p | sed 's|x86_|amd|;s|arch|rm|')
  DST="${STOW_PKGS}/${PKG}"

  mkdir -p "${DST}/"{bin,etc/profile.d}/
  curl -sL "https://github.com/junegunn/${PKG}/releases/download/v${VER}/${PKG}-${VER}-${PLATFORM}_${ARCH}.tar.gz" |
    tar -C "${DST}/bin/" -xz

  "${DST}/bin/${PKG}" --bash >"${DST}/etc/profile.d/1b.${PKG}.bash"
  "${DST}/bin/${PKG}" --zsh >"${DST}/etc/profile.d/1b.${PKG}.zsh"

  stow --dir=$(dirname "${DST}") --target="${PREFIX}" --restow "${PKG}"
)

#: kitty
(
  set -euo pipefail
  PKG=kitty.app
  DST="${STOW_PKGS}/${PKG}"

  curl -sL 'https://sw.kovidgoyal.net/kitty/installer.sh' |
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

#: lazygit
(
  set -euo pipefail
  PKG=lazygit
  VER=0.64.0
  PLATFORM="$(uname -s | tr '[:upper:]' '[:lower:]')"
  ARCH="$(uname -p | sed 's|arch|rm|')"
  DST="${STOW_PKGS}/${PKG}"

  mkdir -p "${DST}/bin"
  curl -sL "https://github.com/jesseduffield/${PKG}/releases/download/v${VER}/${PKG}_${VER}_${PLATFORM}_${ARCH}.tar.gz" |
    tar -C "${DST}/bin" -xz --wildcards "${PKG}"

  stow --dir=$(dirname "${DST}") --target="${PREFIX}" --restow "${PKG}"
)

#: lf
(
  PKG=lf
  PLATFORM=$(uname -s | tr '[:upper:]' '[:lower:]')
  ARCH=$(uname -p | sed 's|x86_|amd|;s|arch|rm|')
  DST="${STOW_PKGS}/${PKG}"

  mkdir -p "${DST}/bin"
  curl -sL "https://github.com/gokcehan/lf/releases/latest/download/${PKG}-${PLATFORM}-${ARCH}.tar.gz" |
    tar -C "${DST}/bin" -xz
  curl -sLO 'https://github.com/gokcehan/lf/raw/refs/heads/master/lf.1' \
    --output-dir "${DST}/man/man1" --create-dirs

  stow --dir=$(dirname "${DST}") --target="${PREFIX}" --restow "${PKG}"
)

#: nvim
(
  set -euo pipefail
  PKG=nvim
  PLATFORM=$(uname -s | tr '[:upper:]' '[:lower:]')
  ARCH=$(uname -p | sed 's|arch|rm|')
  DST="${STOW_PKGS}/${PKG}"

  mkdir -p "${DST}/"
  curl -sL "https://github.com/neovim/neovim/releases/latest/download/${PKG}-${PLATFORM}-${ARCH}.tar.gz" |
    tar -C "${DST}/" --strip-components=1 -xz

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
    curl -sLO "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font}.zip" \
      --output-dir "${SRC}" --create-dirs
    unzip -ojq "${SRC}/${font}.zip" -d "${DST}"
  done

  stow --dir="${STOW_PKGS}" --target="${PREFIX}" --restow "${PKG}"
  rm -rf "${SRC}/${PKG}"
)

#: nvm
(
  set -euo pipefail
  VER=0.40.6
  NVM_DIR=${NVM_DIR:-${PREFIX}/opt/nvm}

  mkdir -p "${NVM_DIR}"
  curl -so- "https://raw.githubusercontent.com/nvm-sh/nvm/v${VER}/install.sh" |
    PROFILE=/dev/null NVM_DIR="${NVM_DIR}" bash
)

#: paraview
(
  set -euo pipefail
  VER=6.1.1
  PKG="paraview-${VER%.*}"
  PLATFORM=$(uname -s)
  ARCH=$(uname -p)
  PY=3.12
  DST="${STOW_PKGS}/${PKG}"

  mkdir -p "${DST}"
  curl -sL "https://www.paraview.org/files/v${VER%.*}/ParaView-${VER}-MPI-${PLATFORM}-Python${PY}-${ARCH}.tar.gz" |
    tar -C "${DST}" --strip-components 1 -xz
  command -v desktop-file-edit >/dev/null && desktop-file-edit \
    --set-name="ParaView v${VER}" \
    --set-icon="${DST}/share/icons/hicolor/96x96/apps/paraview.png" \
    --set-key=Exec --set-value="${DST}/bin/paraview %f" \
    --set-key=TryExec --set-value="${DST}/bin/paraview" \
    --set-key=StartupWMClass --set-value="${DST}/bin/paraview" \
    "${DST}/share/applications/org.paraview.ParaView.desktop"

  stow --dir=$(dirname "${DST}") --target="${PREFIX}" --restow "${PKG}"
)

#: REFPROP
(
  set -euo pipefail
  PKG=REFPROP
  SRC="${TMPDIR}/${USER}/${PKG}"
  DST="${PREFIX}/opt/${PKG}"

  # There should be REFPROP.tar.xz at the destination with REFPROP/FORTRAN/ inside
  tar -C $(dirname "${DST}") -xJf "${DST}.tar.xz"
  git clone --recurse-submodules https://github.com/usnistgov/REFPROP-cmake.git "${SRC}"
  stow --dir="${DST}" --target="${SRC}" .

  mkdir -p "${SRC}/build"
  cd "${SRC}/build"

  source "${SPACK_ROOT}/share/spack/setup-env.sh"
  spack load cmake python py-numpy py-six

  cmake .. -DCMAKE_BUILD_TYPE=Release
  cmake --build . --config Release

  mv -f librefprop.* *.h "${DST}/"
  rm -rf "${SRC}"
)

#: ripgrep
(
  set -euo pipefail
  VER=15.2.0
  PKG=ripgrep
  PLATFORM="unknown-$(uname -s | tr '[:upper:]' '[:lower:]')-musl"
  ARCH=$(uname -m)
  DST="${STOW_PKGS}/${PKG}"

  mkdir -p "${DST}/"{bin,share/{bash-completion/completions,zsh/site-functions},man/man1}}/
  curl -sL "https://github.com/BurntSushi/${PKG}/releases/download/${VER}/${PKG}-${VER}-${ARCH}-${PLATFORM}.tar.gz" |
    tar -C "${DST}/" --strip-components=1 -xz --wildcards-match-slash "*/*rg*"

  mv -f "${DST}/rg" "${DST}/bin/"
  mv -f "${DST}/complete/"*.bash "${DST}/share/bash-completion/completions/"
  mv -f "${DST}/complete/_rg" "${DST}/share/zsh/site-functions/"
  mv -f "${DST}/doc/"*.1 "${DST}/share/man/man1/"
  rm -rf "${DST}/"{doc,complete}/
  chmod +x "${DST}/share/"{bash-completion,zsh}/completions/*"${PKG}"*

  stow --dir=$(dirname "${DST}") --target="${PREFIX}" --restow "${PKG}"
)

#: spack
(
  set -euo pipefail
  VER=1.2.0

  mkdir -p "${SPACK_ROOT}"
  curl -sL "https://github.com/spack/spack/releases/download/v${VER}/spack-${VER}.tar.gz" |
    tar -C "${SPACK_ROOT}" --strip-components 1 -xz

  source "${SPACK_ROOT}/share/spack/setup-env.sh"
  # module load triton/2025.1-gcc gcc/13.3.0 openmpi/5.0.3 patch/2.7.6 flex/2.6.4
  spack compiler find
)

#: starship
(
  set -euo pipefail
  PKG=starship
  DST="${STOW_PKGS}/${PKG}"

  mkdir -p "${DST}/"{bin,etc/profile.d,share/{bash-completion/completions,zsh/site-functions}}/
  curl -sS https://starship.rs/install.sh |
    sh -s -- -y --bin-dir "${DST}/bin/"

  "${DST}/bin/${PKG}" completions bash >"${DST}/share/bash-completion/completions/${PKG}.bash"
  "${DST}/bin/${PKG}" completions zsh >"${DST}/share/zsh/site-functions/_${PKG}"
  "${DST}/bin/${PKG}" init bash --print-full-init >"${DST}/share/profile.d/0a.${PKG}.bash"
  "${DST}/bin/${PKG}" init zsh >"${DST}/share/profile.d/0a.${PKG}.zsh"
  chmod +x "${DST}/"{bin,etc/profile.d,share/{bash-completion/completions,zsh/site-functions}}/*"${PKG}"*

  stow --dir=$(dirname "${DST}") --target="${PREFIX}" --restow "${PKG}"
)

#: vscode
(
  set -euo pipefail
  PKG=code
  DST="${STOW_PKGS}/${PKG}"

  mkdir -p "${DST}/share/"{bash-completion/completions,zsh/site-functions}/
  curl -sL 'https://code.visualstudio.com/sha/download?build=stable&os=linux-x64' |
    tar -C "${DST}" --strip-components 1 -xz
  curl -sLO "https://github.com/microsoft/vscode/raw/refs/heads/main/resources/linux/${PKG}.desktop" \
    --output-dir "${DST}/share/applications/" --create-dirs

  mv -f "${DST}/resources/completions/bash/${PKG}" "${DST}/share/bash-completion/completions/${PKG}.bash"
  mv -f "${DST}/resources/completions/zsh/"* "${DST}/share/zsh/site-functions/"
  sed -i "
    s|@@NAME_LONG@@|Visual Studio Code|g
    s|@@NAME@@|code|g
    s|@@NAME_SHORT@@|Code|g
    s|@@EXEC@@|${DST}/bin/code --no-sandbox|g
    s|@@ICON@@|${DST}/resources/app/resources/linux/code.png|g
  " "${DST}/share/applications/${PKG}.desktop"

  printf '^(?!/(bin|share)($|/)).*\n' >"${DST}/.stow-local-ignore"
  stow --dir=$(dirname "${DST}") --target="${PREFIX}" --restow "${PKG}"
)

#: yq
(
  PKG=yq
  PLATFORM=$(uname -s | tr '[:upper:]' '[:lower:]')
  ARCH=$(uname -p | sed 's|x86_|amd|;s|arch|rm|')
  DST="${STOW_PKGS}/${PKG}"

  mkdir -p "${DST}/"{bin,share/man/man1}/
  curl -sL "https://github.com/mikefarah/${PKG}/releases/latest/download/${PKG}_${PLATFORM}_${ARCH}.tar.gz" |
    tar -C "${DST}" -xz --wildcards "*${PKG}*"

  mv -f "${DST}/${PKG}_${PLATFORM}_${ARCH}" "${DST}/bin/${PKG}"
  mv -f "${DST}/"*.1 "${DST}/share/man/man1/"

  stow --dir=$(dirname "${DST}") --target="${PREFIX}" --restow "${PKG}"
)

#: zsh
(
  set -euo pipefail
  PKG=zsh
  SRC="${TMPDIR}/${USER}/${PKG}"
  DST="${STOW_PKGS}/${PKG}"

  mkdir -p "${SRC}"
  curl -sL "https://sourceforge.net/projects/zsh/files/latest/download" |
    tar -C "${SRC}/" --strip-components 1 -xJ

  cd "${SRC}"
  "${SRC}/configure" --prefix="${DST}"

  make
  mkdir -p "${DST}"
  make install

  stow --dir=$(dirname "${DST}") --target="${PREFIX}" --restow "${PKG}"
  rm -rf "${SRC}"
)
