# Clear the screen and display ASCII banner
Clear-Host

# Define ASCII banner
$asciiBanner = @"
__          ___       _____                      
\ \        / (_)     |  __ \                     
 \ \  /\  / / _ _ __ | |__) |   _ _ __ __ _  ___ 
  \ \/  \/ / | | '_ \|  ___/ | | | '__/ _' |/ _ \
   \  /\  /  | | | | | |   | |_| | | | (_| |  __/
    \/  \/   |_|_| |_|_|    \__,_|_|  \__, |\___|
                                       __/ |     
                                      |___/      

                   Made by Qloud
                   https://github.com/ql0ud
"@

# Print ASCII banner in Cyan
Write-Host $asciiBanner -ForegroundColor Cyan

# Wait 5 seconds before starting
Start-Sleep -Seconds 5

# Set the start time for elapsed time calculation
$ScriptStartTime = Get-Date

# Define a simple logging function to output messages in the specified color (no timestamp)
function Write-Log {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,
        [ConsoleColor]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

# Define a pause function for a 2-second delay after each step
function Pause-Step { Start-Sleep -Seconds 1 }

Write-Log "`nStarting system cleanup..." Green

# Delete Temp files
Write-Log "Deleting Temp files..." White
Remove-Item -Path "$env:Temp\*" -Force -Recurse -ErrorAction SilentlyContinue
Pause-Step

# Delete Windows Temp folder
Write-Log "Deleting Windows Temp folder..." White
Remove-Item -Path "C:\Windows\Temp\*" -Force -Recurse -ErrorAction SilentlyContinue
Pause-Step

# Delete Prefetch files
Write-Log "Deleting Prefetch files..." White
Remove-Item -Path "C:\Windows\Prefetch\*" -Force -Recurse -ErrorAction SilentlyContinue
Pause-Step

# Clear Windows Update cache
Write-Log "Clearing Windows Update cache..." White
Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
Pause-Step

# Deep clean Windows Update DataStore
Write-Log "Cleaning Windows Update DataStore..." White
net stop wuauserv | Out-Null
Remove-Item -Path "C:\Windows\SoftwareDistribution\DataStore\*" -Recurse -Force -ErrorAction SilentlyContinue
net start wuauserv | Out-Null
Pause-Step

# Delete old Windows log files
Write-Log "Deleting old Windows log files..." White
Get-ChildItem "C:\Windows\Logs" -Recurse -Include *.log -Force -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
Pause-Step

# Clear thumbnail and icon cache
Write-Log "Clearing thumbnail and icon cache..." White
Remove-Item "$env:LocalAppData\Microsoft\Windows\Explorer\thumbcache_*.db" -Force -ErrorAction SilentlyContinue
Pause-Step

# Clean memory dump files
Write-Log "Deleting crash dump files..." White
Remove-Item "C:\Windows\MEMORY.DMP" -Force -ErrorAction SilentlyContinue
Remove-Item "C:\*.dmp" -Force -ErrorAction SilentlyContinue
Pause-Step

# Clear Microsoft Edge cache
Write-Log "Clearing Microsoft Edge cache..." White
Remove-Item "$env:LocalAppData\Microsoft\Edge\User Data\Default\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue
Pause-Step

# Clear Google Chrome cache
Write-Log "Clearing Google Chrome cache..." White
Remove-Item "$env:LocalAppData\Google\Chrome\User Data\Default\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$env:LocalAppData\Google\Chrome\User Data\Default\Code Cache\*" -Recurse -Force -ErrorAction SilentlyContinue
Pause-Step

# Clear Mozilla Firefox cache
Write-Log "Clearing Mozilla Firefox cache..." White
$firefoxProfiles = Get-ChildItem "$env:APPDATA\Mozilla\Firefox\Profiles\" -Directory -ErrorAction SilentlyContinue
foreach ($profile in $firefoxProfiles) {
    Remove-Item "$($profile.FullName)\cache2\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "$($profile.FullName)\jumpListCache\*" -Recurse -Force -ErrorAction SilentlyContinue
}
Pause-Step

# Clear Brave browser cache (optional - Chromium-based)
Write-Log "Clearing Brave browser cache..." White
Remove-Item "$env:LocalAppData\BraveSoftware\Brave-Browser\User Data\Default\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$env:LocalAppData\BraveSoftware\Brave-Browser\User Data\Default\Code Cache\*" -Recurse -Force -ErrorAction SilentlyContinue
Pause-Step

# Clear Opera browser cache (optional - Chromium-based)
Write-Log "Clearing Opera browser cache..." White
Remove-Item "$env:AppData\Opera Software\Opera Stable\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$env:AppData\Opera Software\Opera Stable\Code Cache\*" -Recurse -Force -ErrorAction SilentlyContinue
Pause-Step

# Flush DNS cache
Write-Log "Flushing DNS cache..." White
ipconfig /flushdns | Out-Null
Pause-Step

# Reset network stack (TCP/IP + Winsock)
Write-Log "Resetting network stack..." White
netsh int ip reset | Out-Null
netsh winsock reset | Out-Null
Pause-Step

# Clear Windows Error Reporting logs
Write-Log "Cleaning up Windows Error Reporting logs..." White
Remove-Item "C:\ProgramData\Microsoft\Windows\WER\*" -Recurse -Force -ErrorAction SilentlyContinue
Pause-Step

# Clean Windows Component Store
Write-Log "Cleaning up Windows component store..." White
dism /online /cleanup-image /startcomponentcleanup /quiet | Out-Null
Pause-Step

# Empty Recycle Bin
Write-Log "Emptying Recycle Bin..." White
Clear-RecycleBin -Force -ErrorAction SilentlyContinue
Pause-Step

# Clear Windows Event Logs
Write-Log "Clearing all Windows Event Logs..." White
wevtutil el | ForEach-Object { wevtutil cl "$_" } 2>$null
Pause-Step

# Cleanup temporary folders created by Windows Installer
Write-Log "Cleaning leftover Windows Installer folders..." White
Remove-Item "C:\Windows\Installer\$PatchCache$\*" -Recurse -Force -ErrorAction SilentlyContinue
Pause-Step

# Detect and remove broken shortcuts from Start Menu
Write-Log "Detecting and removing broken shortcuts from Start Menu..." White
$shortcuts = Get-ChildItem -Path "$env:APPDATA\Microsoft\Windows\Start Menu" -Recurse -Include *.lnk -ErrorAction SilentlyContinue
foreach ($sc in $shortcuts) {
    try {
        $target = ((New-Object -ComObject WScript.Shell).CreateShortcut($sc.FullName)).TargetPath
        if (-not (Test-Path $target)) {
            Remove-Item $sc.FullName -Force -ErrorAction SilentlyContinue
        }
    } catch {}
}
Pause-Step

# Compact OS
Write-Log "Running Compact OS to reduce reserved space..." White
compact.exe /compactOS:always
Pause-Step

# Remove orphaned .tmp, .bak, and .old files
Write-Log "Removing .tmp, .bak, and .old files from system drive..." White
Get-ChildItem -Path C:\ -Include *.tmp,*.bak,*.old -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
Pause-Step

# Remove previous Windows installation (Windows.old)
Write-Log "Removing previous Windows installation files (Windows.old)..." White
Remove-Item "C:\Windows.old" -Recurse -Force -ErrorAction SilentlyContinue
Pause-Step

# Delete temporary user profiles (if any)
Write-Log "Deleting temporary user profiles..." White
Get-WmiObject -Class Win32_UserProfile | Where-Object {
    $_.Special -eq $false -and $_.LocalPath -like '*Temp*'
} | ForEach-Object {
    Remove-WmiObject -InputObject $_ -ErrorAction SilentlyContinue
}
Pause-Step

# Clear Delivery Optimization cache
Write-Log "Clearing Delivery Optimization cache..." White
Remove-Item "C:\ProgramData\Microsoft\Network\Downloader\*" -Recurse -Force -ErrorAction SilentlyContinue
Pause-Step

# Reset Windows Defender protection history
Write-Log "Clearing Windows Defender protection history..." White
Remove-Item "C:\ProgramData\Microsoft\Windows Defender\Scans\History\Service\*" -Recurse -Force -ErrorAction SilentlyContinue
Pause-Step

# Reset Print Spooler (clears stuck print jobs)
Write-Log "Resetting Print Spooler..." White
net stop spooler | Out-Null
Remove-Item -Path "C:\Windows\System32\spool\PRINTERS\*" -Force -Recurse -ErrorAction SilentlyContinue
net start spooler | Out-Null
Pause-Step

# Disk Defragmentation
Write-Log "Starting disk defragmentation on C: and D: ..." Cyan
Write-Log "Defragmenting C: ..." White
$progressC = (defrag C: /O | Select-String -Pattern '\d{1,3}%')
$progressC | ForEach-Object { Write-Host $_ }
Pause-Step
Write-Log "Defragmenting D: ..." White
$progressD = (defrag D: /O | Select-String -Pattern '\d{1,3}%')
$progressD | ForEach-Object { Write-Host $_ }
Pause-Step
Write-Log "Disk defragmentation completed." Green
Pause-Step

Write-Log "System cleanup completed successfully." Green

# Final Summary: Calculate total elapsed time and display summary statistics
$ScriptEndTime = Get-Date
$ElapsedTime = $ScriptEndTime - $ScriptStartTime
Write-Log "Total time elapsed: $($ElapsedTime.Hours) hours, $($ElapsedTime.Minutes) minutes, $($ElapsedTime.Seconds) seconds." Green