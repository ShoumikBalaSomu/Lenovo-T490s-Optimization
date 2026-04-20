# Device-Specific Windows 11 Optimization for Lenovo ThinkPad T490s
# Run as Administrator

Write-Host "Starting Windows 11 Optimization for ThinkPad T490s..." -ForegroundColor Cyan

# 1. Disable Telemetry
Write-Host "Disabling Telemetry..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Value 0 -Type DWord
Stop-Service -Name "DiagTrack" -WarningAction SilentlyContinue
Set-Service -Name "DiagTrack" -StartupType Disabled -WarningAction SilentlyContinue

# 2. Optimize Power Settings for Performance
Write-Host "Setting power plan to High Performance..." -ForegroundColor Yellow
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

# 3. Disable Unnecessary Startup Apps (Example)
Write-Host "Disabling unnecessary startup programs..." -ForegroundColor Yellow
Get-CimInstance Win32_StartupCommand | Where-Object { $_.Name -match "OneDrive" } | ForEach-Object { Disable-NetAdapter -Name $_.Name -ErrorAction SilentlyContinue }

Write-Host "Optimization Complete!" -ForegroundColor Green
Write-Host "Please restart your computer." -ForegroundColor Cyan
