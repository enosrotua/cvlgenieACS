# 📍 **LOKASI LOGO GENIEACS**

## 🎯 **Lokasi File Logo**

### 1. **Repository Logo (Template)**
```bash
/root/cvlgenieACS/logo.svg
/root/cvlgenieACS/logo-3976e73d.svg
```
- **Fungsi**: Template logo yang akan digunakan saat instalasi
- **Format**: SVG (Scalable Vector Graphics)
- **Ukuran**: ~66KB

### 2. **GenieACS Active Logo (Yang Digunakan)**
```bash
/usr/lib/node_modules/genieacs/public/logo.svg
/usr/lib/node_modules/genieacs/public/logo-3976e73d.svg
```
- **Fungsi**: Logo yang aktif digunakan oleh GenieACS UI
- **Format**: SVG
- **Akses**: Melalui browser di `http://YOUR_IP:3000`

## 🔧 **Cara Mengganti Logo**

### **Metode 1: Menggunakan Script Otomatis (Recommended)**
```bash
cd /root/cvlgenieACS
bash change-logo.sh
```

Script ini akan memberikan menu:
1. ✅ Ganti logo dengan file dari repository
2. ✅ Ganti logo dengan file custom
3. ✅ Restore logo dari backup
4. ✅ Lihat informasi logo saat ini
5. ✅ Keluar

### **Metode 2: Manual Replacement**
```bash
# 1. Backup logo saat ini
cp /usr/lib/node_modules/genieacs/public/logo.svg /root/logo-backup.svg

# 2. Ganti dengan logo baru
cp /path/to/your/new-logo.svg /usr/lib/node_modules/genieacs/public/logo.svg
cp /path/to/your/new-logo.svg /usr/lib/node_modules/genieacs/public/logo-3976e73d.svg

# 3. Set permissions
chown root:root /usr/lib/node_modules/genieacs/public/logo.svg
chown root:root /usr/lib/node_modules/genieacs/public/logo-3976e73d.svg

# 4. Restart GenieACS UI
systemctl restart genieacs-ui
```

### **Metode 3: Update Repository Template**
```bash
# 1. Ganti logo di repository
cp /path/to/your/new-logo.svg /root/cvlgenieACS/logo.svg
cp /path/to/your/new-logo.svg /root/cvlgenieACS/logo-3976e73d.svg

# 2. Jalankan instalasi ulang untuk menerapkan logo baru
bash darkmode.sh
```

## 📋 **Persyaratan Logo**

### **Format yang Didukung:**
- ✅ **SVG** (Recommended) - Scalable Vector Graphics
- ✅ **PNG** - Portable Network Graphics
- ✅ **JPG/JPEG** - Joint Photographic Experts Group

### **Spesifikasi Optimal:**
- **Format**: SVG (untuk kualitas terbaik)
- **Ukuran**: Maksimal 100KB
- **Dimensi**: 200x60 pixels (rasio 3.33:1)
- **Background**: Transparent atau sesuai tema

## 🔍 **Verifikasi Logo**

### **Cek Logo Aktif:**
```bash
# Lihat file logo yang aktif
ls -la /usr/lib/node_modules/genieacs/public/logo*.svg

# Cek ukuran file
du -h /usr/lib/node_modules/genieacs/public/logo*.svg

# Cek permissions
ls -la /usr/lib/node_modules/genieacs/public/logo*.svg
```

### **Test di Browser:**
1. Buka GenieACS UI: `http://YOUR_IP:3000`
2. Hard refresh: `Ctrl + F5` atau `Cmd + Shift + R`
3. Logo akan muncul di pojok kiri atas

## 🛠️ **Troubleshooting**

### **Logo Tidak Muncul:**
```bash
# 1. Cek file logo
ls -la /usr/lib/node_modules/genieacs/public/logo*.svg

# 2. Cek permissions
chown root:root /usr/lib/node_modules/genieacs/public/logo*.svg

# 3. Restart GenieACS UI
systemctl restart genieacs-ui

# 4. Clear browser cache
# Hard refresh: Ctrl + F5
```

### **Logo Rusak/Error:**
```bash
# Restore dari backup
bash change-logo.sh
# Pilih opsi 3 (Restore logo dari backup)
```

### **File Logo Tidak Valid:**
```bash
# Cek format file
file /path/to/logo.svg

# Cek isi file SVG
head -5 /path/to/logo.svg
```

## 📁 **Struktur File Logo**

```
/root/cvlgenieACS/
├── logo.svg                    # Template logo untuk instalasi
├── logo-3976e73d.svg          # Template logo dengan hash
├── change-logo.sh             # Script untuk ganti logo
└── logo-backup-*/             # Backup directories
    ├── logo.svg
    └── logo-3976e73d.svg

/usr/lib/node_modules/genieacs/public/
├── logo.svg                   # Logo aktif (utama)
├── logo-3976e73d.svg         # Logo aktif (dengan hash)
└── favicon.png               # Favicon browser
```

## 🎨 **Tips Desain Logo**

1. **Gunakan Format SVG** untuk kualitas terbaik
2. **Background Transparent** untuk fleksibilitas tema
3. **Ukuran Optimal** 200x60 pixels
4. **Warna Kontras** dengan background tema
5. **Simple Design** untuk tampilan yang clean

## 📞 **Support**

Jika mengalami masalah dengan logo:
- **WhatsApp**: [081947215703](https://wa.me/6281947215703)
- **Telegram**: [@alijayaNetAcs](https://t.me/alijayaNetAcs)

---

**💡 Tips**: Gunakan script `change-logo.sh` untuk mengganti logo dengan mudah dan aman!
