#!/bin/sh

# ====================================================
# REDMI 3S UNLOCKER SCRIPT
# ====================================================

set -e

# Setup Paths / Pengaturan Path
SCRIPT_DIR=$(dirname "$0")
REPO_ROOT="$SCRIPT_DIR/.."
EDL_DIR="$REPO_ROOT/edl"
UNLOCK_FILES="$EDL_DIR/unlock_files"

# Absolute path to Python in Termux
PYTHON_CMD="/data/data/com.termux/files/usr/bin/python"
# Relative path to EDL script
EDL_SCRIPT_FILE="$EDL_DIR/edl"
# Target Loader
LOADER="$UNLOCK_FILES/prog_emmc_firehose_8937_ddr.mbn"

echo "========================================="
echo " STARTING UNLOCK FLASHING "
echo " MEMULAI FLASH FILE UNLOCK "
echo "========================================="

# Safety Check / Cek Keamanan
if [ ! -f "$LOADER" ]; then
    echo "ERROR: Loader not found at $LOADER"
    echo "Please check Step 3 in README (Extract Magic Files)!"
    echo "Silakan cek Langkah 3 di README (Ekstrak File Ajaib)!"
    exit 1
fi

echo "Ensure phone is in EDL Mode (Black Screen)..."
echo "Pastikan HP dalam mode EDL (Layar Hitam)..."
sleep 3

# 1. Flash Bootloader (Modified/Patched)
echo ""
echo "[1/2] Flashing Patched Bootloader (aboot)..."
$PYTHON_CMD "$EDL_SCRIPT_FILE" --loader="$LOADER" w aboot "$UNLOCK_FILES/emmc_appsboot.mbn"

# 2. Flash Recovery (Dummy/Stock)
echo ""
echo "[2/2] Flashing Recovery with dummy file..."
$PYTHON_CMD "$EDL_SCRIPT_FILE" --loader="$LOADER" w recovery "$UNLOCK_FILES/recovery.img"

# Done
echo ""
echo "========================================="
echo " DONE! SELESAI! "
echo "========================================="
echo " 1. Unplug USB / Cabut USB"
echo " 2. Reconnect Battery / Pasang Baterai"
echo " 3. Hold Vol Down + Power -> FASTBOOT"
echo "========================================="

# No reset command, to force manual entry to Fastboot
# Tidak ada perintah reset, agar user masuk manual ke Fastboot