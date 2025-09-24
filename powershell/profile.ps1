#: Environment {{{
$env:DISPLAY = "localhost:0"
$env:EDITOR = "nvim"
$env:PAGER = "less"
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

#: zoxide
Function dq { zoxide query --list $args }
#: }}}

#: Integrations {{{
#: starship/starship
Invoke-Expression (& starship init powershell)

#: ajeetdsouza/zoxide
Invoke-Expression (& { (zoxide init --cmd=cd powershell | Out-String) })
#: }}}
