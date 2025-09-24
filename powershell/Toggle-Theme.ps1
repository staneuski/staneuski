$settingsFile = "${env:LOCALAPPDATA}\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if (-Not (Test-Path $settingsFile)) {
  Write-Error "Settings file not found at $settingsFile"
  exit 1
}
try {
  $settings = Get-Content $settingsFile -Raw | ConvertFrom-Json
} catch {
  Write-Error "Failed to read or parse $settingsFile"
  exit 1
}

$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
if ($settings.profiles.defaults.colorScheme -eq "Tokyo Night Moon") {
  $settings.profiles.defaults.colorScheme = "Tokyo Night Day"
  (Get-Content "${env:APPDATA}\helix\config.toml").Replace('theme = "tokyonight_moon"', 'theme = "tokyonight_day"') | Set-Content "${env:APPDATA}\helix\config.toml"
  [System.IO.File]::WriteAllLines("${env:USERPROFILE}\.config\.vim\colors\tokyonight.vim", "runtime colors/tokyonight-day.vim", $Utf8NoBomEncoding)
} else {
  $settings.profiles.defaults.colorScheme = "Tokyo Night Moon"
  (Get-Content "${env:APPDATA}\helix\config.toml").Replace('theme = "tokyonight_day"', 'theme = "tokyonight_moon"') | Set-Content "${env:APPDATA}\helix\config.toml"
  [System.IO.File]::WriteAllLines("${env:USERPROFILE}\.config\.vim\colors\tokyonight.vim", "runtime colors/tokyonight-moon.vim", $Utf8NoBomEncoding)
}

try {
  $settings | ConvertTo-Json -Depth 10 -Compress | Set-Content $settingsFile
} catch {
  Write-Error "Failed to save the updated settings: $_"
  exit 1
}
