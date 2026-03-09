param(
    [ValidateSet("menu", "install", "demo", "tools-on", "tools-off", "status", "down")]
    [string]$Mode = "menu"
)

function Invoke-Compose {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Command
    )

    Write-Host "`n> docker compose $Command" -ForegroundColor Cyan
    Invoke-Expression "docker compose $Command"
}

function Ensure-SrcDirectory {
    if (-not (Test-Path "src")) {
        New-Item -ItemType Directory -Path "src" | Out-Null
        Write-Host "Created ./src directory." -ForegroundColor Green
    }
}

function Ensure-LaravelProject {
    Ensure-SrcDirectory
    if (-not (Test-Path "src\artisan")) {
        Write-Host "Laravel source not found. Creating project..." -ForegroundColor Yellow
        Invoke-Compose "run --rm app composer create-project laravel/laravel ."
    } else {
        Write-Host "Laravel source already exists. Skipping create-project." -ForegroundColor Green
    }
}

function Configure-LaravelRuntime {
    Write-Host "Configuring Laravel runtime..." -ForegroundColor Yellow
    docker compose exec -T app sh -lc "if [ ! -f .env ]; then cp .env.example .env; fi"
    docker compose exec -T app php artisan key:generate
    docker compose exec -T app sh -lc "sed -i 's/^SESSION_DRIVER=.*/SESSION_DRIVER=file/' .env; sed -i 's/^CACHE_STORE=.*/CACHE_STORE=file/' .env; sed -i 's/^QUEUE_CONNECTION=.*/QUEUE_CONNECTION=sync/' .env; php artisan config:clear"
}

function Run-DemoChecks {
    param(
        [bool]$CheckPhpMyAdmin = $false
    )

    Write-Host "`nRunning demo checks..." -ForegroundColor Green
    Invoke-Compose "ps"
    docker compose exec -T app php artisan route:list
    docker compose exec -T app php artisan migrate:status

    try {
        $appCode = (Invoke-WebRequest -UseBasicParsing http://localhost -TimeoutSec 20).StatusCode
        Write-Host "Laravel endpoint: HTTP $appCode" -ForegroundColor Green
    } catch {
        Write-Host "Laravel endpoint check failed." -ForegroundColor Red
        throw
    }

    if ($CheckPhpMyAdmin) {
        try {
            $pmaCode = (Invoke-WebRequest -UseBasicParsing http://localhost:8080 -TimeoutSec 20).StatusCode
            Write-Host "phpMyAdmin endpoint: HTTP $pmaCode" -ForegroundColor Green
        } catch {
            Write-Host "phpMyAdmin endpoint check failed." -ForegroundColor Red
            throw
        }
    }
}

function Start-Stack {
    param(
        [bool]$IncludePhpMyAdmin = $false
    )

    if ($IncludePhpMyAdmin) {
        Invoke-Compose "--profile tools up -d --build"
    } else {
        Invoke-Compose "up -d --build app db nginx"
    }
}

function Run-InstallFlow {
    param(
        [bool]$IncludePhpMyAdmin
    )

    Ensure-LaravelProject
    Start-Stack -IncludePhpMyAdmin $IncludePhpMyAdmin
    Configure-LaravelRuntime
    Run-DemoChecks -CheckPhpMyAdmin $IncludePhpMyAdmin
    Write-Host "App: http://localhost" -ForegroundColor Yellow
    if ($IncludePhpMyAdmin) {
        Write-Host "phpMyAdmin: http://localhost:8080" -ForegroundColor Yellow
    } else {
        Write-Host "phpMyAdmin not enabled. Enable later with: .\setup.ps1 -Mode tools-on" -ForegroundColor Yellow
    }
}

function Show-Menu {
    Write-Host "" 
    Write-Host "LEMP Laravel Installer/CLI" -ForegroundColor Green
    Write-Host "1. Install (choose phpMyAdmin yes/no)"
    Write-Host "2. Demo check"
    Write-Host "3. Enable phpMyAdmin"
    Write-Host "4. Disable phpMyAdmin"
    Write-Host "5. Status"
    Write-Host "6. Down"
    Write-Host "0. Exit"

    $choice = Read-Host "Select"
    switch ($choice) {
        "1" { $script:Mode = "install" }
        "2" { $script:Mode = "demo" }
        "3" { $script:Mode = "tools-on" }
        "4" { $script:Mode = "tools-off" }
        "5" { $script:Mode = "status" }
        "6" { $script:Mode = "down" }
        default { $script:Mode = "exit" }
    }
}

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "Docker CLI not found. Install/start Docker Desktop first." -ForegroundColor Red
    exit 1
}

if ($Mode -eq "menu") {
    Show-Menu
}

switch ($Mode) {
    "install" {
        $pick = Read-Host "Install phpMyAdmin now? (y/n)"
        Run-InstallFlow -IncludePhpMyAdmin ($pick -eq "y")
    }
    "demo" {
        $wantPma = Read-Host "Check phpMyAdmin endpoint too? (y/n)"
        Run-DemoChecks -CheckPhpMyAdmin ($wantPma -eq "y")
    }
    "tools-on" {
        Write-Host "Enabling phpMyAdmin..." -ForegroundColor Yellow
        Invoke-Compose "--profile tools up -d phpmyadmin"
        Invoke-Compose "ps"
        Write-Host "phpMyAdmin: http://localhost:8080" -ForegroundColor Yellow
    }
    "tools-off" {
        Write-Host "Disabling phpMyAdmin..." -ForegroundColor Yellow
        docker compose stop phpmyadmin
        Invoke-Compose "ps"
    }
    "status" {
        Invoke-Compose "ps"
    }
    "down" {
        Invoke-Compose "--profile tools down"
    }
    "exit" {
        Write-Host "Exit." -ForegroundColor Yellow
    }
    default {
        Write-Host "Unknown mode." -ForegroundColor Red
        exit 1
    }
}
