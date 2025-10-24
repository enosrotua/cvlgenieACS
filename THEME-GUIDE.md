# 🎨 **GENIEACS THEME CHANGER**

## 🌟 **Fitur Theme Changer**

Script `change-theme.sh` memungkinkan Anda mengubah warna background dan tema GenieACS dengan mudah, termasuk tema gelap seperti di foto atau warna custom sesuai keinginan.

## 🎯 **Tema yang Tersedia**

### 1. **Dark Theme (Seperti di Foto)**
- **Background**: Biru tua (#1a252f)
- **Header**: Biru abu-abu (#2c3e50)
- **Accent**: Biru terang (#3498db)
- **Text**: Putih/abu-abu terang
- **Style**: Modern dark mode

### 2. **Custom Color Themes**
- **Biru Tua**: #1a252f
- **Hijau Tua**: #1a2f1a
- **Merah Tua**: #2f1a1a
- **Ungu Tua**: #2a1a2f
- **Abu-abu Tua**: #2a2a2a
- **Custom Hex**: Warna bebas

### 3. **Original Theme**
- Tema asli GenieACS
- Background terang
- Warna standar

## 🛠️ **Cara Menggunakan**

### **Metode 1: Script Interaktif (Recommended)**
```bash
cd /root/cvlgenieACS
bash change-theme.sh
```

Menu yang tersedia:
1. ✅ Apply Dark Theme (seperti di foto)
2. ✅ Apply Custom Color Theme
3. ✅ Restore Original Theme
4. ✅ View Current Theme Info
5. ✅ Exit

### **Metode 2: Langsung Apply Dark Theme**
```bash
# Backup CSS saat ini
cp /usr/lib/node_modules/genieacs/public/app-LU66VFYW.css /root/css-backup.css

# Apply dark theme
bash change-theme.sh
# Pilih opsi 1
```

### **Metode 3: Custom Color**
```bash
bash change-theme.sh
# Pilih opsi 2
# Pilih warna atau masukkan hex color custom
```

## 📍 **Lokasi File CSS**

### **File CSS Aktif:**
```bash
/usr/lib/node_modules/genieacs/public/app-LU66VFYW.css
```

### **Backup Files:**
```bash
/usr/lib/node_modules/genieacs/public/app-LU66VFYW.css.backup
/root/cvlgenieACS/css-backup-TIMESTAMP/
```

## 🎨 **Komponen yang Diubah**

### **Dark Theme Components:**
- ✅ **Body Background**: Warna latar belakang utama
- ✅ **Header**: Bar navigasi atas
- ✅ **Navigation**: Menu navigasi
- ✅ **Tables**: Tabel data devices
- ✅ **Forms**: Input fields dan buttons
- ✅ **Overlays**: Modal dan popup
- ✅ **CodeMirror**: Editor kode
- ✅ **Links**: Warna link dan hover
- ✅ **Status Indicators**: Indikator status

### **CSS Variables yang Dimodifikasi:**
```css
:root {
    --color1: #2c3e50;    /* Borders */
    --color2: #34495e;    /* Secondary */
    --color3: #3a4a5c;    /* Hover */
    --color4: #3498db;    /* Accent */
    --color5: #1a252f;    /* Primary */
}
```

## 🔧 **Manual Theme Modification**

### **Ubah Warna Background Manual:**
```bash
# Edit CSS file
nano /usr/lib/node_modules/genieacs/public/app-LU66VFYW.css

# Tambahkan di akhir file:
body {
    background-color: #YOUR_COLOR !important;
}

# Restart GenieACS
systemctl restart genieacs-ui
```

### **Ubah Warna Header Manual:**
```bash
# Tambahkan di CSS:
#header {
    background-color: #YOUR_COLOR !important;
}
```

## 🔍 **Verifikasi Theme**

### **Cek Theme Aktif:**
```bash
# Lihat file CSS
ls -la /usr/lib/node_modules/genieacs/public/app-LU66VFYW.css

# Cek ukuran file
du -h /usr/lib/node_modules/genieacs/public/app-LU66VFYW.css

# Cek backup
ls -la /usr/lib/node_modules/genieacs/public/app-LU66VFYW.css.backup
```

### **Test di Browser:**
1. Buka GenieACS UI: `http://YOUR_IP:3000`
2. Hard refresh: `Ctrl + F5` atau `Cmd + Shift + R`
3. Periksa perubahan warna background

## 🛠️ **Troubleshooting**

### **Theme Tidak Berubah:**
```bash
# 1. Cek file CSS
ls -la /usr/lib/node_modules/genieacs/public/app-LU66VFYW.css

# 2. Restart GenieACS UI
systemctl restart genieacs-ui

# 3. Clear browser cache
# Hard refresh: Ctrl + F5
```

### **Theme Rusak/Error:**
```bash
# Restore dari backup
bash change-theme.sh
# Pilih opsi 3 (Restore Original Theme)
```

### **File CSS Tidak Valid:**
```bash
# Restore dari backup otomatis
cp /usr/lib/node_modules/genieacs/public/app-LU66VFYW.css.backup /usr/lib/node_modules/genieacs/public/app-LU66VFYW.css
systemctl restart genieacs-ui
```

## 📁 **Struktur File Theme**

```
/root/cvlgenieACS/
├── change-theme.sh              # Script theme changer
├── css-backup-TIMESTAMP/        # Backup directories
│   └── app-LU66VFYW.css
└── THEME-GUIDE.md              # Dokumentasi ini

/usr/lib/node_modules/genieacs/public/
├── app-LU66VFYW.css            # CSS aktif
├── app-LU66VFYW.css.backup     # Backup otomatis
└── app.css                     # CSS original
```

## 🎨 **Tips Desain Theme**

### **Warna yang Direkomendasikan:**
1. **Dark Theme**: #1a252f (seperti di foto)
2. **Professional**: #2c3e50
3. **Modern**: #34495e
4. **Elegant**: #2a2a2a

### **Kombinasi Warna yang Baik:**
- **Primary**: Warna gelap (#1a252f)
- **Secondary**: Warna sedang (#2c3e50)
- **Accent**: Warna terang (#3498db)
- **Text**: Putih/abu-abu terang (#ecf0f1)

### **Prinsip Desain:**
1. **Kontras Tinggi** untuk readability
2. **Konsistensi Warna** di semua komponen
3. **Accessibility** untuk pengguna dengan gangguan penglihatan
4. **Professional Look** untuk tampilan bisnis

## 🔄 **Backup & Restore**

### **Automatic Backup:**
- Script otomatis membuat backup sebelum mengubah theme
- Backup tersimpan dengan timestamp
- Dapat di-restore kapan saja

### **Manual Backup:**
```bash
# Backup manual
cp /usr/lib/node_modules/genieacs/public/app-LU66VFYW.css /root/my-theme-backup.css

# Restore manual
cp /root/my-theme-backup.css /usr/lib/node_modules/genieacs/public/app-LU66VFYW.css
systemctl restart genieacs-ui
```

## 📞 **Support**

Jika mengalami masalah dengan theme:
- **WhatsApp**: [081947215703](https://wa.me/6281947215703)
- **Telegram**: [@alijayaNetAcs](https://t.me/alijayaNetAcs)

## 🚀 **Quick Start**

```bash
# 1. Clone repository
git clone https://github.com/enosrotua/cvlgenieACS
cd cvlgenieACS

# 2. Install GenieACS dengan dark theme
bash darkmode.sh

# 3. Ubah theme sesuai keinginan
bash change-theme.sh

# 4. Akses GenieACS
# URL: http://YOUR_IP:3000
```

---

**💡 Tips**: Gunakan script `change-theme.sh` untuk mengubah tema dengan mudah dan aman! Theme akan otomatis ter-backup sebelum diubah.
