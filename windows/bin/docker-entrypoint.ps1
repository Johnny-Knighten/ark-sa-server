Set-StrictMode -Version Latest

if ($null -ne $env:DEBUG -and $env:DEBUG.ToLower() -ne "false" -and $env:DEBUG -ne "0") {
  Set-PSDebug -Trace 1
}

$requiredSubDirs = @("server")

foreach ($subDir in $requiredSubDirs) {
    $dirPath = Join-Path $env:ARK_SERVER_DIR $subDir
    if (-not (Test-Path $dirPath)) {
        try {
            New-Item -Path $dirPath -ItemType Directory -Force | Out-Null
        } catch {
            Write-Host "Failed to create directory: $dirPath"
        }
    }
}
