#!/usr/bin/env bash

export PREFIX=${PREFIX:-$HOME/.local}
export TMPDIR=${TMPDIR:-/tmp}

export HOMEBREW_PREFIX=${HOMEBREW_PREFIX:-$PREFIX/opt/homebrew}
export NIX_PREFIX=${NIX_PREFIX:-$PREFIX/nix}
export PIPX_HOME=${PIPX_HOME:-$PREFIX/opt/pipx}
export PYENV_ROOT=${PYENV_ROOT:-$PREFIX/opt/pyenv}

mkdir -p $PREFIX/{bin,opt,share/man/man{1,2,3,4,5,6,7,8,9}}
mkdir -p $BASH_COMPLETION_USER_DIR

#: atuin
(
  # curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
)

#: curl
(
  set -euo pipefail
  SRC="${TMPDIR}/${USER}/curl"
  VER=8.15.0

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
  SRC="${TMPDIR}/${USER}/bat"
  VER=0.25.0
  ARCH=$(uname -m)

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
  SRC="${TMPDIR}/${USER}/entr"
  VER=5.7

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
  SRC="${TMPDIR}/${USER}/eza"
  VER=0.22.1
  ARCH=$(uname -m)

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
  SRC="${TMPDIR}/${USER}/git"
  VER=2.50.1

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
  SRC="${TMPDIR}/${USER}/git-lfs"
  VER=3.7.0
  ARCH=$(uname -m)

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
  SRC="${PREFIX}/opt/ParaView-${VER%.*}"
  VER=6.0.0
  PY=3.12
  RENDERING="" # "" | "-egl" | "-osmesa"

  mkdir -p "${SRC}"
  curl -sL "https://www.paraview.org/files/v${VER%.*}/ParaView-${VER}${RENDERING}-MPI-Linux-Python${PY}-x86_64.tar.gz" |
    tar -C "${SRC}" --strip-components 1 -xvz

  command -v desktop-file-edit >/dev/null &&
    desktop-file-install --dir="${HOME}/.local/share/applications" \
      --set-name="ParaView v${VER%.*}" \
      --set-icon="${SRC}/share/icons/hicolor/96x96/apps/paraview.png" \
      --set-key=Exec --set-value="${SRC}/bin/paraview %f" \
      --set-key=TryExec --set-value="${SRC}/bin/paraview" \
      --set-key=StartupWMClass --set-value="${SRC}/bin/paraview" \
      "${SRC}/share/applications/org.paraview.ParaView.desktop"
)

#: pigz
(
  set -euo pipefail
  SRC="${TMPDIR}/${USER}/pigz"
  VER=2.8

  mkdir -p $SRC
  curl -sL https://github.com/madler/pigz/archive/refs/tags/v${VER}.tar.gz |
    tar -C $SRC/ --strip-components=1 -xvz

  cd $SRC
  make

  mv -f $SRC/{,un}pigz $PREFIX/bin/
  mv -f $SRC/*.1 $PREFIX/share/man/man1/

  rm -rf $SRC
)

#: pipx
(
  set -euo pipefail

  mkdir -p $PIPX_HOME
  curl -L https://github.com/pypa/pipx/releases/latest/download/pipx.pyz \
    --output $PIPX_HOME/pipx.pyz

  printf '#!/usr/bin/env sh\n%s %s "$@"\n' "$(which python3)" "$PIPX_HOME/pipx.pyz" >$PREFIX/bin/pipx
  chmod +x $PREFIX/bin/pipx

  register-python-argcomplete pipx >$BASH_COMPLETION_USER_DIR/pipx.bash
)

#: pyenv
(
  curl -fsSL https://pyenv.run | bash

  ln -sfn {$PYENV_ROOT,$PREFIX}/bin/pyenv
  ln -sfn $PYENV_ROOT/completions/pyenv.bash $BASH_COMPLETION_USER_DIR/pyenv.bash
  ln -sfn {$PYENV_ROOT,$PREFIX/share}/man/man1/pyenv.1
)

#: rclone
(
  set -euo pipefail
  SRC="${TMPDIR}/${USER}/rclone"
  VER=1.70.3
  ARCH=$(uname | tr '[:upper:]' '[:lower:]')
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
  SRC="${TMPDIR}/${USER}/ripgrep"
  VER=14.1.1
  ARCH=$(uname -m)

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
