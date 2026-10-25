#: Functions {{{
#: Init cache helper
function Use-CachedInit {
  param(
    [Parameter(Mandatory)] [string]$Name,
    [Parameter(Mandatory)] [scriptblock]$Generate
  )

  $dir = Join-Path $env:LOCALAPPDATA "pwsh.d"
  $cache = Join-Path $dir "$Name.ps1"

  if (-not (Test-Path $dir)) {
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
  }

  if (-not (Test-Path $cache)) {
    & $Generate | Set-Content -Encoding utf8 $cache
  }

  . $cache
}
#: }}}

#: Environment {{{
$env:DISPLAY = 'localhost:0'
$env:EDITOR = 'nvim'
$env:PAGER = 'less'

$env:YAZI_FILE_ONE=(Join-Path (scoop prefix git) '.\usr\bin\file.exe')
#: }}}

#: Aliases {{{
#: eza
Remove-Item Alias:ls -Force -ErrorAction SilentlyContinue
Set-Alias -Name ls -Value eza

Function la { eza --color=always --group-directories-first -la @args }
Function ldot { eza --color=always --group-directories-first -ld .* @args }
Function lD { eza --color=always --group-directories-first -lD @args }
Function lDD { eza --color=always --group-directories-first -lDa @args }
Function ll { eza --color=always --group-directories-first -l @args }
Function lsd { eza --color=always --group-directories-first -d @args }
Function lsdl { eza --color=always --group-directories-first -dl @args }
Function lS { eza --color=always --group-directories-first -l -ssize @args }
Function lT { eza --color=always --group-directories-first -l -snewest @args }

#: git (lazy-loaded)
function Ensure-GitAliases {
  if (-not (Get-Module git-aliases)) {
    Import-Module git-aliases -DisableNameChecking
  }
}
Set-Alias -Name lg -Value lazygit

#: vi
function vi {
  & $env:EDITOR -u "${env:USERPROFILE}\.config\.vim\init.lua" @args
}

#: zoxide helpers
Function dq { zoxide query --list $args }
#: }}}

#: Integrations {{{
#: ajeetdsouza/zoxide
Use-CachedInit zoxide { zoxide init --cmd=cd powershell }

if ($PSVersionTable.PSVersion -ge [version]"7.4") {
  #: PSReadLine (must be loaded before atuin, which depends on it)
  Import-Module PSReadLine -ErrorAction SilentlyContinue

  #: atuinsh/atuin
  Use-CachedInit atuin { atuin init powershell }

  #: starship/starship
  Use-CachedInit starship { starship init powershell --print-full-init }
}
#: }}}
