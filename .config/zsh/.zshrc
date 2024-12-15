# vim:fileencoding=utf-8:foldmethod=marker
export PATH="${HOME}/.local/bin:${PATH}"

# zinit wait levels:
# 0 prompt, cd, ls
# 1 cli
# 2 tui
# 3 completions, docs

#: Environment {{{
#: Plugin manager (zinit)
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [ ! -d "${ZINIT_HOME}" ]; then
  mkdir -p "$(dirname ${ZINIT_HOME})"
  git clone https://github.com/zdharma-continuum/zinit.git "${ZINIT_HOME}"
fi
source "${ZINIT_HOME}/zinit.zsh"
export MANPATH="$ZINIT[MAN_DIR]:$MANPATH"
zinit lucid id-as for \
  zdharma-continuum/zinit-annex-bin-gem-node

#: Terminal tab
[[ $(uname) == "Linux" ]] &&
  export PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME}:${PWD}\007"'
#: }}}

#: Plugins {{{
zinit wait"1" lucid light-mode for \
  zsh-users/zsh-autosuggestions \
  zsh-users/zsh-completions \
  zdharma-continuum/fast-syntax-highlighting \
  MichaelAquilina/zsh-you-should-use
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

#: Aliases {{{
zinit wait"1" lucid light-mode for \
  OMZP::common-aliases \
  OMZP::command-not-found \
  OMZP::git \
  OMZP::kitty

#: https://www.atlassian.com/git/tutorials/dotfiles
alias stow-git="/usr/bin/git --git-dir=${HOME}/.local/share/dotfiles --work-tree=${HOME}"

#: slurm
(( $+commands[squeue] )) &&
  alias sq='squeue --format="%.8i %.9P %.42j %.8T %.6M %.4D %R" --me'
#: }}}

# Keybindings {{{
bindkey -e
bindkey '^[[3~' delete-char # https://superuser.com/a/1078653
bindkey '^[w' kill-region

#: Switch back Ctrl-Z
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z
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

#: Completions
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

#: Load completions
autoload -Uz compinit && compinit
zinit cdreplay -q

#: Prevent complete path deletions
autoload -U select-word-style
select-word-style bash

#: Recipes {{{
#: [0, 1)
#: zoxide ( https://github.com/ajeetdsouza/zoxide/issues/175#issuecomment-841470951 )
zinit lucid as"none" from"gh-r" for \
    if"[[ $(uname) == "Linux" ]]" \
    sbin"eza" id-as \
  eza-community/eza \
    from"gh-r" \
    atclone"
      ./starship init zsh > init.zsh
      ./starship completions zsh > _starship
    " atpull"%atclone" \
    src"init.zsh" sbin"starship" id-as \
  starship/starship \
    from"gh-r" \
    atclone"
      ./zoxide init --cmd=cd zsh > init.zsh
      cp -rfv man/man1/zoxide{,-add,-import,-init,-query,-remove}.1 $ZINIT[MAN_DIR]/man1/
    " atpull"%atclone" \
    cp"completions/_zoxide -> _zoxide" \
    atload"alias zql='zoxide query --list'" \
    src"init.zsh" nocompile'!' sbin"zoxide" id-as \
  ajeetdsouza/zoxide

#: [1, 2)
#: treeify ( https://superuser.com/a/1086525 )
zinit wait"1" lucid as"none" light-mode for \
    configure make"PREFIX=$ZPFX" \
    mv"entr.1 -> $ZINIT[MAN_DIR]/man1/" \
    sbin"entr" id-as \
  eradman/entr \
    from"gh-r" sbin"lf" id-as \
  gokcehan/lf \
    if"[[ -n $+commands[tree] ]]" \
    as"null" sbin"treeify" id-as"treeify" \
  https://git.nullroute.lt/hacks/treeify.git/plain/treeify \
    from"gh-r" extract'!' \
    mv"doc/rg.1 -> $ZINIT[MAN_DIR]/man1/" \
    sbin"rg" id-as \
  BurntSushi/ripgrep \
    extract'!' \
    configure make"install PREFIX=$ZPFX" \
    id-as"gstow" \
  http://ftp.gnu.org/gnu/stow/stow-latest.tar.gz
zinit wait"1a" lucid as"none" for \
    from"gh-r" \
    atclone"./fzf --zsh > init.zsh" atpull"%atclone" \
    src"init.zsh" sbin"fzf" id-as \
  junegunn/fzf # use `fzf --man` instead of `man fzf`
zinit wait"1b" lucid as"none" for \
    from"gh-r" bpick"atuin*$(uname -m)*${$(uname):l}*.tar.gz" extract'!' \
    atclone"./atuin init zsh > init.zsh" atpull"%atclone" \
    src"init.zsh" nocompile'!' sbin"atuin" id-as \
  atuinsh/atuin

#: [2, 3)
zinit wait"2" lucid as"none" light-mode for \
    from"gh-r" extract'!' \
    mv"bat.1 -> $ZINIT[MAN_DIR]/man1/" cp"autocomplete/bat.zsh -> _bat" \
    sbin"bat" id-as \
  @sharkdp/bat \
    from"gh-r" extract'!' \
    cp"contrib/completion/hx.zsh -> _hx" \
    sbin"hx" id-as \
  helix-editor/helix \
    from"gh-r" extract'!' \
    mv"share/man/man1/nvim.1 -> $ZINIT[MAN_DIR]/man1/" \
    sbin"nvim" id-as \
  neovim/neovim

#: [3, 4)
zinit wait"3" lucid light-mode for \
    has"eza" atinit"zstyle ':omz:plugins:eza' 'dirs-first' yes" \
  OMZP::eza \
    if"[[ $(uname) == "Linux" ]]" has"eza" from"gh-r" bpick"completions*" \
    as"completion" extract'!!' \
    id-as"eza/completions" \
  eza-community/eza \
    if"[[ $(uname) == "Linux" ]]" has"eza" from"gh-r" bpick"man*" \
    as"completion" extract'!!' \
    atclone"
      cp -rfv *.1 $ZINIT[MAN_DIR]/man1/
      cp -rfv *.5 $ZINIT[MAN_DIR]/man5/
    " atpull"%atclone" \
    id-as"eza/man" \
  eza-community/eza \
    has"fzf" as"completion" mv"completion.zsh -> _zsh" nocompile'!' \
  https://github.com/junegunn/fzf/raw/master/shell/completion.zsh \
    has"fzf" \
  https://github.com/junegunn/fzf/raw/master/shell/key-bindings.zsh \
    has"lf" as"completion" id-as"_lf" \
  https://github.com/gokcehan/lf/blob/master/etc/lf.zsh \
    has"lf" as"null" cp"man.lf -> $ZINIT[MAN_DIR]/man1/lf.1" \
    id-as"man.lf" \
  https://github.com/gokcehan/lf/blob/master/lf.1
#: }}}
#: }}}
