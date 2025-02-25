# vim:fileencoding=utf-8:foldmethod=marker

#: Environment {{{
[[ "${PATH}" == *nix* ]] &&
  export PATH=$(echo $PATH | sed -E 's|/usr/local/bin:/usr/local/sbin:||; s|/usr/bin:|/usr/local/bin:/usr/local/sbin:/usr/bin:|')
export PATH="${HOME}/.local/bin:${PATH}"

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
      ./starship init zsh > init.zsh
      ./starship completions zsh > _starship
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
      ./zoxide init --cmd=cd zsh > init.zsh
      cp -rfv man/man1/zoxide{,-add,-import,-init,-query,-remove}.1 $ZINIT[MAN_DIR]/man1/
    " atpull"%atclone" \
    cp"completions/_zoxide -> _zoxide" \
    src"init.zsh" nocompile'!' \
    atload"alias zql='zoxide query --list'" \
    lbin'!zoxide' \
  ajeetdsouza/zoxide

#: CLIs, plugins {{{
# treeify ( https://superuser.com/a/1086525 )
zinit wait"1" lucid as"none" for \
    configure make"PREFIX=${ZPFX}" \
    lbin'!entr' lman"entr.1" id-as \
  eradman/entr \
    if"[[ -n $+commands[tree] ]]" \
    as"null" lbin'!treeify' id-as"treeify" \
  https://git.nullroute.lt/hacks/treeify.git/plain/treeify \
    from"gh-r" cp"completions/just.zsh -> _just" \
    lbin'!just' lman"just.1" id-as \
  casey/just \
    from"gh-r" atclone"./rip completions zsh > _rip" atpull"%atclone" \
    lbin'!rip' id-as"rm-improved" \
  MilesCranmer/rip2 \
    from"gh-r" extract'!' \
    lbin'!rg' lman"rg.1" id-as \
  BurntSushi/ripgrep \
    extract'!' \
    configure make"install PREFIX=${ZPFX}" \
    id-as"gstow" \
  http://ftp.gnu.org/gnu/stow/stow-latest.tar.gz
zinit wait"1" lucid light-mode for \
  zsh-users/zsh-autosuggestions \
  zsh-users/zsh-completions \
  zdharma-continuum/fast-syntax-highlighting \
  MichaelAquilina/zsh-you-should-use
# use `fzf --man` instead of `man fzf`
zinit wait"1a" lucid as"none" from"gh-r" id-as for \
    atclone"./fzf --zsh > init.zsh" atpull"%atclone" \
    src"init.zsh" \
    lbin'!fzf' \
  junegunn/fzf
zinit wait"1b" lucid as"none" from"gh-r" id-as for \
    bpick"atuin*$(uname -m)*${$(uname):l}*.tar.gz" extract'!' \
    atclone"./atuin init zsh > init.zsh" atpull"%atclone" \
    src"init.zsh" nocompile'!' \
    lbin'!atuin' \
  atuinsh/atuin
#: }}}

#: TUIs {{{
zinit wait"2" lucid as"none" from"gh-r" id-as for \
    extract'!' cp"autocomplete/bat.zsh -> _bat" \
    lbin'!bat' lman"bat.1" \
  @sharkdp/bat \
    extract'!' \
    lbin"!lf" \
  gokcehan/lf \
    extract'!' \
    lbin'!lazygit' \
    atload"
      alias lg='lazygit'
      alias stow-lg=\"lazygit --git-dir=${HOME}/.config/ --work-tree=${HOME}/.config/\"
    " \
  jesseduffield/lazygit \
    atclone"./navi widget zsh > init.zsh" atpull"%atclone" \
    src"init.zsh" nocompile'!' \
    lbin'!navi' \
  denisidoro/navi

# requires python's argcomplete
zinit wait"2" lucid as"completions" from"gh-r" id-as for \
    atclone"register-python-argcomplete pipx > _pipx" atpull"%atclone" \
    atload'pipx () { python3 "${ZINIT[PLUGINS_DIR]}/pipx/pipx.pyz" "$@" }' \
  pypa/pipx
#: }}}

#: aliases, completions, docs, key-bindings {{{
#: Aliases
# https://www.atlassian.com/git/tutorials/dotfiles
alias stow-git="git -C ${HOME}/.config/"
# slurm
(( $+commands[squeue] )) &&
  alias sq='squeue --format="%.10i %.9P %.40j %.8T %.6M %.4D %R" --me'

#: Completions
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
# Load completions
autoload -Uz compinit && compinit
zinit cdreplay -q

#: Key-bindings
bindkey -e
bindkey '^[[3~' delete-char # https://superuser.com/a/1078653
bindkey '^[w' kill-region
# Switch back Ctrl-Z
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

zinit wait"3" lucid for \
  OMZP::common-aliases \
  OMZP::command-not-found \
  OMZP::git \
  OMZP::kitty
zinit wait"3a" lucid for \
    if"[[ $(uname) == 'Darwin' ]]" has"bat" \
    atload"bat () {
      $(which bat) --theme=\$(defaults read -globalDomain AppleInterfaceStyle &> /dev/null && echo default || echo GitHub) \"\$@\"
    }" \
  @zdharma-continuum/null \
    if"[[ $(uname) == 'Darwin' ]]" \
    atload"
      alias cattysh='caffeinate -ims kitty +kitten ssh'
      alias rsync='rsync --exclude={\'.DS_Store\',\'._*\'}'
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
    has"fzf" as"completion" mv"completion.zsh -> _zsh" nocompile'!' \
    atload"export FZF_DEFAULT_OPTS=\"--ansi --preview-window 'right:60%' --preview 'bat --color=always --style=header,grid --line-range :300 {}'\"" \
  https://github.com/junegunn/fzf/raw/master/shell/completion.zsh \
    has"lf" as"completion" id-as"_lf" \
  https://github.com/gokcehan/lf/blob/master/etc/lf.zsh \
    has"lf" as"null" lman"lf.1" \
  https://github.com/gokcehan/lf/blob/master/lf.1
  #   has"fzf" \
  # https://github.com/junegunn/fzf/raw/master/shell/key-bindings.zsh \
#: }}}

. "$HOME/.atuin/bin/env"
