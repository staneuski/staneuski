#!/usr/bin/env bash

export PREFIX=${PREFIX:-$HOME/.local}
export HOMEBREW_PREFIX=${HOMEBREW_PREFIX:-$PREFIX/opt/homebrew}
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
  SRC=/tmp/$USER/curl
  VER=8.3.0

  mkdir -p $SRC
  curl -sL https://curl.se/download/curl-${VER}.tar.gz \
    | tar -C $SRC/ --strip-components=1 -xvz

  cd $SRC
  ./configure --prefix=$HOME/.local --with-openssl
  make -j$(nproc)
  make install
  cd -

  rm -rf $SRC
)

#: bat
(
  set -euo pipefail
  SRC=/tmp/$USER/bat
  VER=0.25.0
  ARCH=$(uname -m)

  mkdir -p $SRC
  curl -sL https://github.com/sharkdp/bat/releases/download/v${VER}/bat-v${VER}-${ARCH}-unknown-linux-musl.tar.gz \
    | tar -C $SRC/ --strip-components=1 -xvz

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
  curl -L https://github.com/Homebrew/brew/tarball/master \
    | tar -C $HOMEBREW_PREFIX --strip-components 1 -xvz 

  eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
  brew update --force --quiet
  chmod -R go-w "$($HOMEBREW_PREFIX/bin/brew --prefix)/share/zsh"
)

#: entr
(
  set -euo pipefail
  SRC=/tmp/$USER/entr
  VER=5.7

  mkdir -p $SRC
  curl -sL https://github.com/eradman/entr/archive/refs/tags/${VER}.tar.gz \
    | tar -C $SRC/ --strip-components=1 -xvz

  cd $SRC
  $SRC/./configure
  PREFIX=$PREFIX make install
  cd -

  rm -rf $SRC
)

#: eza
(
  set -euo pipefail
  SRC=/tmp/$USER/eza
  VER=0.20.22
  ARCH=$(uname -m)

  mkdir -p $SRC
  curl -sL https://github.com/eza-community/eza/releases/download/v${VER}/eza_${ARCH}-unknown-linux-musl.tar.gz \
    | tar -C $PREFIX/bin -xvz
  for d in completions man; do
    mkdir -p $SRC/$d
    curl -sL https://github.com/eza-community/eza/releases/download/v${VER}/${d}-${VER}.tar.gz | \
      tar -C $SRC/$d --strip-components=3 -xvz
  done

  mv -f $SRC/completions/eza $BASH_COMPLETION_USER_DIR/eza.bash
  mv -f $SRC/man/*.1 $PREFIX/share/man/man1/
  mv -f $SRC/man/*.5 $PREFIX/share/man/man5/
  rm -rf $SRC
)

#: fzf
(
  VER=0.60.2

  curl -sL https://github.com/junegunn/fzf/releases/download/v${VER}/fzf-${VER}-linux_amd64.tar.gz \
    | tar -C $PREFIX/bin -xvz

  fzf --bash > $BASH_COMPLETION_USER_DIR/fzf.bash
)

#: git
(
  set -euo pipefail
  SRC=/tmp/$USER/git
  VER=2.42.0

  mkdir -p $SRC
  curl -L https://mirrors.edge.kernel.org/pub/software/scm/git/git-v${VER}.tar.xz \
    | tar -C $SRC/ --strip-components=1 -xvz

  # Use curl installed in $PREFIX
  export CFLAGS="-I$PREFIX/include"
  export LDFLAGS="-L$PREFIX/lib"
  export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig"

  cd $SRC
  ./configure --prefix=$PREFIX --with-curl=$PREFIX
  make prefix=$PREFIX install
  cd -

  rm -rf $SRC
)

#: git-lfs
(
  SRC=/tmp/$USER/git-lfs
  VER=3.6.1
  ARCH=$(uname -m)

  mkdir -p $SRC
  curl -sL https://github.com/git-lfs/git-lfs/releases/download/v${VER}/git-lfs-linux-amd64-v${VER}.tar.gz \
    | tar -C $SRC/ --strip-components=1 -xvz

  PREFIX=$PREFIX $SRC/install.sh

  mv -f $SRC/man/man1/* $PREFIX/share/man/man1/
  mv -f $SRC/man/man5/* $PREFIX/share/man/man5/
  mv -f $SRC/man/man7/* $PREFIX/share/man/man7/
  rm -rf $SRC
)

#: jq
(
  set -euo pipefail
  VER=1.7.1

  curl -L https://github.com/jqlang/jq/releases/download/jq-${VER}/jq-linux-amd64 \
    --output $PREFIX/bin/jq
  chmod +x $PREFIX/bin/jq

  curl -sL https://github.com/jqlang/jq/releases/download/jq-${VER}/jq-${VER}.tar.gz \
    | tar -C $PREFIX/share/man/man1 --strip-components=1 -xvz jq-${VER}/jq.1
)

#: lazygit
(
  VER=0.47.2
  ARCH=$(uname -m)

  curl -sL https://github.com/jesseduffield/lazygit/releases/download/v${VER}/lazygit_${VER}_Linux_${ARCH}.tar.gz \
    | tar -C $PREFIX/bin -xvz lazygit
)

#: lf
(
  curl -sL https://github.com/gokcehan/lf/releases/latest/download/lf-linux-amd64.tar.gz \
    | tar -C $PREFIX/bin -xvz
)

#: navi
(
  set -euo pipefail
  VER=2.24.0
  ARCH=$(uname -m)

  curl -sL https://github.com/denisidoro/navi/releases/download/v${VER}/navi-v${VER}-${ARCH}-unknown-linux-musl.tar.gz \
    | tar -C $PREFIX/bin -xvz
)

#: neovim
(
  curl -L https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.appimage \
    --output $PREFIX/bin/nvim
  chmod +x $PREFIX/bin/nvim
)

#: pipx
(
  set -euo pipefail

  mkdir -p $PIPX_HOME
  curl -L https://github.com/pypa/pipx/releases/latest/download/pipx.pyz \
    --output $PIPX_HOME/pipx.pyz

  printf '#!/usr/bin/env sh\n%s %s "$@"\n' "$(which python3)" "$PIPX_HOME/pipx.pyz" > $PREFIX/bin/pipx
  chmod +x $PREFIX/bin/pipx

  register-python-argcomplete pipx > $BASH_COMPLETION_USER_DIR/pipx.bash
)

#: pyenv
(
  curl -fsSL https://pyenv.run | bash

  ln -sfn {$PYENV_ROOT,$PREFIX}/bin/pyenv
  ln -sfn $PYENV_ROOT/completions/pyenv.bash $BASH_COMPLETION_USER_DIR/pyenv.bash
  ln -sfn {$PYENV_ROOT,$PREFIX/share}/man/man1/pyenv.1
)

#: rip
(
  set -euo pipefail
  ARCH=$(uname -m)

  curl -sL https://github.com/MilesCranmer/rip2/releases/latest/download/rip-Linux-${ARCH}-musl.tar.gz \
    | tar -C $PREFIX/bin -xvz

  rip completions bash > $BASH_COMPLETION_USER_DIR/rip.bash
)

#: ripgrep
(
  set -euo pipefail
  SRC=/tmp/$USER/ripgrep
  VER=14.1.1
  ARCH=$(uname -m)

  mkdir -p $SRC
  curl -sL https://github.com/BurntSushi/ripgrep/releases/download/${VER}/ripgrep-${VER}-${ARCH}-unknown-linux-musl.tar.gz \
    | tar -C $SRC --strip-components=1 -xvz

  mv -f $SRC/rg $PREFIX/bin/
  mv -f $SRC/complete/rg.bash $BASH_COMPLETION_USER_DIR/
  mv -f $SRC/doc/rg.1 $PREFIX/share/man/man1/
  rm -rf $SRC
)

#: spack
(
  # set -euo pipefail
  # VER=0.18

  # git clone -c feature.manyFiles=true --depth=2 --branch=releases/v${VER} \
  #   https://github.com/spack/spack.git $SPACK_ROOT
)

#: starship
(
  curl -sS https://starship.rs/install.sh | sh -s -- --bin-dir $PREFIX/bin

  starship completions bash > $BASH_COMPLETION_USER_DIR/starship.bash
)

#: stow
(
  set -euo pipefail
  SRC=/tmp/$USER/gstow

  # cpan Test::Output

  mkdir -p $SRC
  curl -sL http://ftp.gnu.org/gnu/stow/stow-latest.tar.gz \
    | tar -C $SRC/ --strip-components=1 -xvz

  cd $SRC
  $SRC/./configure --prefix=$PREFIX
  make install
  cd -

  rm -rf $SRC
)

#: yq
(
  set -euo pipefail

  curl -L https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 \
    --output $PREFIX/bin/yq
  chmod +x $PREFIX/bin/yq

  yq completion bash > $BASH_COMPLETION_USER_DIR/yq.bash
  curl -sL https://github.com/mikefarah/yq/releases/latest/download/yq_man_page_only.tar.gz \
    | tar -C $PREFIX/share/man/man1 -xvz yq.1
)

#: zoxide
(
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
)
