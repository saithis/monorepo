param(
    [Parameter(Position=0)]
    [string]$Service = "all"
)

Write-Host "Building monorepo services..." -ForegroundColor Green

# Get the script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RootDir = Split-Path -Parent $ScriptDir

# Function to build a specific service
function Build-Service {
    param([string]$ServiceName)
    
    $ServicePath = Join-Path $RootDir "services" $ServiceName
    
    if (-not (Test-Path $ServicePath)) {
        Write-Host "Service '$ServiceName' not found at: $ServicePath" -ForegroundColor Red
        return $false
    }
    
    Write-Host "Building service: $ServiceName" -ForegroundColor Yellow
    
    try {
        # Build the service
        $SolutionFile = Get-ChildItem -Path $ServicePath -Filter "*.slnx" | Select-Object -First 1
        
        if ($SolutionFile) {
            Push-Location $ServicePath
            dotnet build $SolutionFile.Name --configuration Release
            $BuildResult = $LASTEXITCODE
            Pop-Location
            
            if ($BuildResult -eq 0) {
                Write-Host "Service '$ServiceName' built successfully" -ForegroundColor Green
                return $true
            } else {
                Write-Host "Service '$ServiceName' build failed" -ForegroundColor Red
                return $false
            }
        } else {
            Write-Host "No solution file found for service '$ServiceName'" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "Error building service '$ServiceName': $_" -ForegroundColor Red
        return $false
    }
}

# Function to build all services
function Build-AllServices {
    Write-Host "Building all services..." -ForegroundColor Yellow
    
    $ServicesDir = Join-Path $RootDir "services"
    $Services = Get-ChildItem -Path $ServicesDir -Directory | Where-Object { 
        Test-Path (Join-Path $_.FullName "*.slnx") 
    }
    
    $SuccessCount = 0
    $TotalCount = $Services.Count
    
    foreach ($Service in $Services) {
        if (Build-Service -ServiceName $Service.Name) {
            $SuccessCount++
        }
    }
    
    Write-Host "Build completed: $SuccessCount/$TotalCount services built successfully" -ForegroundColor Green
    
    if ($SuccessCount -eq $TotalCount) {
        return 0
    } else {
        return 1
    }
}

# Main execution
try {
    if ($Service -eq "all") {
        $ExitCode = Build-AllServices
    } else {
        if (Build-Service -ServiceName $Service) {
            $ExitCode = 0
        } else {
            $ExitCode = 1
        }
    }
    
    exit $ExitCode
}
catch {
    Write-Host "Build script error: $_" -ForegroundColor Red
    exit 1
}
