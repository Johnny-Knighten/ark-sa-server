Set-StrictMode -Version Latest

if ($null -ne $env:DEBUG -and $env:DEBUG.ToLower() -ne "false" -and $env:DEBUG -ne "0") {
  Set-PSDebug -Trace 1
}

echo "Starting docker-entrypoint.ps1"