# vim:fileencoding=utf-8:foldmethod=marker:ts=2:sw=2:sts=2:expandtab

#: Source global definitions {{{
[ -f "${HOME}/.zshenv" ] && (( $+commands[opt-load] )) ||
  source "${HOME}/.zshenv"
#: }}}

#: Environment {{{
[ ! -z ${HOMEBREW_PREFIX+x} ] && [ -z ${HOMEBREW_CELLAR+x} ] && [ -f "${HOMEBREW_PREFIX/bin/brew}" ] &&
  eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"

[[ "${PATH}" == *nix* ]] &&
  export PATH=$(echo $PATH | sed -E 's|/usr/local/bin:/usr/local/sbin:||; s|/usr/bin:|/usr/local/bin:/usr/local/sbin:/usr/bin:|')
opt-load "${HOME}/.local"

#: Plugin manager (zinit)
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [ ! -d "${ZINIT_HOME}" ]; then
  mkdir -p "$(dirname ${ZINIT_HOME})"
  git clone https://github.com/zdharma-continuum/zinit.git "${ZINIT_HOME}"
fi
source "${ZINIT_HOME}/zinit.zsh"
export MANPATH="$ZINIT[MAN_DIR]:$MANPATH"

zinit lucid id-as for \
  zdharma-continuum/zinit-annex-bin-gem-node \
  zdharma-continuum/zinit-annex-binary-symlink \
  zdharma-continuum/zinit-annex-linkman
#: }}}

#: Functions {{{
#: https://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/ (VII)
function fancy-ctrl-z() {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
#: }}}

#: Intergrations {{{
#: History settings
setopt appendhistory
setopt sharehistory # share command history data
setopt hist_ignore_space # ignore commands that start with space
setopt hist_ignore_all_dups # ignore duplicated commands history list
setopt hist_ignore_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

#: Prevent complete path deletions
autoload -U select-word-style
select-word-style bash
#: }}}

#: prompt, cd, ls {{{
#: Terminal tab
[[ $(uname) == 'Linux' ]] &&
  export PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME}:${PWD}\007"'

zinit lucid as"none" from"gh-r" id-as for \
    atclone"
      ./starship init zsh >init.zsh
      ./starship completions zsh >_starship
    " atpull"%atclone" \
    src"init.zsh" \
    lbin'!starship' \
  starship/starship
# https://github.com/ajeetdsouza/zoxide/issues/175#issuecomment-841470951
zinit wait"0" lucid as"none" from"gh-r" id-as for \
    if"[[ $(uname) == 'Linux' ]]" \
    lbin'!eza' \
  eza-community/eza \
    atclone"
      ./zoxide init --cmd=cd zsh >init.zsh
      cp -rfv man/man1/zoxide{,-add,-import,-init,-query,-remove}.1 $ZINIT[MAN_DIR]/man1/
    " atpull"%atclone" \
    cp"completions/_zoxide -> _zoxide" \
    src"init.zsh" nocompile'!' \
    atload'dq () { command zoxide query --list "$@" | head -1 }' \
    lbin'!zoxide' \
  ajeetdsouza/zoxide
#: }}}

#: CLIs, plugins {{{
zinit wait"1" lucid as"none" for \
    configure make"PREFIX=${ZPFX}" \
    lbin'!entr' id-as \
  eradman/entr \
    from"gh-r" extract'!' \
    lbin'!fd' lman'fd.1' id-as \
  @sharkdp/fd \
    from"gh-r" \
    atclone"./fzf --zsh >init.zsh" atpull"%atclone" \
    atload"
      export FZF_DEFAULT_OPTS_FILE=~/.config/fzf/fzfrc
      bindkey '^[r' fzf-history-widget
      bindkey '^Xr' fzf-history-widget
    " src"init.zsh" id-as \
    lbin'!fzf' \
  junegunn/fzf \
    if'! (( $+commands[pigz] ))' \
    make \
    lbin'!pigz' lman"pigz.1" id-as \
  madler/pigz \
    from"gh-r" extract'!' \
    atclone"./rclone completion zsh _rclone" atpull"%atclone" \
    lbin'!rclone' lman"rclone.1" id-as \
  rclone/rclone \
    from"gh-r" extract'!' \
    atclone"./rip completions zsh >_rip" atpull"%atclone" \
    lbin'!rip' id-as \
  MilesCranmer/rip2 \
    from"gh-r" extract'!' \
    lbin'!rg' lman"doc/rg.1" id-as \
  BurntSushi/ripgrep \
    extract'!' \
    configure make"install PREFIX=${ZPFX}" \
    id-as"gstow" \
  http://ftp.gnu.org/gnu/stow/stow-latest.tar.gz \
    from"gh-r" extract'!' \
    atclone"./yq completion zsh >_yq" atpull"%atclone" \
    mv'yq* -> yq' \
    lbin'!yq' id-as \
  mikefarah/yq

# Load atuin after fzf to overwrite key bindings
zinit wait"1b" lucid as"none" for \
    from"gh-r" bpick"atuin*$(uname -m)*${$(uname):l}*.tar.gz" extract'!' \
    atclone"./atuin init zsh >init.zsh" atpull"%atclone" \
    src"init.zsh" nocompile'!' \
    lbin'!atuin' id-as \
  atuinsh/atuin
zinit wait"1" lucid light-mode for \
  zsh-users/zsh-autosuggestions \
  zsh-users/zsh-completions \
  zdharma-continuum/fast-syntax-highlighting \
  MichaelAquilina/zsh-you-should-use
#: }}}

#: TUIs, package managers {{{
zinit wait"2" lucid as"none" from"gh-r" id-as for \
    extract'!' cp"autocomplete/bat.zsh -> _bat" \
    lbin'!bat' lman"bat.1" \
  @sharkdp/bat \
    extract'!' \
    atload"
      zle -N lf-zoxide-widget
      bindkey '^O' lf-zoxide-widget
    " lbin"!lf" \
  gokcehan/lf \
    extract'!' \
    lbin'!lazygit' \
    atload"alias lg='lazygit'" \
  jesseduffield/lazygit \
    atclone"./navi widget zsh >init.zsh" atpull"%atclone" \
    src"init.zsh" nocompile'!' \
    lbin'!navi' \
  denisidoro/navi \
    if"[[ $(uname) == 'Darwin' ]]" \
    extract'!' \
    lbin'!nvim' lman"share/man/man1/nvim.1" \
  neovim/neovim \
    if"[[ $(uname) == 'Linux' ]]" bpick"*.tar.gz" \
    extract'!' \
    lbin'!nvim' lman"share/man/man1/nvim.1" \
    id-as"neovim" \
  neovim/neovim-releases \
    if'! (( $+commands[node] ))' from"gh" \
    atinit'export NVM_DIR=$ZINIT[PLUGINS_DIR]/nvm' \
    pick'nvm.sh' atload'source bash_completion' nocompile \
  nvm-sh/nvm \
    if'! (( $+commands[uv] ))' \
    extract'!' \
    atclone"./uv generate-shell-completion zsh >_uv" atpull"%atclone" \
    lbin'!uv*' \
  @astral-sh/uv
#: }}}

#: aliases, completions, docs, key-bindings {{{
# slurm
(( $+commands[squeue] )) &&
  alias queue='squeue --format="%i;%j;%T;%M;%P;%.3D;%R" --me | column -s=";" -t'
(( $+commands[squeue] )) &&
  alias qyaml='squeue --format="%i;%j;%T;%M;%S;%P;%D;%R" --me | yq -p=csv --csv-separator=";" -o=yaml'

#: Completions
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# Load completions
autoload -Uz compinit && compinit
zinit cdreplay -q

#: Key-bindings
bindkey -e
bindkey '^[[3~' delete-char # https://superuser.com/a/1078653
bindkey '^[w' kill-region
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

zinit wait"3" lucid for \
  OMZP::common-aliases \
  OMZP::command-not-found \
  OMZP::git \
  OMZP::kitty
zinit wait"3a" lucid for \
    if"[[ $(uname) == 'Darwin' ]]" atload"
      alias cattysh='caffeinate -ims kitty +kitten ssh'
      alias tar='COPYFILE_DISABLE=1 tar'
    " \
  @zdharma-continuum/null \
    has"eza" atinit"zstyle ':omz:plugins:eza' 'dirs-first' yes" \
  OMZP::eza \
    if"[[ $(uname) == 'Linux' ]]" has"eza" from"gh-r" bpick"completions*" \
    as"completion" extract'!!' \
    id-as"eza/completions" \
  eza-community/eza \
    if"[[ $(uname) == 'Linux' ]]" has"eza" from"gh-r" bpick"man*" \
    as"null" extract'!!' \
    lman"eza*" id-as"eza/man" \
  eza-community/eza \
    has"lf" as"completion" id-as"_lf" \
  https://github.com/gokcehan/lf/blob/master/etc/lf.zsh \
    has"lf" as"null" lman"lf.1" \
  https://github.com/gokcehan/lf/blob/master/lf.1 \
    has"nvim" atload"
      export EDITOR='nvim -u \${HOME}/.vim/init.lua'
      alias vi=\"\${EDITOR}\"
    " \
  @zdharma-continuum/null \
    has"yq" from"gh-r" bpick"*man_page_only*" \
    as"null" extract'!' \
    lman"yq.1" id-as"yq/man" \
  mikefarah/yq
#: }}}
