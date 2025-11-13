# PowerShell Script - Parquet to JSON Converter
# Usage: powershell -ExecutionPolicy Bypass -File convert.ps1

Write-Host ""
Write-Host "================================================================================" -ForegroundColor Cyan
Write-Host "Parquet to JSON Batch Converter - Windows PowerShell" -ForegroundColor Cyan
Write-Host "================================================================================" -ForegroundColor Cyan
Write-Host ""

# Check if Python is installed
try {
    $pythonVersion = python --version 2>&1
    Write-Host "✓ Python found: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ ERROR: Python is not installed or not in PATH" -ForegroundColor Red
    Write-Host "  Please install Python from https://www.python.org" -ForegroundColor Yellow
    Write-Host "  Make sure to check 'Add Python to PATH' during installation" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

# Check if PyArrow is installed
Write-Host "Checking dependencies..." -ForegroundColor Cyan
try {
    python -c "import pyarrow.parquet" 2>&1 | Out-Null
    Write-Host "PyArrow is installed" -ForegroundColor Green
} catch {
    Write-Host "WARNING: Required packages are not installed" -ForegroundColor Yellow
    Write-Host "Installing from requirements.txt..." -ForegroundColor Cyan
    
    python -m pip install -r requirements.txt
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: Failed to install requirements" -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
    Write-Host "Requirements installed successfully" -ForegroundColor Green
}

Write-Host ""
Write-Host "Starting conversion..." -ForegroundColor Cyan
Write-Host ""

# Run the converter
python batch_convert.py

# Check if conversion was successful
if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "================================================================================" -ForegroundColor Green
    Write-Host "SUCCESS: Conversion completed!" -ForegroundColor Green
    Write-Host "================================================================================" -ForegroundColor Green
    Read-Host "Press Enter to exit"
    exit 0
} else {
    Write-Host ""
    Write-Host "================================================================================" -ForegroundColor Red
    Write-Host "ERROR: Conversion failed!" -ForegroundColor Red
    Write-Host "================================================================================" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}
