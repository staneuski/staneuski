# Launcher for the Scheduled Task: spawns Watch-Theme.ps1 as a fully detached,
# console-less process and exits immediately.
#
# This avoids Windows 11's "Default Terminal" delegation: normal console
# processes (even hidden ones) get attached to Windows Terminal's Job Object,
# so closing the last Terminal window/tab kills them. Testing showed that
# .NET's Process class with CreateNoWindow=$true (even combined with
# redirected stdio) still causes pwsh.exe to spin up its own conhost.exe,
# because it's a console-subsystem executable and Windows attaches *some*
# console unless launched in a way that fully detaches it. Win32_Process.Create
# (via WMI) spawns the process through the WMI provider service instead of
# inheriting anything from this launcher, so the child never ends up attached
# to Windows Terminal's console/Job Object at all.

$pwsh = (Get-Command pwsh -ErrorAction SilentlyContinue).Source
if (-not $pwsh) { $pwsh = (Get-Command powershell).Source }
$scriptPath = "${env:USERPROFILE}\.config\powershell\Watch-Theme.ps1"
# Note: deliberately NOT passing -WindowStyle Hidden here — that flag makes
# pwsh allocate its own console (just to immediately hide it), which defeats
# the point of a console-less launch.
$commandLine = "`"$pwsh`" -NoLogo -NoProfile -File `"$scriptPath`""

$result = Invoke-CimMethod -ClassName Win32_Process -MethodName Create -Arguments @{ CommandLine = $commandLine }
if ($result.ReturnValue -ne 0) {
    Write-Error "Win32_Process.Create failed with code $($result.ReturnValue)"
}
