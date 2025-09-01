param(
    [Parameter(Position=0)]
    [string]$Service = "all"
)

Write-Host "Running tests for monorepo services..." -ForegroundColor Green

# Get the script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RootDir = Split-Path -Parent $ScriptDir

# Function to test a specific service
function Test-Service {
    param([string]$ServiceName)
    
    $ServicePath = Join-Path $RootDir "services" $ServiceName
    
    if (-not (Test-Path $ServicePath)) {
        Write-Host "Service '$ServiceName' not found at: $ServicePath" -ForegroundColor Red
        return $false
    }
    
    Write-Host "Testing service: $ServiceName" -ForegroundColor Yellow
    
    try {
        # Find test projects
        $TestsDir = Join-Path $ServicePath "tests"
        if (-not (Test-Path $TestsDir)) {
            Write-Host "No tests directory found for service '$ServiceName'" -ForegroundColor Yellow
            return $true
        }
        
        $TestProjects = Get-ChildItem -Path $TestsDir -Directory | Where-Object { 
            Test-Path (Join-Path $_.FullName "*.csproj") 
        }
        
        if ($TestProjects.Count -eq 0) {
            Write-Host "No test projects found for service '$ServiceName'" -ForegroundColor Yellow
            return $true
        }
        
        $SuccessCount = 0
        $TotalCount = $TestProjects.Count
        
        foreach ($TestProject in $TestProjects) {
            Write-Host "  Running tests in: $($TestProject.Name)" -ForegroundColor Cyan
            
            Push-Location $TestProject.FullName
            dotnet test --configuration Release --no-build
            $TestResult = $LASTEXITCODE
            Pop-Location
            
            if ($TestResult -eq 0) {
                $SuccessCount++
                Write-Host "  Tests passed for: $($TestProject.Name)" -ForegroundColor Green
            } else {
                Write-Host "  Tests failed for: $($TestProject.Name)" -ForegroundColor Red
            }
        }
        
        if ($SuccessCount -eq $TotalCount) {
            Write-Host "Service '$ServiceName' tests completed successfully" -ForegroundColor Green
            return $true
        } else {
            Write-Host "Service '$ServiceName' tests failed: $SuccessCount/$TotalCount passed" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "Error testing service '$ServiceName': $_" -ForegroundColor Red
        return $false
    }
}

# Function to test all services
function Test-AllServices {
    Write-Host "Testing all services..." -ForegroundColor Yellow
    
    $ServicesDir = Join-Path $RootDir "services"
    $Services = Get-ChildItem -Path $ServicesDir -Directory | Where-Object { 
        Test-Path (Join-Path $_.FullName "*.slnx") 
    }
    
    $SuccessCount = 0
    $TotalCount = $Services.Count
    
    foreach ($Service in $Services) {
        if (Test-Service -ServiceName $Service.Name) {
            $SuccessCount++
        }
    }
    
    Write-Host "Testing completed: $SuccessCount/$TotalCount services tested successfully" -ForegroundColor Green
    
    if ($SuccessCount -eq $TotalCount) {
        return 0
    } else {
        return 1
    }
}

# Main execution
try {
    if ($Service -eq "all") {
        $ExitCode = Test-AllServices
    } else {
        if (Test-Service -ServiceName $Service) {
            $ExitCode = 0
        } else {
            $ExitCode = 1
        }
    }
    
    exit $ExitCode
}
catch {
    Write-Host "Test script error: $_" -ForegroundColor Red
    exit 1
}
