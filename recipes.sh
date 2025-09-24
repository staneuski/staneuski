#!/usr/bin/env bash

export PREFIX=${PREFIX:-$HOME/.local}
export TMPDIR=${TMPDIR:-/tmp}

export HOMEBREW_PREFIX=${HOMEBREW_PREFIX:-$PREFIX/opt/homebrew}
export NIX_PREFIX=${NIX_PREFIX:-$PREFIX/nix}

mkdir -p $PREFIX/{bin,opt,share/man/man{1,2,3,4,5,6,7,8,9}}
mkdir -p $BASH_COMPLETION_USER_DIR

#: atuin
(
  # curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
)

#: curl
(
  set -euo pipefail
  VER=8.15.0
  SRC="${TMPDIR}/${USER}/curl"

  mkdir -p $SRC
  curl -sL https://curl.se/download/curl-${VER}.tar.gz |
    tar -C $SRC/ --strip-components=1 -xvz

  cd $SRC
  ./configure --prefix=$PREFIX --with-openssl
  make -j$(nproc)
  make install

  rm -rf $SRC
)

#: bat
(
  set -euo pipefail
  VER=0.25.0
  ARCH=$(uname -m)
  SRC="${TMPDIR}/${USER}/bat"

  mkdir -p $SRC
  curl -sL https://github.com/sharkdp/bat/releases/download/v${VER}/bat-v${VER}-${ARCH}-unknown-linux-musl.tar.gz |
    tar -C $SRC/ --strip-components=1 -xvz

  mv -f $SRC/bat $PREFIX/bin/
  mv -f $SRC/*.1 $PREFIX/share/man/man1/
  mv -f $SRC/autocomplete/bat.bash $BASH_COMPLETION_USER_DIR/

  rm -rf $SRC
)

#: brew
(
  set -euo pipefail

  # https://docs.brew.sh/Installation#alternative-installs
  mkdir -p $HOMEBREW_PREFIX
  curl -L https://github.com/Homebrew/brew/tarball/master |
    tar -C $HOMEBREW_PREFIX --strip-components 1 -xvz

  eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
  brew update --force --quiet
  chmod -R go-w "$($HOMEBREW_PREFIX/bin/brew --prefix)/share/zsh"
)

#: direnv
(
  set -euo pipefail
  ARCH=$(uname | tr '[:upper:]' '[:lower:]')

  curl -sL https://github.com/direnv/direnv/releases/latest/download/direnv.linux-amd64 \
    --output $PREFIX/direnv
)

#: entr
(
  set -euo pipefail
  VER=5.7
  SRC="${TMPDIR}/${USER}/entr"

  mkdir -p $SRC
  curl -sL https://github.com/eradman/entr/archive/refs/tags/${VER}.tar.gz |
    tar -C $SRC/ --strip-components=1 -xvz

  $SRC/./configure
  cd $SRC
  PREFIX=$PREFIX make install

  rm -rf $SRC
)

#: eza
(
  set -euo pipefail
  VER=0.22.1
  ARCH=$(uname -m)
  SRC="${TMPDIR}/${USER}/eza"

  mkdir -p $SRC
  curl -sL https://github.com/eza-community/eza/releases/download/v${VER}/eza_${ARCH}-unknown-linux-musl.tar.gz |
    tar -C $PREFIX/bin -xvz
  for d in completions man; do
    mkdir -p $SRC/$d
    curl -sL https://github.com/eza-community/eza/releases/download/v${VER}/${d}-${VER}.tar.gz |
      tar -C $SRC/$d --strip-components=3 -xvz
  done

  mv -f $SRC/completions/eza $BASH_COMPLETION_USER_DIR/eza.bash
  mv -f $SRC/man/*.1 $PREFIX/share/man/man1/
  mv -f $SRC/man/*.5 $PREFIX/share/man/man5/

  rm -rf $SRC
)

#: fzf
(
  VER=0.64.0

  curl -sL https://github.com/junegunn/fzf/releases/download/v${VER}/fzf-${VER}-linux_amd64.tar.gz |
    tar -C $PREFIX/bin -xvz

  fzf --bash >$BASH_COMPLETION_USER_DIR/fzf.bash
)

#: git
(
  set -euo pipefail
  VER=2.50.1
  SRC="${TMPDIR}/${USER}/git"

  mkdir -p $SRC
  curl -L https://mirrors.edge.kernel.org/pub/software/scm/git/git-v${VER}.tar.xz |
    tar -C $SRC/ --strip-components=1 -xvz

  # Use curl installed in $PREFIX
  export CFLAGS="-I$PREFIX/include"
  export LDFLAGS="-L$PREFIX/lib"
  export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig"

  cd $SRC
  $SRC/./configure --prefix=$PREFIX --with-curl=$PREFIX
  make prefix=$PREFIX install

  rm -rf $SRC
)

#: git-lfs
(
  set -euo pipefail
  VER=3.7.0
  ARCH=$(uname -m)
  SRC="${TMPDIR}/${USER}/git-lfs"

  mkdir -p $SRC
  curl -sL https://github.com/git-lfs/git-lfs/releases/download/v${VER}/git-lfs-linux-amd64-v${VER}.tar.gz |
    tar -C $SRC/ --strip-components=1 -xvz

  PREFIX=$PREFIX $SRC/install.sh

  mv -f $SRC/man/man1/* $PREFIX/share/man/man1/
  mv -f $SRC/man/man5/* $PREFIX/share/man/man5/
  mv -f $SRC/man/man7/* $PREFIX/share/man/man7/

  rm -rf $SRC
)

#: jq
(
  set -euo pipefail
  VER=1.8.1

  curl -L https://github.com/jqlang/jq/releases/download/jq-${VER}/jq-linux-amd64 \
    --output $PREFIX/bin/jq
  chmod +x $PREFIX/bin/jq

  curl -sL https://github.com/jqlang/jq/releases/download/jq-${VER}/jq-${VER}.tar.gz |
    tar -C $PREFIX/share/man/man1 --strip-components=1 -xvz jq-${VER}/jq.1
)

#: lazygit
(
  VER=0.53.0
  ARCH=$(uname -m)

  curl -sL https://github.com/jesseduffield/lazygit/releases/download/v${VER}/lazygit_${VER}_Linux_${ARCH}.tar.gz |
    tar -C $PREFIX/bin -xvz lazygit
)

#: lf
(
  curl -sL https://github.com/gokcehan/lf/releases/latest/download/lf-linux-amd64.tar.gz |
    tar -C $PREFIX/bin -xvz
)

#: navi
(
  set -euo pipefail
  VER=2.24.0
  ARCH=$(uname -m)

  curl -sL https://github.com/denisidoro/navi/releases/download/v${VER}/navi-v${VER}-${ARCH}-unknown-linux-musl.tar.gz |
    tar -C $PREFIX/bin -xvz
)

#: nix
(
  set -euo pipefail
  VER=1.2.2
  ARCH=$(uname -m)

  curl -sL https://github.com/nix-community/nix-user-chroot/releases/download/${VER}/nix-user-chroot-bin-${VER}-x86_64-unknown-linux-musl \
    --output $PREFIX/bin/nix-user-chroot
  chmod +x $PREFIX/bin/nix-user-chroot

  nix-user-chroot $NIX_PREFIX bash -c "curl -L https://nixos.org/nix/install | bash"
)

#: neovim
(
  curl -sL https://github.com/neovim/neovim-releases/releases/download/stable/nvim-linux-x86_64.tar.gz |
    tar -C $PREFIX --strip-components=1 -xvz
)

#: NerdFonts
(
  set -euo pipefail
  FONT=JetBrainsMono
  SRC="${TMPDIR}/${USER}/"
  DST="${PREFIX}/share/fonts/"

  mkdir -p "${SRC}" "${DST}"
  curl -LO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$FONT.zip \
    --create-dirs --output-dir "${SRC}"
  unzip -j -q "${SRC}/${FONT}.zip" -d "${DST}"

  # rm -rf "${SRC}/${FONT}.zip"
)

#: nvm
(
  set -euo pipefail
  VER=0.40.3

  mkdir -p $NVM_DIR
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v$VER/install.sh | NVM_DIR=$NVM_DIR bash
)

#: paraview
(
  set -euo pipefail
  VER=6.0.0
  PY=3.12
  RENDERING="" # "" | "-egl" | "-osmesa"
  DST="${PREFIX}/opt/ParaView-${VER%.*}"

  mkdir -p "${DST}"
  curl -sL "https://www.paraview.org/files/v${VER%.*}/ParaView-${VER}${RENDERING}-MPI-Linux-Python${PY}-x86_64.tar.gz" |
    tar -C "${DST}" --strip-components 1 -xvz

  ln -sf "${DST}/bin/"* "${PREFIX}/bin/"

  command -v desktop-file-edit >/dev/null &&
    desktop-file-install --dir="${HOME}/.local/share/applications" \
      --set-name="ParaView v${VER%.*}" \
      --set-icon="${DST}/share/icons/hicolor/96x96/apps/paraview.png" \
      --set-key=Exec --set-value="${DST}/bin/paraview %f" \
      --set-key=TryExec --set-value="${DST}/bin/paraview" \
      --set-key=StartupWMClass --set-value="${DST}/bin/paraview" \
      "${DST}/share/applications/org.paraview.ParaView.desktop"
)

#: pigz
(
  set -euo pipefail
  VER=2.8
  SRC="${TMPDIR}/${USER}/pigz"

  mkdir -p $SRC
  curl -sL https://github.com/madler/pigz/archive/refs/tags/v${VER}.tar.gz |
    tar -C $SRC/ --strip-components=1 -xvz

  cd $SRC
  make

  mv -f $SRC/{,un}pigz $PREFIX/bin/
  mv -f $SRC/*.1 $PREFIX/share/man/man1/

  rm -rf $SRC
)

#: rclone
(
  set -euo pipefail
  VER=1.70.3
  ARCH=$(uname | tr '[:upper:]' '[:lower:]')
  SRC="${TMPDIR}/${USER}/rclone"
  [ "$ARCH" = "darwin" ] && ARCH="osx"

  echo "Installing rclone $VER for $ARCH"

  mkdir -p $SRC
  curl -sL https://github.com/rclone/rclone/releases/download/v${VER}/rclone-v${VER}-${ARCH}-amd64.zip \
    --output rclone.zip
  unzip -j -q rclone.zip -d $SRC

  mv -f $SRC/rclone $PREFIX/bin/
  mv -f $SRC/*.1 $PREFIX/share/man/man1/

  rm -rf $SRC

  rclone completion bash $BASH_COMPLETION_USER_DIR/rclone.bash
)

#: rip
(
  set -euo pipefail
  ARCH=$(uname -m)

  curl -sL https://github.com/MilesCranmer/rip2/releases/latest/download/rip-Linux-${ARCH}-musl.tar.gz |
    tar -C $PREFIX/bin -xvz

  rip completions bash >$BASH_COMPLETION_USER_DIR/rip.bash
)

#: ripgrep
(
  set -euo pipefail
  VER=14.1.1
  ARCH=$(uname -m)
  SRC="${TMPDIR}/${USER}/ripgrep"

  mkdir -p $SRC
  curl -sL https://github.com/BurntSushi/ripgrep/releases/download/${VER}/ripgrep-${VER}-${ARCH}-unknown-linux-musl.tar.gz |
    tar -C $SRC --strip-components=1 -xvz

  mv -f $SRC/rg $PREFIX/bin/
  mv -f $SRC/complete/rg.bash $BASH_COMPLETION_USER_DIR/
  mv -f $SRC/doc/rg.1 $PREFIX/share/man/man1/

  rm -rf $SRC
)

#: spack
(
  # set -euo pipefail
  # VER=0.18

  # git clone -c feature.manyFiles=true --depth=2 --branch=releases/latest \
  #   https://github.com/spack/spack.git $SPACK_ROOT
)

#: starship
(
  curl -sS https://starship.rs/install.sh | sh -s -- --bin-dir $PREFIX/bin

  starship completions bash >$BASH_COMPLETION_USER_DIR/starship.bash
)

#: stow
(
  set -euo pipefail
  SRC="${TMPDIR}/${USER}/gstow"

  # cpan Test::Output

  mkdir -p $SRC
  curl -sL http://ftp.gnu.org/gnu/stow/stow-latest.tar.gz |
    tar -C $SRC/ --strip-components=1 -xvz

  cd $SRC
  $SRC/./configure --prefix=$PREFIX
  make install

  rm -rf $SRC
)

#: vscode
(
  set -euo pipefail
  DST="${PREFIX}/opt/vscode"

  mkdir -p "${DST}"
  curl -sL 'https://code.visualstudio.com/sha/download?build=stable&os=linux-x64' |
    tar -C "${DST}" --strip-components 1 -xvz

  ln -sf "${DST}/code" "${PREFIX}/bin/"
)

#: yq
(
  set -euo pipefail

  curl -L https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 \
    --output $PREFIX/bin/yq
  chmod +x $PREFIX/bin/yq

  yq completion bash >$BASH_COMPLETION_USER_DIR/yq.bash
  curl -sL https://github.com/mikefarah/yq/releases/latest/download/yq_man_page_only.tar.gz |
    tar -C $PREFIX/share/man/man1 -xvz yq.1
)

#: zoxide
(
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
)
