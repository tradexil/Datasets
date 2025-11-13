#!/usr/bin/env python3
"""
Batch Parquet to JSON Converter
Converts parquet files from multiple timeframes and years into formatted JSON files
"""

import sys
import os
import json
from pathlib import Path
from typing import Optional
import pyarrow.parquet as pq

# Import configuration
try:
    from config import (
        OUTPUT_FORMAT, INDENT, BATCH_SIZE, TIMEFRAMES, YEARS,
        INPUT_BASE_DIR, OUTPUT_BASE_DIR, VERBOSE
    )
except ImportError:
    print("ERROR: config.py not found in the same directory!")
    sys.exit(1)


def log(message: str, verbose_only: bool = False):
    """Print message if verbose is enabled or if it's an important message"""
    if not verbose_only or VERBOSE:
        print(message)


def convert_parquet_to_json(
    input_path: str,
    output_path: str,
    format_type: str = "json",
    batch_size: int = 64_000,
    indent: Optional[int] = None
) -> bool:
    """
    Stream-convert a Parquet file to JSON.
    
    Args:
        input_path: Path to input parquet file
        output_path: Path to output JSON file
        format_type: "json" for array or "ndjson" for newline-delimited
        batch_size: Number of rows to process per iteration
        indent: Indentation level for pretty-printing (None for compact)
    
    Returns:
        True if successful, False otherwise
    """
    try:
        pf = pq.ParquetFile(input_path)
        total_rows = pf.metadata.num_rows
        
        def to_json_str(obj):
            return json.dumps(obj, ensure_ascii=False, indent=indent, default=str)
        
        processed = 0
        with open(output_path, "w", encoding="utf-8") as out:
            if format_type == "ndjson":
                # One JSON object per line
                for batch in pf.iter_batches(batch_size=batch_size):
                    for rec in batch.to_pylist():
                        out.write(to_json_str(rec))
                        out.write("\n")
                        processed += 1
            else:
                # JSON array format
                out.write("[\n")
                first = True
                for batch in pf.iter_batches(batch_size=batch_size):
                    for rec in batch.to_pylist():
                        if not first:
                            out.write(",\n")
                        out.write(to_json_str(rec))
                        first = False
                        processed += 1
                out.write("\n]\n")
        
        log(f"Converted {processed:,} rows to {output_path}", verbose_only=True)
        return True
        
    except Exception as e:
        log(f"Error converting {input_path}: {e}")
        return False


def batch_convert_all():
    """Convert all configured timeframes and years"""
    
    log("=" * 80)
    log("BATCH PARQUET TO JSON CONVERTER")
    log("=" * 80)
    log(f"Output Format: {OUTPUT_FORMAT.upper()}")
    log(f"Indent Level: {INDENT}")
    log(f"Timeframes: {', '.join(TIMEFRAMES)}")
    log(f"Years: {', '.join(map(str, YEARS))}")
    log("=" * 80)
    
    # Create output base directory
    output_dir = Path(OUTPUT_BASE_DIR)
    output_dir.mkdir(parents=True, exist_ok=True)
    
    total_files = 0
    successful = 0
    failed = 0
    skipped = 0
    
    for timeframe in TIMEFRAMES:
        # Create timeframe subdirectory
        timeframe_output_dir = output_dir / timeframe
        timeframe_output_dir.mkdir(parents=True, exist_ok=True)
        
        log(f"\nProcessing timeframe: {timeframe.upper()}")
        log("-" * 40)
        
        for year in YEARS:
            total_files += 1
            input_file = Path(INPUT_BASE_DIR) / timeframe / f"{year}.parquet"
            output_file = timeframe_output_dir / f"{year}.json"
            
            if not input_file.exists():
                log(f"⊘ Skipped {year}: {input_file} not found", verbose_only=True)
                skipped += 1
                continue
            
            input_size_mb = input_file.stat().st_size / (1024 * 1024)
            log(f"  Converting {year}... ({input_size_mb:.2f} MB)", verbose_only=True)
            
            if convert_parquet_to_json(
                str(input_file),
                str(output_file),
                format_type=OUTPUT_FORMAT,
                batch_size=BATCH_SIZE,
                indent=INDENT
            ):
                output_size_mb = output_file.stat().st_size / (1024 * 1024)
                size_ratio = output_size_mb / input_size_mb if input_size_mb > 0 else 0
                log(f"    → Output: {output_file} ({output_size_mb:.2f} MB, {size_ratio:.1f}x)", verbose_only=True)
                successful += 1
            else:
                failed += 1
    
    # Print summary
    log("\n" + "=" * 80)
    log("CONVERSION SUMMARY")
    log("=" * 80)
    log(f"Total files processed: {total_files}")
    log(f"Successful: {successful}")
    log(f"Failed: {failed}")
    log(f"Skipped: {skipped}")
    log(f"Output directory: {Path(OUTPUT_BASE_DIR).absolute()}")
    log("=" * 80)
    
    return failed == 0


if __name__ == "__main__":
    success = batch_convert_all()
    sys.exit(0 if success else 1)
