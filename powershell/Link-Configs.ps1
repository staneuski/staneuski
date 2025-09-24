# Run with elevation:
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
  -Path "${env:APPDATA}\ParaView\ParaView6.0.0.ini"

#: PowerShell
New-Item -Force -ItemType SymbolicLink -Target $configDir\powershell\profile.ps1 -Path $profile

#: syncthing
New-Item -Force -ItemType SymbolicLink -Target "${env:USERPROFILE}\Documents\.stignore_default" `
  -Path "${env:USERPROFILE}\Developer\.stignore_default"
New-Item -Force -ItemType SymbolicLink -Target "${env:USERPROFILE}\Documents\.stignore_default" `
  -Path "${env:USERPROFILE}\Files\.stignore_default"
#TODO: Generate Start Up .lnk-file

#: vcxsrv
#TODO: Generate Start Up .lnk-file
