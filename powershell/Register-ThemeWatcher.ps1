# Registers a Scheduled Task that runs Watch-Theme.ps1 hidden at logon,
# so the Tokyo Night theme is applied automatically whenever the Windows theme changes.
# Run this once (as the current user, no admin required):
#   & "${env:USERPROFILE}\.config\powershell\Register-ThemeWatcher.ps1"

$taskName = "Toggle-Theme-Watcher"
$launcherPath = "${env:USERPROFILE}\.config\powershell\Start-WatcherDetached.ps1"
$pwsh = (Get-Command pwsh -ErrorAction SilentlyContinue).Source
if (-not $pwsh) { $pwsh = (Get-Command powershell).Source }

# The task runs the launcher (not Watch-Theme.ps1 directly), which spawns the
# real watcher as a console-less detached process. See Start-WatcherDetached.ps1
# for why: without this, the watcher gets attached to Windows Terminal's Job
# Object and dies when the last Terminal window/tab closes.
$action = New-ScheduledTaskAction -Execute $pwsh `
  -Argument "-NoLogo -NoProfile -WindowStyle Hidden -File `"$launcherPath`""
$trigger = New-ScheduledTaskTrigger -AtLogOn -User "$env:USERDOMAIN\$env:USERNAME"
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
$principal = New-ScheduledTaskPrincipal -UserId "$env:USERDOMAIN\$env:USERNAME" -LogonType Interactive

Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger `
  -Settings $settings -Principal $principal -Force | Out-Null

# Start it immediately too, so it's active in the current session without logging off.
Start-ScheduledTask -TaskName $taskName

Write-Host "Registered and started scheduled task '$taskName'."
