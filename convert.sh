#!/bin/bash

################################################################################
# Linux / macOS Shell Script - Parquet to JSON Converter
################################################################################
# Usage: bash convert.sh
#        chmod +x convert.sh && ./convert.sh
#
# Make sure:
# 1. Python 3.7+ is installed
# 2. Required packages are installed: pip install pyarrow
# 3. This script is in the same directory as batch_convert.py and config.py
################################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo ""
echo "================================================================================"
echo "Parquet to JSON Batch Converter - Linux / macOS"
echo "================================================================================"
echo ""

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}ERROR: Python 3 is not installed${NC}"
    echo "Please install Python 3 using:"
    echo "  - macOS: brew install python3"
    echo "  - Ubuntu/Debian: sudo apt-get install python3 python3-pip"
    echo "  - CentOS/RHEL: sudo yum install python3 python3-pip"
    exit 1
fi

# Check Python version
PYTHON_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
echo -e "${GREEN}✓ Python $PYTHON_VERSION found${NC}"

# Check if pyarrow is installed
if ! python3 -c "import pyarrow.parquet" 2>/dev/null; then
    echo -e "${YELLOW}⚠ Required packages are not installed${NC}"
    echo "Installing from requirements.txt..."
    
    if command -v pip3 &> /dev/null; then
        pip3 install -r requirements.txt
    elif command -v pip &> /dev/null; then
        pip install -r requirements.txt
    else
        echo -e "${RED}ERROR: pip is not found. Please install requirements manually:${NC}"
        echo "  pip3 install -r requirements.txt"
        exit 1
    fi
fi

echo -e "${GREEN}✓ All dependencies installed${NC}"
echo ""

# Check if batch_convert.py exists
if [ ! -f "batch_convert.py" ]; then
    echo -e "${RED}ERROR: batch_convert.py not found in current directory${NC}"
    echo "Please make sure this script is in the same directory as batch_convert.py"
    exit 1
fi

# Check if config.py exists
if [ ! -f "config.py" ]; then
    echo -e "${RED}ERROR: config.py not found in current directory${NC}"
    echo "Please make sure this script is in the same directory as config.py"
    exit 1
fi

# Run the converter
echo "Starting conversion..."
echo ""

if python3 batch_convert.py; then
    echo ""
    echo -e "${GREEN}================================================================================${NC}"
    echo -e "${GREEN}SUCCESS: Conversion completed!${NC}"
    echo -e "${GREEN}================================================================================${NC}"
    exit 0
else
    echo ""
    echo -e "${RED}================================================================================${NC}"
    echo -e "${RED}ERROR: Conversion failed!${NC}"
    echo -e "${RED}================================================================================${NC}"
    exit 1
fi
