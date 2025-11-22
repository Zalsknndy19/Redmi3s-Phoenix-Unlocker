
***

# Project Phoenix: Redmi 3s (Land) Unbrick & Unlock Bootloader Cracking Method via Android (No PC)

**Bahasa Indonesia:**
Proyek ini menyediakan metode untuk Unbrick (Mode EDL) dan Membuka Bootloader (Unlock Bootloader Cracking Method) Xiaomi Redmi 3s (Land) **hanya menggunakan HP Android lain yang sudah di-Root**. Tidak memerlukan PC/Laptop. Sangat berguna untuk perangkat darurat atau jika tidak memiliki akses ke komputer.

---

## ⚠️ Disclaimer / Peringatan

**Bahasa Indonesia:**
*   Proses ini melibatkan flashing partisi tingkat rendah. **Lakukan dengan risiko Anda sendiri.**
*   Data di Redmi 3s akan terhapus.
*   **HP Host (Alat) WAJIB Root.** Kita membutuhkan akses perangkat keras langsung melalui Termux.

## 🏆 Credits / Kredit

**Bahasa Indonesia:**
*   Terima kasih kepada **bkerler** untuk tool [edl](https://github.com/bkerler/edl) yang luar biasa.
*   Terima kasih khusus kepada [**fxsheep**](https://xdaforums.com/m/fxsheep.8302434/) untuk file bootloader modifikasi (File Ajaib 376KB). [XDA THREAD](https://xdaforums.com/t/redmi-3s-bootloader-cracking-method.3629496/)
*   [Magelang Flasher](https://www.magelangflasher.com/2017/06/cara-unlock-mi-account-atau-micloud-redmi-3s-dan-3x.html?m=1) untuk inspirasi pemetaan partisi.

---

## 🛠️ Preparation / Persiapan

### Hardware
1.  **Perangkat Host:** Ponsel Android dengan Akses Root (Magisk).
2.  **Perangkat Target:** Redmi 3s (Land) dalam Mode EDL (Layar hitam, 9008).
3.  **OTG Adapter + USB Cable.**

### Software (On Host Device)
1.  **Termux:** Download dan Instal dari F-Droid atau GitHub (Jangan menggunakan versi Playstore karena ada kemungkinan cara yang akan kita gunakan tidak berjalan sebagaimana mestinya). [Direct Link Termux F-Droid](https://f-droid.org/repo/com.termux_1022.apk)
2.  **Termux:API:** Download dan Instal dari F-Droid (Opsional tapi direkomendasikan). [Direct Link Termux:API F-Droid](https://f-droid.org/repo/com.termux.api_1002.apk)
3.  **RawBT:** Aplikasi Printer Bluetooth tapi sangat direkomendasikan untuk diinstal agar Host Device bisa mengetahui bahwa Redmi 3s Mode EDL telah terhubung dengan adanya pop-up QHUSB_BULK, tekan saja tombol "Batal" setelah pop-up tersebut muncul. [Direct Download RawBT.apk](files/RawBT.apk)

---

## 🚀 Step 1: Setup Environment / Menyiapkan Lingkungan

**Bahasa Indonesia:**
Buka Termux di HP Host. Kita perlu menginstal python dan dependensi sistem secara manual untuk menghindari error.

```bash

# Install dependencies / Instal dependensi
pkg update -y && pkg upgrade -y
pkg install git python python-dev build-essential clang libxml2 libxslt libsodium rust binutils libusb -y
```

---

## 📥 Step 2: Install EDL Tool / Instal Alat EDL

**Bahasa Indonesia:**
Kita akan meng-clone alat EDL dan menginstal kebutuhan python secara manual (melewati `pylzma` untuk menghindari error di Android).

```bash
# Clone Repo
git clone https://github.com/bkerler/edl
cd edl

# Install requirements manually / Instal kebutuhan manual
pip install wheel pyusb pyserial docopt pycryptodome lxml colorama requests passlib
```

---

## 📂 Step 3: The Magic Files / File Ajaib

**Bahasa Indonesia:**
Anda membutuhkan paket "Magic Unlock" (sekitar 376KB).
1.  Buat folder bernama `unlock_files` di dalam folder `edl`.
 tambahkan perintah disini.
2.  Kamu bisa mendownload file ajaib ini melalui link THREAD XDA diatas atau langsung menggunakan link ini yang mengambil langsung dari repository github ini. [unlock_redmi3s.7z](files/unlock_redmi3s.7z)
```bash
#Download file ajaib ini langsung ke folder edl di Termux
wget link github nanti ditambahkan kesini.
```
3.  Ekstrak file ajaib tersebut menggunakan perintah berikut.

**Structure / Struktur:**
```text
/data/data/com.termux/files/home/edl/
├── edl (python script)
├── unlock_files/
│   ├── prog_emmc_firehose_8937_ddr.mbn  (Loader)
│   ├── emmc_appsboot.mbn                (Patched Bootloader)
│   ├── gpt_both0.bin                    (Partition Table)
│   ├── recovery.img                     (Dummy/Stock Recovery)
│   ├── ... (other files/file lainnya)
```

---

## ⚡ Step 4: The Flashing Script / Skrip Flashing

**Bahasa Indonesia:**
Buat file bernama `flash_unlock.sh` di dalam folder `edl`. Skrip ini akan mengotomatiskan proses dengan aman.

`nano flash_unlock.sh`

```bash
#!/bin/sh

# ====================================================
# REDMI 3S UNLOCKER (ANDROID HOST)
# ====================================================

set -e # Hentikan skrip jika ada error

# Absolute Paths / Path Absolut
PYTHON_CMD="/data/data/com.termux/files/usr/bin/python"
EDL_SCRIPT="/data/data/com.termux/files/home/edl/edl"
UNLOCK_DIR="/data/data/com.termux/files/home/edl/unlock_files"
LOADER="${UNLOCK_DIR}/prog_emmc_firehose_8937_ddr.mbn"

echo "========================================="
echo " STARTING UNLOCK FLASHING "
echo " MEMULAI FLASH FILE UNLOCK "
echo "========================================="
echo "Ensure phone is in EDL Mode..."
echo "Pastikan HP dalam Mode EDL..."
sleep 5

# 1. Flash Partition Table (GPT)
echo ""
echo "[1/3] Flashing Partition Table (GPT)..."
$PYTHON_CMD $EDL_SCRIPT --loader=$LOADER w partition "${UNLOCK_DIR}/gpt_both0.bin"

# 2. Flash Patched Bootloader (The Key)
echo ""
echo "[2/3] Flashing Patched Bootloader..."
$PYTHON_CMD $EDL_SCRIPT --loader=$LOADER w aboot "${UNLOCK_DIR}/emmc_appsboot.mbn"

# 3. Flash Recovery
echo ""
echo "[3/3] Flashing Recovery..."
$PYTHON_CMD $EDL_SCRIPT --loader=$LOADER w recovery "${UNLOCK_DIR}/recovery.img"

# Done
echo ""
echo "========================================================"
echo " DONE! / SELESAI! "
echo "--------------------------------------------------------"
echo " PLEASE DISCONNECT CABLE AND REBOOT TO FASTBOOT MODE "
echo " SILAHKAN CABUT KABEL DAN REBOOT KE MODE FASTBOOT "
echo " (Hold Vol Down + Power / Tahan Vol Bawah + Power) "
echo "========================================================"

# Reset device (Often fails to reboot automatically, manual is better)
# Reset perangkat (Sering gagal reboot otomatis, manual lebih baik)
$PYTHON_CMD $EDL_SCRIPT --loader=$LOADER reset || echo "Reset command sent/Perintah reset dikirim."

exit 0
```

**Make executable / Jadikan bisa dieksekusi:**
```bash
chmod +x flash_unlock.sh
```

---

## 🔓 Step 5: Execution & Unlock / Eksekusi & Buka Kunci

**Bahasa Indonesia:**
1.  Hubungkan Redmi 3s dalam **Mode EDL**. Ada beberapa cara untuk masuk ke Mode EDL, 
{The first and easiest way to enter 9008 is to reboot your phone into fastboot ,then type 'fastboot oem edl'. If this way doesn't work ,try the second way.

Second way:A 'Xiaomi Deep Flash Cable' is needed.You could buy it or DIY it.(If you want to diy,just cut open a microusb cable,the you see four wires.Cut open the green one and the black one .Then screw together the four copper wire.)
(nanti saya sertakan gambarnya disini)
Fully shut your phone down and use the cable to connect Redmi 3s & host phone with otg. Nothing seemed to happen,but now your phone is under 9008. Then use a normal cable to connect. You will see a QHUSB-BULK pop-up from the RawBT app, just press "cancel" to continue.
(nanti saya sertakan screenshot realme 8i yang menampilkan pop-up tersebut disini)

Third way: (Not recommended) Open the back of the phone ,tear the shell on the main circuit board down.Then you will see two copper points . Use a wire or tweezer or pinset to connect them. Then hold on,use your second hand to connect a USB cable(normal,not deep flash cable).
(nanti saya sertakan gambar mesin Redmi 3s untuk letak test point nya)}
2.  Jalankan skrip dari shell Root.
3.  Setelah sukses, masuk ke Mode Fastboot secara manual.
4.  Jalankan perintah unlock.

**Commands / Perintah:**

```bash
# 1. Run Flashing Script / Jalankan Skrip Flash
su # Ketika ada pop-up permintaan izin root izinkan saja

cd /data/data/com.termux/files/home/edl
./flash_unlock.sh

# --- MANUAL REBOOT TO FASTBOOT NOW / REBOOT MANUAL KE FASTBOOT SEKARANG ---

# 2. Verify Fastboot / Verifikasi Fastboot
fastboot devices

# 3. UNLOCK BOOTLOADER!
fastboot oem unlock
```

**English:**
You should see `OKAY`. Congratulations, your Bootloader is now UNLOCKED!

**Bahasa Indonesia:**
Anda seharusnya melihat pesan `OKAY`. Selamat, Bootloader Anda sekarang SUDAH TERBUKA!

***

