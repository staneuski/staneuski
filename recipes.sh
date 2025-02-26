#!/usr/bin/env bash

PREFIX=$HOME/.local

mkdir -p $PREFIX/{bin,opt,share/man/man{1,2,3,4,5,6,7,8,9}}
mkdir -p $BASH_COMPLETION_USER_DIR

#: atuin
(
  # curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
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

#: pipx
(
  set -euo pipefail

  curl -L https://github.com/pypa/pipx/releases/latest/download/pipx.pyz \
    --output $PREFIX/share/pipx.pyz

  printf '#!/usr/bin/env sh\n%s %s "$@"\n' "$(which python3)" "$PREFIX/share/pipx.pyz" > $PREFIX/bin/pipx
  chmod +x $PREFIX/bin/pipx

  register-python-argcomplete pipx > $BASH_COMPLETION_USER_DIR/pipx.bash
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
# git clone -c feature.manyFiles=true --depth=2 --branch=v0.23.0 https://github.com/spack/spack.git $PREFIX/opt/spack

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

  curl -sL https://github.com/mikefarah/yq/releases/latest/download/yq_man_page_only.tar.gz \
    | tar -C $PREFIX/share/man/man1 -xvz yq.1
)

#: zoxide
(
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
)
