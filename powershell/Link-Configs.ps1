#$ Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
#$ & "${env:USERPROFILE}\.config\powershell\Link-Configs.ps1"

$configDir = "${env:USERPROFILE}\.config"

#: bat
New-Item -Force -ItemType SymbolicLink -Target $configDir\bat\config -Path (bat --config-file)
New-Item -Force -ItemType SymbolicLink -Target $configDir\bat\themes `
  -Path ((Get-Item (bat --config-file)).DirectoryName+"\themes")

#: nvim
New-Item -Force -ItemType SymbolicLink -Target $configDir\nvim -Path $env:LOCALAPPDATA\nvim

#: Microsoft.WindowsTerminal
$localStateDir = "${env:LOCALAPPDATA}\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
Remove-Item -Recurse -Force -Confirm:$false $localStateDir
New-Item -Force -ItemType SymbolicLink -Target $configDir\Microsoft.WindowsTerminal -Path $localStateDir

#: ParaView
New-Item -Force -ItemType SymbolicLink -Target $configDir\ParaView -Path "${env:APPDATA}\ParaView"
New-Item -Force -ItemType SymbolicLink -Target "${env:APPDATA}\ParaView\ParaView.ini" `
  -Path "${env:APPDATA}\ParaView\ParaView6.1.1.ini"

#: PowerShell
$pwshProfile = if (Get-Command pwsh -ErrorAction SilentlyContinue) {
  (& pwsh -NoLogo -NoProfile -Command '$PROFILE.CurrentUserCurrentHost').Trim()
}
if ($pwshProfile) {
  New-Item -Force -ItemType SymbolicLink -Target $configDir\powershell\profile.ps1 -Path $pwshProfile
  Remove-Item -Force -ErrorAction SilentlyContinue `
    (Join-Path (Split-Path $pwshProfile) 'profile.ps1')
}

$powershellProfile = if (Get-Command powershell -ErrorAction SilentlyContinue) {
  (& powershell -NoLogo -NoProfile -Command '$PROFILE.CurrentUserCurrentHost').Trim()
}
if ($powershellProfile) {
  New-Item -Force -ItemType SymbolicLink -Target $configDir\powershell\profile.ps1 -Path $powershellProfile
}

#: syncthing
New-Item -Force -ItemType SymbolicLink -Target "${env:USERPROFILE}\Documents\.stignore_default" `
  -Path "${env:USERPROFILE}\Developer\.stignore_default"
New-Item -Force -ItemType SymbolicLink -Target "${env:USERPROFILE}\Documents\.stignore_default" `
  -Path "${env:USERPROFILE}\Files\.stignore_default"

#: vcxsrv
#TODO: Generate Start Up .lnk-file
