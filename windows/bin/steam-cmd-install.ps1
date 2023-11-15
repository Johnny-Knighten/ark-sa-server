Set-StrictMode -Version Latest

$steamcmdPath = "C:\steamcmd\steamcmd.exe"

if ($null -ne $env:DEBUG -and $env:DEBUG.ToLower() -ne "false" -and $env:DEBUG -ne "0") {
    Set-PSDebug -Trace 1
}

if ($env:STEAMCMD_SKIP_VALIDATION -eq "True") {
    Write-Host "SteamCMD Will Not Validate Ark SA Server Files"
    $appUpdateLine = "+app_update $env:STEAMCMD_ARK_SA_APP_ID"
} else {
    Write-Host "SteamCMD Will Validate Ark SA Server Files"
    $appUpdateLine = "+app_update $env:STEAMCMD_ARK_SA_APP_ID validate"
}

if ($env:TEST_DRY_RUN -eq "True") {
    if ($env:ARK_PREVENT_AUTO_UPDATE -eq "True") {
        Write-Host "DRY RUN: Skipping Auto-Update of Ark SA Server"
        exit 0
    } else {
        Write-Host "DRY RUN: Running steamcmd with the following arguments:"
        Write-Host "$steamcmdPath +login anonymous +force_install_dir $($env:ARK_SERVER_DIR)\server $appUpdateLine +quit"
        exit 0
    }
}

# run steamcmd if ARK_PREVENT_AUTO_UPDATE is not "True" OR if install directory is empty
if ($env:ARK_PREVENT_AUTO_UPDATE -ne "True" -or -not (Test-Path -Path "$($env:ARK_SERVER_DIR)\server" -PathType Container)) {
    & $steamcmdPath +login anonymous +force_install_dir "$($env:ARK_SERVER_DIR)\server" $appUpdateLine +quit
} else {
    Write-Host "Skipping Auto-Update of Ark SA Server"
}
