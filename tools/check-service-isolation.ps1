param(
    [Parameter(Position=0)]
    [string]$Service = "all"
)

Write-Host "🔍 Checking service isolation..." -ForegroundColor Green

# Get the script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RootDir = Split-Path -Parent $ScriptDir

# Function to check a specific service for isolation violations
function Test-ServiceIsolation {
    param([string]$ServiceName)
    
    $ServicePath = Join-Path $RootDir "services" $ServiceName
    $Violations = @()
    
    if (-not (Test-Path $ServicePath)) {
        Write-Host "Service '$ServiceName' not found at: $ServicePath" -ForegroundColor Red
        return $false
    }
    
    Write-Host "Checking service: $ServiceName" -ForegroundColor Yellow
    
    # Check .csproj files for project references to other services
    $SrcPath = Join-Path $ServicePath "src"
    if (Test-Path $SrcPath) {
        $CsProjFiles = Get-ChildItem -Path $SrcPath -Filter "*.csproj" -Recurse
        
        foreach ($CsProj in $CsProjFiles) {
            Write-Host "  Scanning $($CsProj.Name)..." -ForegroundColor Cyan
            
            $Content = Get-Content $CsProj.FullName -Raw
            $Lines = $Content -split "`n"
            
            for ($i = 0; $i -lt $Lines.Count; $i++) {
                $Line = $Lines[$i]
                
                # Check for ProjectReference to other services
                if ($Line -match 'ProjectReference.*Include.*"\.\./\.\./\.\./services/([^/]+)') {
                    $ReferencedService = $matches[1]
                    if ($ReferencedService -ne $ServiceName) {
                        $Violation = "❌ $ServiceName references $ReferencedService in $($CsProj.Name) at line $($i + 1)"
                        $Violations += $Violation
                        Write-Host $Violation -ForegroundColor Red
                    }
                }
            }
        }
    }
    

    
    if ($Violations.Count -eq 0) {
        Write-Host "✅ $ServiceName maintains proper isolation" -ForegroundColor Green
        return $true
    } else {
        Write-Host "❌ $ServiceName has $($Violations.Count) isolation violations" -ForegroundColor Red
        return $false
    }
}

# Function to check all services
function Test-AllServicesIsolation {
    Write-Host "Checking all services for isolation violations..." -ForegroundColor Yellow
    
    $ServicesDir = Join-Path $RootDir "services"
    $Services = Get-ChildItem -Path $ServicesDir -Directory | Where-Object { 
        Test-Path (Join-Path $_.FullName "*.slnx") 
    }
    
    $SuccessCount = 0
    $TotalCount = $Services.Count
    $AllViolations = @()
    
    foreach ($Service in $Services) {
        if (Test-ServiceIsolation -ServiceName $Service.Name) {
            $SuccessCount++
        }
    }
    
    Write-Host ""
    Write-Host "=====================================" -ForegroundColor Yellow
    Write-Host "SERVICE ISOLATION CHECK RESULTS" -ForegroundColor Yellow
    Write-Host "=====================================" -ForegroundColor Yellow
    Write-Host "Services checked: $TotalCount" -ForegroundColor Cyan
    Write-Host "Services with violations: $($TotalCount - $SuccessCount)" -ForegroundColor Cyan
    Write-Host "Services maintaining isolation: $SuccessCount" -ForegroundColor Cyan
    
    if ($SuccessCount -eq $TotalCount) {
        Write-Host ""
        Write-Host "🎉 All services maintain proper isolation!" -ForegroundColor Green
        Write-Host "Your monorepo architecture is properly enforced." -ForegroundColor Green
        return 0
    } else {
        Write-Host ""
        Write-Host "🚨 Service isolation violations found!" -ForegroundColor Red
        Write-Host "Please fix these issues to maintain proper service boundaries." -ForegroundColor Red
        return 1
    }
}

# Main execution
try {
    if ($Service -eq "all") {
        $ExitCode = Test-AllServicesIsolation
    } else {
        if (Test-ServiceIsolation -ServiceName $Service) {
            $ExitCode = 0
        } else {
            $ExitCode = 1
        }
    }
    
    exit $ExitCode
}
catch {
    Write-Host "Service isolation check error: $_" -ForegroundColor Red
    exit 1
}
