$siteToken=
$installerURL=
############### Do Not Edit Below This Line ###############


# Use a common directory rather than the user's Desktop
$installerTempLocation = "C:\Temp\SentinelOneAgentInstaller.msi"

# Ensure the directory exists
if (-not (Test-Path -Path "C:\Temp")) {
    New-Item -ItemType Directory -Path "C:\Temp"
}

if (Get-Service "SentinelAgent" -ErrorAction SilentlyContinue) {
    Write-Host "SentinelOne Agent already installed, nothing to do."
    exit 0
}
Write-Host "SentinelOne Agent not installed."
Write-Host "Downloading SentinelOne Agent installer now."
try {
    Invoke-WebRequest -Uri $installerURL -OutFile $installerTempLocation
    Write-Host "Finished downloading SentinelOne Agent installer."
}
catch {
    Write-Error "Unable to download SentinelOne Agent installer. Error: $_"
    # Output the detailed error message
    $_.Exception | Format-List -Force
    exit 1
}

Write-Host "Installing Sentinel One Agent now, this may take a few minutes."
try {
    ."$installerTempLocation" --dont_fail_on_config_preserving_failures -t $siteToken
}
catch {
    Write-Error "Failed to run SentinelOne Agent installer."
    exit 1
}
Write-Host "SentinelOne Agent installation complete."


Write-Host "SentinelOne Agent is now installed and running."
exit 0 # Assuming the installation was successful
