#!/bin/sh

# ====================================================
# REDMI 3S UNLOCKER SCRIPT
# ====================================================

set -e

# Mendapatkan direktori tempat skrip ini berada, lalu naik satu level ke root repo
SCRIPT_DIR=$(dirname "$0")
REPO_ROOT="$SCRIPT_DIR/.."
EDL_DIR="$REPO_ROOT/edl"
UNLOCK_FILES="$EDL_DIR/unlock_files"

# Path Python Termux (Absolute)
PYTHON_CMD="/data/data/com.termux/files/usr/bin/python"
# Path EDL Script (Relative to repo)
EDL_SCRIPT_FILE="$EDL_DIR/edl"
# Path Loader
LOADER="$UNLOCK_FILES/prog_emmc_firehose_8937_ddr.mbn"

echo "========================================="
echo " STARTING UNLOCK FLASHING "
echo " MEMULAI FLASH FILE UNLOCK "
echo "========================================="

if [ ! -f "$LOADER" ]; then
    echo "ERROR: Loader not found at $LOADER"
    echo "Please check Step 3 (Extract Magic Files)!"
    exit 1
fi

echo "Ensure phone is in EDL Mode (Black Screen)..."
sleep 3

# Flashing
echo "[1/2] Flashing Patched Bootloader..."
$PYTHON_CMD "$EDL_SCRIPT_FILE" --loader="$LOADER" w aboot "$UNLOCK_FILES/emmc_appsboot.mbn"

echo "[2/2] Flashing Recovery..."
$PYTHON_CMD "$EDL_SCRIPT_FILE" --loader="$LOADER" w recovery "$UNLOCK_FILES/recovery.img"

# Reset
echo "========================================="
echo " DONE! SELESAI! "
echo "========================================="

$PYTHON_CMD "$EDL_SCRIPT_FILE" --loader="$LOADER" reset || true