$ErrorActionPreference = "Stop"

$ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$LogDir = Join-Path $ProjectRoot "logs"
$PidFile = Join-Path $LogDir "research-assistant-backend.pid"

if (-not (Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir | Out-Null
}

function Test-BackendRunning {
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:8080/actuator/health" -UseBasicParsing -TimeoutSec 3
        return $response.StatusCode -ge 200 -and $response.StatusCode -lt 500
    } catch {
        return $false
    }
}

if (Test-BackendRunning) {
    Write-Host "Research Assistant backend is already running on http://localhost:8080"
    exit 0
}

$jar = Get-ChildItem -Path (Join-Path $ProjectRoot "target") -Filter "*.jar" -File -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -notlike "*.original" } |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1

if (-not $jar) {
    Write-Host "No packaged jar found. Building the backend first..."
    Push-Location $ProjectRoot
    try {
        & .\mvnw.cmd -DskipTests package
        if ($LASTEXITCODE -ne 0) {
            throw "Maven package failed with exit code $LASTEXITCODE"
        }
    } finally {
        Pop-Location
    }

    $jar = Get-ChildItem -Path (Join-Path $ProjectRoot "target") -Filter "*.jar" -File |
        Where-Object { $_.Name -notlike "*.original" } |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1
}

if (-not $jar) {
    throw "Could not find a runnable jar in target after build."
}

$outLog = Join-Path $LogDir "backend.out.log"
$errLog = Join-Path $LogDir "backend.err.log"

# Some Windows shells can expose both Path and PATH. Start-Process treats the
# environment as case-insensitive and fails if both are present.
$pathValue = [System.Environment]::GetEnvironmentVariable("Path", "Process")
if (-not $pathValue) {
    $pathValue = [System.Environment]::GetEnvironmentVariable("PATH", "Process")
}
if ($pathValue) {
    [System.Environment]::SetEnvironmentVariable("PATH", $null, "Process")
    [System.Environment]::SetEnvironmentVariable("Path", $pathValue, "Process")
}

$process = Start-Process -FilePath "java" `
    -ArgumentList @("-jar", $jar.FullName) `
    -WorkingDirectory $ProjectRoot `
    -RedirectStandardOutput $outLog `
    -RedirectStandardError $errLog `
    -WindowStyle Hidden `
    -PassThru

$process.Id | Set-Content -Path $PidFile

Write-Host "Research Assistant backend started on http://localhost:8080"
Write-Host "PID: $($process.Id)"
Write-Host "Logs: $outLog"
