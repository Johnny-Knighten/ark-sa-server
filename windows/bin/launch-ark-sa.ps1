# Set strict error handling
$ErrorActionPreference = "Stop"

# Check DEBUG variable
if ($null -ne $env:DEBUG -and $env:DEBUG.ToLower() -ne "false" -and $env:DEBUG -ne "0") {
    Set-PSDebug -Trace 1
}

$cmdArgs = "$env:ARK_MAP"
$cmdArgs += "?listen"
$cmdArgs += "?SessionName=`"$env:ARK_SERVER_NAME`""
$cmdArgs += "?Port=$env:ARK_GAME_PORT"
$cmdArgs += "?QueryPort=$env:ARK_QUERY_PORT"
$cmdArgs += "?ServerPVE=$env:ARK_ENABLE_PVE"

if ($env:ARK_ENABLE_RCON -eq "True") {
    $cmdArgs += "?RCONEnabled=$env:ARK_ENABLE_RCON?RCONPort=$env:ARK_RCON_PORT"
} else {
    $cmdArgs += "?RCONEnabled=False"
}

if ($null -ne $env:ARK_MULTI_HOME) {
    $cmdArgs += "?MultiHome=$env:ARK_MULTI_HOME"
}

if ($null -ne $env:ARK_SERVER_PASSWORD) {
    $cmdArgs += "?ServerPassword=$env:ARK_SERVER_PASSWORD"
}

$cmdArgs += "?ServerAdminPassword=$env:ARK_SERVER_ADMIN_PASSWORD"

if ($env:ARK_NO_BATTLEYE -eq "True") {
    $battleEyeFlag = "-NoBattlEye"
} else {
    $battleEyeFlag = ""
}

if ($null -ne $env:ARK_EPIC_PUBLIC_IP) {
    $epicIpFlag = "--PublicIPforEpic $env:ARK_EPIC_PUBLIC_IP"
} else {
    $epicIpFlag = ""
}

$playerCountFlag = "-WinLiveMaxPlayers=$env:ARK_MAX_PLAYERS"

$env:ARK_MOD_LIST = $env:ARK_MOD_LIST -replace '\s', ''

if ($null -ne $env:ARK_MOD_LIST) {
    $modArgs = "-automanagedmods -mods=$env:ARK_MOD_LIST"
} else {
    $modArgs = ""
}

if ($env:TEST_DRY_RUN -eq "True") {
  Write-Host "DRY RUN: Running Ark Server with the following arguments:"
  Write-Host "$env:ARK_SERVER_DIR\server\ShooterGame\Binaries\Win64\ArkAscendedServer.exe $cmdArgs -log $battleEyeFlag $epicIpFlag $playerCountFlag $modArgs $env:ARK_EXTRA_LAUNCH_OPTIONS"
  exit 0
}

$arkExecutablePath = Join-Path $env:ARK_SERVER_DIR "server\ShooterGame\Binaries\Win64\ArkAscendedServer.exe"
$win64Path= Join-Path $env:ARK_SERVER_DIR "server\ShooterGame\Binaries\Win64"

Write-Host "Executable Path: $arkExecutablePath"
Write-Host "Arguments: $cmdArgs $battleEyeFlag $epicIpFlag $playerCountFlag $modArgs $env:ARK_EXTRA_LAUNCH_OPTIONS"

if (-not (Test-Path -Path $arkExecutablePath)) {
    Write-Error "ARK executable not found at $arkExecutablePath"
    exit 1
}

try {
    $ServerProcess = Start-Process -FilePath $arkExecutablePath `
                                    -WorkingDirectory $win64Path `
                                    -ArgumentList "$cmdArgs -log $battleEyeFlag $epicIpFlag $playerCountFlag $modArgs $env:ARK_EXTRA_LAUNCH_OPTIONS -stdout -FullStdOutLogOutput -unattended -RenderOffscreen" `
                                    -RedirectStandardError "error.log" `
                                    -PassThru `
                                    -NoNewWindow
} catch {
    Write-Host "Error Launching Ark SA Server"
}

$logFile = Join-Path $env:ARK_SERVER_DIR "server\ShooterGame\Saved\Logs\ShooterGame.log"
$timeout = 300

while ((-not (Test-Path -Path $logFile)) -and ($timeout -gt 0)) {
  Write-Host "Waiting for file $logFile to exist..."
  Start-Sleep -Seconds 1
  $timeout--
}

if (Test-Path -Path $logFile) {
  Get-Content -Path $logFile -Wait
} else {
  Write-Host "File $logFile did not appear within the timeout period"
  exit 1
}
