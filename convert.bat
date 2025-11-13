@echo off
REM ============================================================================
REM Windows Batch File - Parquet to JSON Converter
REM ============================================================================
REM Usage: Simply double-click this file or run it from command prompt
REM
REM Make sure:
REM 1. Python 3.7+ is installed and in PATH
REM 2. Required packages are installed: pip install pyarrow
REM 3. This file is in the same directory as batch_convert.py and config.py
REM ============================================================================

setlocal enabledelayedexpansion

echo.
echo ============================================================================
echo Parquet to JSON Batch Converter - Windows
echo ============================================================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python from https://www.python.org
    echo Make sure to check "Add Python to PATH" during installation
    pause
    exit /b 1
)

REM Check if required packages are installed
python -c "import pyarrow.parquet" >nul 2>&1
if errorlevel 1 (
    echo WARNING: Required packages are not installed
    echo Installing from requirements.txt...
    pip install -r requirements.txt
    if errorlevel 1 (
        echo ERROR: Failed to install requirements
        pause
        exit /b 1
    )
)

REM Run the converter
echo Starting conversion...
echo.
python batch_convert.py

REM Check exit code
if errorlevel 1 (
    echo.
    echo ERROR: Conversion failed!
    pause
    exit /b 1
) else (
    echo.
    echo SUCCESS: Conversion completed!
    pause
)
