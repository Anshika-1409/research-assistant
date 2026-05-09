$ErrorActionPreference = "Stop"

$ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$StartScript = Join-Path $ProjectRoot "scripts\start-backend.ps1"
$TaskName = "ResearchAssistantBackend"

if (-not (Test-Path $StartScript)) {
    throw "Missing startup script: $StartScript"
}

$action = New-ScheduledTaskAction `
    -Execute "powershell.exe" `
    -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$StartScript`"" `
    -WorkingDirectory $ProjectRoot

$trigger = New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME
$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -ExecutionTimeLimit (New-TimeSpan -Days 0)

Register-ScheduledTask `
    -TaskName $TaskName `
    -Action $action `
    -Trigger $trigger `
    -Settings $settings `
    -Description "Starts the Research Assistant Spring Boot backend at Windows login." `
    -Force | Out-Null

Write-Host "Installed Windows startup task: $TaskName"
Write-Host "The backend will start automatically when you log in."
Write-Host "Starting it now..."

Start-ScheduledTask -TaskName $TaskName
