# Batch Parquet to JSON Converter

A professional, configurable batch converter for converting Parquet files to JSON format with support for multiple timeframes and years across Windows(+), Linux(~), and macOS(~).


## Setup

### Prerequisites

**Python 3.7+**

### Install Dependencies

```bash
# Automatic (via requirements.txt) - Recommended
pip install -r requirements.txt

# OR Manual installation
pip install pyarrow
```

The scripts will automatically install dependencies if needed.

### Project Structure

```
Helper Scripts/
├── config.py                # Configuration file (edit this!)
├── batch_convert.py         # Main conversion script
├── convert.bat             # Windows launcher (double-click)
├── convert.sh              # Linux/macOS launcher (bash)
├── parquet_to_json.py      # Original single-file converter
├── 1d/
│   ├── 2020.parquet
│   ├── 2021.parquet
│   └── ...
├── 4h/
│   ├── 2020.parquet
│   ├── 2021.parquet
│   └── ...
└── json/                    # Output directory (auto-created)
    ├── 1d/
    │   ├── 2020.json
    │   └── ...
    └── 4h/
        ├── 2020.json
        └── ...
```

## Configuration

Edit `config.py` to customize the conversion process:

```python
# Output format: "json" or "ndjson"
OUTPUT_FORMAT = "json"

# Indentation for pretty-printing (2 or 4, or None for compact)
INDENT = 2

# Batch size for streaming (rows per iteration)
BATCH_SIZE = 64_000

# Timeframes to process
TIMEFRAMES = ["1d", "4h"]

# Years to process
YEARS = [2020, 2021, 2022, 2023, 2024, 2025]

# Input/output directories
INPUT_BASE_DIR = "."
OUTPUT_BASE_DIR = "json"
```

## Usage

### Windows

**Option 1: Double-click**
```
Double-click: convert.bat
```

**Option 2: Command Prompt**
```cmd
cd path\to\Helper Scripts
convert.bat
```

### Linux / macOS

**Option 1: Direct execution**
```bash
cd /path/to/Helper\ Scripts
chmod +x convert.sh
./convert.sh
```

**Option 2: Bash execution**
```bash
bash convert.sh
```

### Manual Python Execution

```bash
python3 batch_convert.py
```

## Output Format Examples

### JSON Format (Default)
```json
[
  {
    "timestamp": 1578038400000,
    "open": 6244.330078125,
    "high": 6607.39013671875,
    ...
  },
  {
    "timestamp": 1578052800000,
    "open": 6552.7900390625,
    ...
  }
]
```

### NDJSON Format
```
{"timestamp": 1578038400000, "open": 6244.330078125, ...}
{"timestamp": 1578052800000, "open": 6552.7900390625, ...}
```

## Performance Tips

- **Large Files**: Use `OUTPUT_FORMAT = "ndjson"` for better memory efficiency
- **Batch Size**: Increase `BATCH_SIZE` (e.g., 128_000) for faster processing on systems with more RAM
- **Indent**: Use `INDENT = None` for compact JSON output (smaller files)
- **Selective Years**: Modify `YEARS` list to convert only specific years

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `Python not found` | Install Python from python.org |
| `ModuleNotFoundError: pyarrow` | Run: `pip install -r requirements.txt` |
| `File not found` | Check folder structure (1d/, 4h/) |
| `Permission denied` | Run: `chmod +x convert.sh` |

## Example Output

```
================================================================================
BATCH PARQUET TO JSON CONVERTER
================================================================================
Output Format: JSON
Indent Level: 2
Timeframes: 1d, 4h
Years: 2020, 2021, 2022, 2023, 2024, 2025
================================================================================

Processing timeframe: 1D
----------------------------------------
  Converting 2020... (45.32 MB)
    → Output: json/1d/2020.json (156.78 MB, 3.5x)
  Converting 2021... (48.12 MB)
    → Output: json/1d/2021.json (178.45 MB, 3.7x)

Processing timeframe: 4H
----------------------------------------
  Converting 2020... (156.78 MB)
    → Output: json/4h/2020.json (512.34 MB, 3.3x)
  Converting 2021... (178.45 MB)
    → Output: json/4h/2021.json (587.92 MB, 3.3x)

================================================================================
CONVERSION SUMMARY
================================================================================
Total files processed: 4
Successful: 4
Failed: 0
Skipped: 0
Output directory: /path/to/Helper Scripts/json
================================================================================
```

## License

Open source - use freely

## Support

For issues or questions, check:
1. The `config.py` file for correct settings
2. Folder structure matches the expected layout
3. Python and PyArrow are properly installed
