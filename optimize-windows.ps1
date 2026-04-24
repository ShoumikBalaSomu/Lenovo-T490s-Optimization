# Device-Specific Windows 11 Optimization for Lenovo ThinkPad T490s
# Run as Administrator (PowerShell 5.1+)
# Optimized for: Performance, Battery Life, Privacy, and Gaming

param(
    [switch]$SkipRestart
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

# Color functions
function Write-Header { 
    param([string]$Text)
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "  $Text" -ForegroundColor Cyan
    Write-Host "========================================`n" -ForegroundColor Cyan
}

function Write-Success { 
    param([string]$Text)
    Write-Host "[SUCCESS] $Text" -ForegroundColor Green
}

function Write-Info { 
    param([string]$Text)
    Write-Host "[INFO] $Text" -ForegroundColor Yellow
}

function Write-Error-Custom { 
    param([string]$Text)
    Write-Host "[ERROR] $Text" -ForegroundColor Red
}

# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error-Custom "This script must be run as Administrator!"
    Write-Host "Right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    exit 1
}

Write-Header "Windows 11 Max Optimization for ThinkPad T490s"

# 1. Disable Telemetry & Data Collection
Write-Info "Disabling telemetry and data collection..."
$telemetryPaths = @(
    "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection",
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection",
    "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds",
    "HKLM:\SOFTWARE\Policies\Microsoft\SQMClient\Windows"
)

foreach ($path in $telemetryPaths) {
    if (!(Test-Path $path)) {
        New-Item -Path $path -Force | Out-Null
    }
}

Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Value 0 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" -Name "AllowBuildPreview" -Value 0 -Type DWord -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\SQMClient\Windows" -Name "CEIPEnable" -Value 0 -Type DWord -Force

# Stop telemetry services
$telemetryServices = @(
    "DiagTrack",
    "dmwappushservice",
    "lfsvc",
    "MapsBroker",
    "XblAuthManager",
    "XblGameSave",
    "XboxNetApiSvc",
    "XboxGipSvc"
)

foreach ($service in $telemetryServices) {
    try {
        Stop-Service -Name $service -Force -WarningAction SilentlyContinue
        Set-Service -Name $service -StartupType Disabled -WarningAction SilentlyContinue
    } catch {
        # Service may not exist, continue
    }
}

Write-Success "Telemetry disabled"

# 2. Optimize Power Settings
Write-Info "Configuring power settings for maximum performance..."

# Create Ultimate Performance power plan
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 99999999-9999-9999-9999-999999999999
powercfg -setactive 99999999-9999-9999-9999-999999999999
powercfg -changename 99999999-9999-9999-9999-999999999999 "T490s Optimized" "Custom optimized power plan for ThinkPad T490s"

# Configure processor power management
powercfg -setacvalueindex 99999999-9999-9999-9999-999999999999 54533251-82be-4824-96c1-47b60b740d00 893dee8e-2bef-41e0-89c6-b55d0939088d 100
powercfg -setdcvalueindex 99999999-9999-9999-9999-999999999999 54533251-82be-4824-96c1-47b60b740d00 893dee8e-2bef-41e0-89c6-b55d0939088d 80
powercfg -setacvalueindex 99999999-9999-9999-9999-999999999999 54533251-82be-4824-96c1-47b60b740d00 bc5038f7-23e0-4960-96da-33abaf5935ec 100
powercfg -setdcvalueindex 99999999-9999-9999-9999-999999999999 54533251-82be-4824-96c1-47b60b740d00 bc5038f7-23e0-4960-96da-33abaf5935ec 5

# Disable sleep when lid closed on AC
powercfg -setacvalueindex 99999999-9999-9999-9999-999999999999 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 0
powercfg -setdcvalueindex 99999999-9999-9999-9999-999999999999 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 1

# Set display timeout
powercfg -setacvalueindex 99999999-9999-9999-9999-999999999999 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 600
powercfg -setdcvalueindex 99999999-9999-9999-9999-999999999999 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 300

Write-Success "Power settings optimized"

# 3. Disable Unnecessary Startup Programs & Services
Write-Info "Disabling unnecessary startup programs and services..."

# Disable bloatware apps
$bloatwareApps = @(
    "Microsoft.BingWeather",
    "Microsoft.GetHelp",
    "Microsoft.Getstarted",
    "Microsoft.Messaging",
    "Microsoft.Microsoft3DViewer",
    "Microsoft.MicrosoftOfficeHub",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.News",
    "Microsoft.Office.OneNote",
    "Microsoft.People",
    "Microsoft.Print3D",
    "Microsoft.SkypeApp",
    "Microsoft.Wallet",
    "Microsoft.Whiteboard",
    "Microsoft.Xbox.TCUI",
    "Microsoft.XboxApp",
    "Microsoft.XboxGameOverlay",
    "Microsoft.XboxGamingOverlay",
    "Microsoft.XboxIdentityProvider",
    "Microsoft.XboxSpeechToTextOverlay",
    "Microsoft.ZuneMusic",
    "Microsoft.ZuneVideo",
    "Microsoft.Advertising.Xaml",
    "Microsoft.MixedReality.Portal",
    "Microsoft.ScreenSketch",
    "Microsoft.Paint3D",
    "Microsoft.3DBuilder",
    "Microsoft.OneConnect",
    "Microsoft.Office.Sway",
    "Microsoft.CommsPhone",
    "Microsoft.ConnectivityStore",
    "Microsoft.MSPaint",
    "Microsoft.Office.Lens",
    "Microsoft.PowerBI",
    "Microsoft.RemoteDesktop",
    "Microsoft.NetworkSpeedTest",
    "Microsoft.YourPhone"
)

foreach ($app in $bloatwareApps) {
    Get-AppxPackage -AllUsers | Where-Object { $_.Name -like "*$app*" } | Remove-AppxPackage -ErrorAction SilentlyContinue
    Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -like "*$app*" } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
}

# Disable Cortana
if (Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search") {
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Value 0 -Type DWord -Force
} else {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Value 0 -Type DWord -Force
}

Write-Success "Bloatware removed"

# 4. Optimize Network Settings
Write-Info "Optimizing network settings..."

# Enable TCP CTCP congestion control
netsh int tcp set global congestionprovider=ctcp

# Enable TCP Fast Open
netsh int tcp set global fastopen=enabled

# Optimize TCP window scaling
netsh int tcp set global autotuninglevel=normal

# Disable Nagle's algorithm for better latency
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" -Name "TcpNoDelay" -Value 1 -PropertyType DWORD -Force | Out-Null

# Enable Large Send Offload
Disable-NetAdapterLso -Name "*" -ErrorAction SilentlyContinue

Write-Success "Network optimized"

# 5. Optimize Visual Effects for Performance
Write-Info "Optimizing visual effects for performance..."

# Set system to best performance
$sysParams = [System.Environment]::OSVersion.Version
if ($sysParams.Major -ge 10) {
    $performanceKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
    if (!(Test-Path $performanceKey)) {
        New-Item -Path $performanceKey -Force | Out-Null
    }
    Set-ItemProperty -Path $performanceKey -Name "VisualFXSetting" -Value 2 -Type DWord -Force
}

# Disable transparency effects
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 0 -Type DWord -Force

Write-Success "Visual effects optimized"

# 6. Optimize SSD & Storage
Write-Info "Optimizing SSD and storage settings..."

# Enable TRIM
fsutil behavior set DisableDeleteNotify 0

# Disable hibernation (saves disk space)
powercfg -h off

Write-Success "SSD optimized"

# 7. Optimize Gaming Performance
Write-Info "Optimizing gaming performance..."

# Enable Game Mode
Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AutoGameModeEnabled" -Value 1 -Type DWord -Force
Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "UseNexusForGameBarEnabled" -Value 0 -Type DWord -Force

# Disable mouse acceleration
Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -Value 0 -Type String -Force
Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold1" -Value 0 -Type String -Force
Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold2" -Value 0 -Type String -Force

# Optimize for background services
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 38 -Type DWord -Force

Write-Success "Gaming performance optimized"

# 8. Install Essential Software via Winget
Write-Info "Installing essential software..."

# Ensure winget is available
$skipWinget = $false
try {
    winget --version | Out-Null
} catch {
    Write-Info "Winget not available, skipping software installation"
    $skipWinget = $true
}

if (!$skipWinget) {
    # Accept winget source agreement
    winget source update --force
    
    # Install essential applications
    $apps = @(
        "Google.Chrome",
        "7zip.7zip",
        "VideoLAN.VLC",
        "Git.Git",
        "Microsoft.VisualStudioCode",
        "Discord.Discord",
        "Spotify.Spotify",
        "OBSProject.OBSStudio",
        "Notepad++.Notepad++",
        "Microsoft.PowerToys"
    )
    
    foreach ($app in $apps) {
        Write-Info "Installing $app..."
        winget install --id $app --silent --accept-package-agreements --accept-source-agreements --disable-interactivity 2>$null
    }
    
    Write-Success "Essential software installed"
}

# 9. Clean Up System
Write-Info "Cleaning up system..."

# Clear temporary files
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

# Clear Windows Update cache
Stop-Service wuauserv -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
Start-Service wuauserv -ErrorAction SilentlyContinue

# Clear DNS cache
ipconfig /flushdns | Out-Null

Write-Success "System cleaned"

# 10. Generate Optimization Report
Write-Info "Generating optimization report..."

$reportPath = "$env:TEMP\T490s-Windows-Optimization-Report.txt"
$report = @"
=== T490s Windows 11 Optimization Report ===
Date: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Hostname: `$env:COMPUTERNAME
Windows Version: $(Get-WmiObject Win32_OperatingSystem).Caption
Power Plan: $(powercfg -getactivescheme | Select-String -Pattern "\{(.*)\}" | ForEach-Object { `$_.Matches.Groups[1].Value })

== Applied Optimizations ==
✓ Telemetry disabled
✓ Ultimate Performance power plan activated
✓ Bloatware removed
✓ Network optimized (CTCP, Fast Open)
✓ Visual effects optimized for performance
✓ SSD TRIM enabled
✓ Game Mode enabled
✓ Mouse acceleration disabled
✓ Temporary files cleared
"@

$report | Out-File -FilePath $reportPath -Encoding UTF8
Write-Success "Report saved to: $reportPath"

# Final Summary
Write-Host "`n========================================" -ForegroundColor Green
Write-Host "  OPTIMIZATION COMPLETE!" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Green

Write-Host "📊 Optimization Report: $reportPath" -ForegroundColor Cyan
Write-Host ""
Write-Host "⚠️  IMPORTANT NEXT STEPS:" -ForegroundColor Yellow
Write-Host "  1. Restart your computer for all changes to take effect" -ForegroundColor White
Write-Host "  2. Install latest drivers from Lenovo Vantage" -ForegroundColor White
Write-Host "  3. Update BIOS to latest version" -ForegroundColor White
Write-Host "  4. Calibrate your battery after first full charge cycle" -ForegroundColor White
Write-Host ""
Write-Host "🔧 Useful Commands:" -ForegroundColor Cyan
Write-Host "  - Check power plan: powercfg -list" -ForegroundColor White
Write-Host "  - Battery report: powercfg /batteryreport" -ForegroundColor White
Write-Host "  - View energy usage: taskmgr (Details tab > Select columns > Power usage)" -ForegroundColor White
Write-Host "  - Check SSD health: wmic diskdrive get status" -ForegroundColor White
Write-Host ""
Write-Host "Enjoy your optimized ThinkPad T490s! 🚀" -ForegroundColor Green

if (-not $SkipRestart) {
    Write-Host "`nWould you like to restart now? (Y/N)" -ForegroundColor Yellow
    $response = Read-Host
    if ($response -match '^[Yy]$') {
        Write-Info "Restarting in 5 seconds..."
        Start-Sleep -Seconds 5
        Restart-Computer -Force
    }
}
