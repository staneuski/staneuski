#: Environment {{{
$env:DISPLAY = 'localhost:0'
$env:EDITOR = 'nvim -u "${env:USERPROFILE}\.config\.vim\init.lua"'
$env:PAGER = 'less'
#: }}}

#: Aliases {{{
#: eza
Remove-Item Alias:ls -Force -ErrorAction SilentlyContinue
Set-Alias -Name ls -Value "eza"
Function la { eza --color=always --group-directories-first -la $args }
Function ldot { eza --color=always --group-directories-first -ld .* $args }
Function lD { eza --color=always --group-directories-first -lD $args }
Function lDD { eza --color=always --group-directories-first -lDa $args }
Function ll { eza --color=always --group-directories-first -l $args }
Function lsd { eza --color=always --group-directories-first -d $args }
Function lsdl { eza --color=always --group-directories-first -dl $args }
Function lS { eza --color=always --group-directories-first -l -ssize $args }
Function lT { eza --color=always --group-directories-first -l -snewest $args }

#: git
Import-Module git-aliases -DisableNameChecking
Set-Alias -Name lg -Value "lazygit"

#: vi
Function vi { Invoke-Expression ${env:EDITOR} }

#: zoxide
Function dq { zoxide query --list $args }
#: }}}

#: Integrations {{{
if ([version]$PSVersionTable.PSVersion -gt [version](7.4)) {
  #: atuinsh/atuinsh
  atuin init powershell | Out-String | Invoke-Expression

  #: starship/starship
  starship init powershell | Out-String | Invoke-Expression
}

#: ajeetdsouza/zoxide
zoxide init --cmd=cd powershell | Out-String | Invoke-Expression
#: }}}
