"""
Configuration file for Parquet to JSON converter
Edit these settings to customize the conversion process
"""

# ============================================================================
# CONVERSION SETTINGS
# ============================================================================

# Output format:
# - "ndjson": One JSON object per line (memory efficient, good for large files)
# - "json": Pretty-printed JSON array (human readable, larger file size)
OUTPUT_FORMAT = "json"

# Pretty print indentation (only used with OUTPUT_FORMAT="json")
# Set to None for compact output, or use 2 or 4 for readable indentation
INDENT = 2

# Batch size for streaming conversion (rows processed per iteration)
# Larger values use more memory but may be faster
BATCH_SIZE = 64_000

# ============================================================================
# FOLDER STRUCTURE SETTINGS
# ============================================================================

# Timeframes to process
TIMEFRAMES = ["1d", "4h"]

# Years to process (add or remove as needed)
YEARS = [2020, 2021, 2022, 2023, 2024]

# Input folder structure: source/{timeframe}/{year}.parquet
INPUT_BASE_DIR = "."

# Output folder structure: json/{timeframe}/{year}.json
OUTPUT_BASE_DIR = "json"

# ============================================================================
# LOGGING SETTINGS
# ============================================================================

# Verbose output
VERBOSE = True

# ============================================================================
# IMPORTANT NOTES
# ============================================================================
"""
FOLDER STRUCTURE EXPECTED:
├── 1d/
│   ├── 2020.parquet
│   ├── 2021.parquet
│   └── ...
├── 4h/
│   ├── 2020.parquet
│   ├── 2021.parquet
│   └── ...
└── config.py

OUTPUT STRUCTURE CREATED:
├── json/
│   ├── 1d/
│   │   ├── 2020.json
│   │   ├── 2021.json
│   │   └── ...
│   └── 4h/
│       ├── 2020.json
│       ├── 2021.json
│       └── ...
"""
