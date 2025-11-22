# Project Phoenix: Redmi 3s (Land) Unbrick & Unlock Bootloader via Android (No PC)

**[Bahasa Indonesia]**

Proyek ini menyediakan metode untuk Unbrick (Mode EDL) dan Membuka Bootloader (Unlock Bootloader) Xiaomi Redmi 3s (Land) **hanya menggunakan HP Android lain yang sudah di-Root**. Tidak memerlukan PC/Laptop. Sangat berguna untuk situasi darurat atau jika tidak memiliki akses ke komputer.

**[English]**

This project provides a method to Unbrick (EDL Mode) and Unlock the Bootloader of Xiaomi Redmi 3s (Land) using **only another Rooted Android phone** as the host. No PC is required. This is useful for emergency situations or if you don't have access to a computer.

---

## ⚠️ Disclaimer / Peringatan
**[Bahasa Indonesia]**

*   **Lakukan dengan risiko Anda sendiri.** Proses ini melibatkan flashing partisi tingkat rendah.
*   **Data Anda akan terhapus.**
*   **HP Host (Alat) WAJIB Root.** Kita membutuhkan akses perangkat keras langsung melalui Termux.

**[English]**

*   **Do this at your own risk.** This process involves flashing low-level partitions.
*   **Your data will be wiped.**
*   **Host Device MUST be Rooted.** We need direct hardware access via Termux (`su`).

## 🏆 Credits / Kredit

*   Tool: **bkerler** for [`edl`](https://github.com/bkerler/edl).
*   ADB & Fastboot for Android NDK: **osm0sis & Surge1223 @ xda-developers** for powerful `ADB & Fastboot Android` tool. [Github Repo](https://github.com/Magisk-Modules-Repo/adb-ndk)
*   Magic File / File Ajaib: **fxsheep** for `unlock_redmi3s.7z` on XDA Developers. [Original Thread](https://xdaforums.com/t/redmi-3s-bootloader-cracking-method.3629496/)
*   Partition Logic: **Magelang Flasher** for `partition mapping inspiration`. [Documentation](https://www.magelangflasher.com/2017/06/cara-unlock-mi-account-atau-micloud-redmi-3s-dan-3x.html?m=1)

---

## 🛠️ Preparation / Persiapan

### Hardware
1.  **Host Device / Perangkat Host:** Ponsel Android dengan Akses Root (Magisk).

    Android Phone with Root Access (Magisk).

2.  **Target Device / Perangkat Target:** Redmi 3s (Land).
3.  **OTG Adapter + USB Cable.**

### Software (On Host Device)
1.  **Termux :** Instal dari F-Droid (JANGAN gunakan versi Play Store).

    Install from F-Droid (Do NOT use Play Store version).
    [Download Termux](https://f-droid.org/repo/com.termux_1022.apk)
2.  **Termux:API :**  (Opsional tapi direkomendasikan)

    (Optional but recommended)
    [Download Termux:API](https://f-droid.org/repo/com.termux.api_1002.apk)
3.  **RawBT :** Aplikasi Printer Bluetooth, digunakan sebagai trik untuk mendeteksi apakah perangkat EDL terhubung (Pop-up "QHSUSB_BULK).

    A Bluetooth Printer app, used as a trick to detect if EDL device is connected (Pop-up "QHSUSB_BULK").
    [Download RawBT](https://raw.githubusercontent.com/Zalsknndy19/Files-for-Redmi3s-Phoenix-Unlocker/refs/heads/master/files/RawBT.apk)
4.  **ADB & Fastboot for Android NDK:** Dikarenakan alat adb & fastboot yang disediakan Termux seringkali mengalami disconnect setelah beberapa saat, maka kita memerlukan alat ADB & Fastboot yang powerful dengan akses root. 

    Because the adb & fastboot tools provided by Termux often disconnect after a while, we need a powerful ADB & Fastboot tool with root access.
    [Download ADB & Fastboot for Android NDK](https://raw.githubusercontent.com/Zalsknndy19/Files-for-Redmi3s-Phoenix-Unlocker/refs/heads/master/files/adb_fastboot_magisk.zip)

---

## 🚀 Step 1: Setup Environment / Menyiapkan Lingkungan

**[Bahasa Indonesia]**

Instal terlebih dahulu aplikasi **RawBT.apk** yang telah diunduh, setelah itu instal juga modul Magisk **ADB & Fastboot for Android NDK** melalui aplikasi Magisk lalu reboot ponsel.
Kemudian buka Termux di HP Host. Jalankan perintah ini sebagai **User Biasa** (jangan masuk `su` dulu) untuk menginstal dependensi.

**[English]**

First install the downloaded **RawBT.apk** application, after that also install the Magisk module **ADB & Fastboot for Android NDK** via the Magisk application then reboot the phone.
Then open Termux on Host. Run these commands as **Standard User** (do not use `su` yet) to install dependencies.

```bash
# 1. Update repositories / Update repositori
pkg update -y && pkg upgrade -y

# 2. Install Python & System Tools / Instal Python & Alat Sistem
pkg install git python python-dev build-essential clang libxml2 libxslt libsodium rust binutils libusb p7zip tree -y
```

---

## 📥 Step 2: Clone Repository / Clone Repositori

**[Bahasa Indonesia]**

Kita akan mendownload tool ini (Redmi3s-Phoenix-Unlocker) dan tool EDL ke dalam Termux.

**[English]**

We will download this tool (Redmi3s-Phoenix-Unlocker) and the EDL tool into Termux.

```bash
# 1. Clone this repository / Clone repo ini
git clone https://github.com/Zalsknndy19/Redmi3s-Phoenix-Unlocker.git
cd Redmi3s-Phoenix-Unlocker

# 2. Clone EDL Tool / Clone Tool EDL
git clone https://github.com/bkerler/edl
cd edl

# 3. Install Python Requirements / Instal Kebutuhan Python
# We skip pylzma/docopt/serial issues by installing specific packages
# Kita menghindari masalah pylzma dengan instalasi manual
pip install wheel pyusb pyserial docopt pycryptodome lxml colorama requests passlib
```

---

## 📂 Step 3: The Magic Files / File Ajaib

**[Bahasa Indonesia]**

Anda membutuhkan file "Magic Unlock" (376KB). Karena alasan hak cipta, silakan unduh dari link eksternal di bawah, lalu pindahkan ke folder proyek.

**[English]**

You need the "Magic Unlock" file (376KB). Due to copyright, please download from the external link below, then move it to the project folder.

1.  **Download:** [unlock_redmi3s.7z](https://drive.google.com/file/d/1vrQbntqt4Kf2VoPr9TEP36ge1piT59F4/view?usp=drive_link)
2.  **Move & Extract:** 
    Pindahkan file ke folder Termux.
    Move the file to the Termux folder.

```bash
# Contoh jika file ada di folder Download Internal
# Example if file is in Internal Download folder

# Buat dulu folder Proyek
# Create project folder first
mkdir -p ~/Redmi3s-Phoenix-Unlocker/edl/unlock_files

# Copy file (Allow Termux Storage permission first if needed: termux-setup-storage)
# Salin file (Izinkan permintaan penyimpanan Termux terlebih dahulu jika diperlukan: termux-setup-storage)
cp /sdcard/Download/unlock_redmi3s.7z ~/Redmi3s-Phoenix-Unlocker/edl/unlock_files/

# Extract (Install p7zip if needed: pkg install p7zip)
cd ~/Redmi3s-Phoenix-Unlocker/edl/unlock_files/
7z e unlock_redmi3s.7z
```

**Structure Check using 'tree' command / Cek Struktur menggunakan perintah 'tree':**
```text
~/Redmi3s-Phoenix-Unlocker/edl/unlock_files/
├── emmc_appsboot.mbn
├── gpt_backup0.bin
├── gpt_both0.bin
├── gpt_main0.bin
├── patch0.xml
├── prog_emmc_firehose_8937_ddr.mbn
├── rawprogram0.xml
├── recovery.img
├── unlock
└── unlock_redmi3s.7z
```

---

## 🔌 Step 4: Enter EDL Mode / Masuk Mode EDL

**[Bahasa Indonesia]**

Hubungkan Redmi 3s ke HP Host menggunakan OTG. Jika muncul pop-up dari **RawBT** (QHSUSB__BULK), tekan **BATAL**. Itu tandanya HP terdeteksi.
![pop-up_QHSUSB__BULK](https://raw.githubusercontent.com/Zalsknndy19/Files-for-Redmi3s-Phoenix-Unlocker/refs/heads/master/images/pop-up_QHSUSB__BULK.jpg)

Pilih salah satu cara masuk EDL:

1.  **Perintah Fastboot (Hanya jika UBL)**
    *   Masuk Fastboot (Vol Bawah + Power).
    *   Ketik: `fastboot oem edl`
    *   *Note: Cara ini sering GAGAL jika Bootloader terkunci.*

2.  **Deep Flash Cable (DFC)**
    *   Anda bisa menggunakan Kabel DFC yang dibeli dari e-commerce.
    ![Purchased_DFC_Cable](https://raw.githubusercontent.com/Zalsknndy19/Files-for-Redmi3s-Phoenix-Unlocker/refs/heads/master/images/Purchased_DFC_Cable.jpg)
    *   Atau menggunakan kabel modifikasi (kabel data yang kabel hijau & hitamnya dikonsletkan/digabung).
    ![DIY_DFC_Cable](https://raw.githubusercontent.com/Zalsknndy19/Files-for-Redmi3s-Phoenix-Unlocker/refs/heads/master/images/DIY_DFC_Cable.jpg)
    *   Matikan HP, colok kabel DFC ke Host+OTG.
    *   Tunggu 5 detik, lepaskan konsletan kabel hijau-hitam.

3.  **Test Point (Pasti Berhasil)**
    *   Buka casing belakang Redmi 3s dan buka penutup board mesin bagian atas.
    *   Cabut soket baterai.
    *   Hubungkan dua titik **Test Point** menggunakan pinset/kawat.
    ![Redmi_3s_test_point](https://raw.githubusercontent.com/Zalsknndy19/Files-for-Redmi3s-Phoenix-Unlocker/refs/heads/master/images/Redmi_3s_test_point.jpg)
    *   Sambil menahan pinset, colokkan kabel USB (gunakan kabel USB normal bukan yang telah dimodifikasi sebagai kabel DFC.

**[English]**

Connect the Redmi 3s to the host phone using OTG. If a pop-up appears from **RawBT** (QHSUSB__BULK), press **CANCEL**. This indicates the phone has been detected.
![pop-up_QHSUSB__BULK](https://raw.githubusercontent.com/Zalsknndy19/Files-for-Redmi3s-Phoenix-Unlocker/refs/heads/master/images/pop-up_QHSUSB__BULK_en.jpg)

Select one of the EDL entry methods:

1.  **Fastboot Commands (Only if UBL)**
    *   Enter Fastboot (Volume Down + Power).
    *   Type: `fastboot oem edl`
    *   *Note: This method often FAILS if the Bootloader is locked.*

2.  **Deep Flash Cable (DFC)**
    *   You can use DFC Cable purchased from e-commerce.
    ![Purchased_DFC_Cable](https://raw.githubusercontent.com/Zalsknndy19/Files-for-Redmi3s-Phoenix-Unlocker/refs/heads/master/images/Purchased_DFC_Cable.jpg)
    *   Or use a modified cable (a data cable with the green and black cables shorted/combined).
    ![DIY_DFC_Cable](https://raw.githubusercontent.com/Zalsknndy19/Files-for-Redmi3s-Phoenix-Unlocker/refs/heads/master/images/DIY_DFC_Cable.jpg)
    *   Turn off the phone, plug the DFC cable into the Host+OTG.
    *   Wait 5 seconds, remove the green-black wire short circuit.

3.  **Test Point (Guaranteed Success)**
    *   Open the back casing of the Redmi 3s and open the top main board cover.
    *   Unplug the battery socket.
    *   Connect the two **Test Point** points using tweezers/wire.
    ![Redmi_3s_test_point](https://raw.githubusercontent.com/Zalsknndy19/Files-for-Redmi3s-Phoenix-Unlocker/refs/heads/master/images/Redmi_3s_test_point.jpg)
    *   While holding the tweezers, plug in the USB cable (use a normal USB cable not one that has been modified as a DFC cable.

---

## ⚡ Step 5: Execute Unlock / Eksekusi Unlock

**[Bahasa Indonesia]**

Sekarang kita akan menjalankan skrip otomatis.

**PENTING:** Di langkah ini, kita **WAJIB** menggunakan akses **ROOT**.

**[English]**

Now we run the automated script.

**IMPORTANT:** In this step, we **MUST** use **ROOT** access.

```bash
# 1. Enter Root Mode / Masuk Mode Root
su

# 2. Go to Script Folder / Masuk Folder Skrip
cd /data/data/com.termux/files/home/Redmi3s-Phoenix-Unlocker

# 3. Give Permission / Beri Izin Eksekusi
chmod +x scripts/flash_unlock.sh

# 4. RUN THE SCRIPT! / JALANKAN SKRIP!
./scripts/flash_unlock.sh
```

---

## 🔓 Step 6: Finalize Unlocking Bootloader / Penyelesaian Unlock Bootloader

**[Bahasa Indonesia]**

Jika skrip menampilkan "SELESAI", HP Anda sekarang memiliki Bootloader yang sudah di-patch.

1.  Cabut kabel USB.
2.  Pasang soket baterai (jika tadi dicabut).
3.  Masuk ke **Mode Fastboot** manual (Tahan **Volume Bawah + Power**).
4.  Hubungkan kembali ke HP Host.
5.  Jalankan perintah unlock di Termux (Root):

**[English]**

If the script displays "DONE", your phone now has a patched Bootloader.

1.  Unplug the USB cable.
2.  Plug in the battery socket (if it was removed).
3.  Enter **Fastboot Mode** manually (Hold **Volume Down + Power**).
4.  Reconnect to the Host Device.
5.  Run the unlock command in Termux (Root):

```bash
fastboot devices
fastboot oem unlock
```

**Result / Hasil:**

**[Bahasa Indonesia]**

Anda seharusnya melihat pesan `OKAY`. Selamat, Bootloader Anda sekarang SUDAH TERBUKA!

**[English]**

You should see `OKAY`. Congratulations, your Bootloader is now UNLOCKED!

---