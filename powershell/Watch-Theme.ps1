# Watches the Windows theme registry value and applies the matching Tokyo Night
# color scheme to Windows Terminal, vim and helix whenever it changes
# (e.g. Settings > Personalization > Colors > Light/Dark).
# Intended to run hidden, started by a logon Scheduled Task (see Register-ThemeWatcher.ps1).
#
# Note: WMI's registry-change notification runs as SYSTEM and cannot resolve
# "HKEY_CURRENT_USER" to a specific user, so we must watch HKEY_USERS\<SID> instead.

# Guard against duplicate instances (e.g. re-logons/RDP reconnects re-firing the
# AtLogOn trigger): only one watcher should ever run per user at a time, since
# multiple instances race to write the same theme files.
$mutex = New-Object System.Threading.Mutex($false, "Global\ToggleThemeWatcherMutex")
if (-not $mutex.WaitOne(0)) {
  Write-Host "Another Watch-Theme.ps1 instance is already running; exiting."
  exit
}

# Applies the Tokyo Night Day/Moon color scheme everywhere based on the current
# SystemUsesLightTheme registry value. Declared as a global function so it's
# reachable from the Register-ObjectEvent -Action scriptblock below, which runs
# in its own session state.
function global:Set-TokyoNightTheme {
  $registryKey = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
  $isDarkMode = (Get-ItemProperty -Path $registryKey).SystemUsesLightTheme
  $colorScheme = if ($isDarkMode) { "Tokyo Night Day" } else { "Tokyo Night Moon" }
  $vimScheme = if ($isDarkMode) { "day" } else { "moon" }
  $helixScheme = if ($isDarkMode) { "tokyonight_day" } else { "tokyonight_moon" }

  #: Windows Terminal
  $settingsFile = "${env:LOCALAPPDATA}\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
  try {
    $settings = Get-Content $settingsFile -Raw | ConvertFrom-Json
    $settings.profiles.defaults.colorScheme = $colorScheme
    $settings | ConvertTo-Json -Depth 10 -Compress | Set-Content $settingsFile
  } catch {
    Write-Error "Failed to update Windows Terminal colorScheme in ${settingsFile}: $_"
  }

  #: vim
  try {
    $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
    [System.IO.File]::WriteAllLines("${env:USERPROFILE}\.config\.vim\colors\tokyonight.vim", "runtime colors/tokyonight-$vimScheme.vim", $Utf8NoBomEncoding)
  } catch {
    Write-Error "Failed to update vim colorscheme: $_"
  }

  #: helix
  try {
    $helixConfig = "${env:APPDATA}\helix\config.toml"
    (Get-Content $helixConfig -Raw) -replace 'theme = "tokyonight_(day|moon)"', "theme = `"$helixScheme`"" |
      Set-Content $helixConfig
  } catch {
    Write-Error "Failed to update helix theme: $_"
  }
}

Add-Type -AssemblyName System.Management

$sid = ([System.Security.Principal.WindowsIdentity]::GetCurrent()).User.Value
$query = "SELECT * FROM RegistryValueChangeEvent WHERE Hive='HKEY_USERS' " +
  "AND KeyPath='$sid\\Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize' " +
  "AND ValueName='SystemUsesLightTheme'"

$scope = New-Object System.Management.ManagementScope("root\default")
$watcher = New-Object System.Management.ManagementEventWatcher($scope, (New-Object System.Management.WqlEventQuery($query)))
$watcher.Start()

Register-ObjectEvent -InputObject $watcher -EventName EventArrived -SourceIdentifier ThemeChanged -Action {
  Set-TokyoNightTheme
} | Out-Null

# Block forever, processing the event queue as changes come in.
try {
  while ($true) {
    Wait-Event -SourceIdentifier ThemeChanged | Remove-Event
  }
} finally {
  Unregister-Event -SourceIdentifier ThemeChanged -ErrorAction SilentlyContinue
  $watcher.Stop()
  $mutex.ReleaseMutex()
}
