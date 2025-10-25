# GENIEACS AUTO INSTALLER

Repository ini berisi script otomatis untuk instalasi GenieACS dengan dua pilihan tema:
- **Dark Mode Theme** - Tema gelap dengan logo custom
- **Original Theme** - Tema asli GenieACS v1.2.13

## Tampilan

<img width="1919" height="897" alt="Screenshot_147" src="https://github.com/user-attachments/assets/bf520421-a66d-48bb-b8e1-0704ee2778f8" />
<img width="1916" height="910" alt="Screenshot_145" src="https://github.com/user-attachments/assets/e05454d4-6776-454c-b220-27c2c94d1329" />

## Fitur

✅ **Instalasi Lengkap Otomatis**
- Node.js 20.x
- MongoDB 6.0
- GenieACS v1.2.13
- Systemd services
- Log rotation

✅ **Dark Mode Theme**
- CSS tema gelap
- Logo custom
- UI yang lebih modern

✅ **Original Theme**
- Tema asli GenieACS
- Konfigurasi standar

✅ **Backup & Restore**
- Script backup otomatis
- Script restore lengkap
- Backup database dan konfigurasi

## Persyaratan Sistem

- Ubuntu 20.04/22.04/24.04
- Root access atau sudo privileges
- Koneksi internet
- Minimal 2GB RAM
- Minimal 10GB storage

## Instalasi Cepat

### 1. Clone Repository
```bash
apt install git curl -y
git clone https://github.com/enosrotua/cvlgenieACS.git
cd cvlgenieACS
chmod +x *.sh
```

### 2. Pilih Tema

#### Dark Mode Theme (Recommended)
```bash
bash darkmode.sh
```

#### Original Theme
```bash
bash install.sh
```

### 3. Akses GenieACS
- URL: `http://YOUR_SERVER_IP:3000`
- Username: `admin`
- Password: `admin`

## Script Tambahan

### 🎨 **Theme & Logo Management**
```bash
# Ganti logo
bash change-logo.sh

# Ganti tema/background color
bash change-theme.sh

# Management suite lengkap
bash genieacs-manager.sh
```

### 💾 **Backup & Restore**
```bash
# Backup konfigurasi
bash backup.sh

# Restore konfigurasi
cd genieacs-backup-TIMESTAMP
./restore.sh
```

### 🧪 **Testing & Monitoring**
```bash
# Test instalasi lengkap
bash test-installation.sh
```

## Konfigurasi

### Mengubah ACS URL
1. Login ke GenieACS UI
2. Masuk ke **Admin** → **Provisions**
3. Edit parameter **inform** → **ACS URL**
4. Ganti dengan IP server Anda

### Mengubah Logo
1. Ganti file `logo.svg` dengan logo Anda
2. Jalankan script instalasi ulang

### Mengubah Dark Mode CSS
1. Edit file `app-LU66VFYW.css`
2. Jalankan script instalasi ulang

## Struktur Repository

```
cvlgenieACS/
├── darkmode.sh              # Script instalasi Dark Mode
├── install.sh               # Script instalasi Original
├── genieacs-manager.sh      # Management suite lengkap
├── change-logo.sh           # Script ganti logo
├── change-theme.sh          # Script ganti tema
├── backup.sh                # Script backup konfigurasi
├── test-installation.sh     # Script testing lengkap
├── db/                      # Database backup
│   ├── config.bson
│   ├── devices.bson
│   ├── presets.bson
│   ├── provisions.bson
│   └── virtualParameters.bson
├── config/                  # Konfigurasi GenieACS
├── app-LU66VFYW.css         # Dark Mode CSS
├── logo.svg                 # Logo custom
├── LOGO-GUIDE.md            # Panduan logo
├── THEME-GUIDE.md           # Panduan tema
└── README.md                # Dokumentasi ini
```

## Troubleshooting

### Service Tidak Start
```bash
systemctl status genieacs-ui
systemctl status mongod
journalctl -u genieacs-ui -f
```

### MongoDB Error
```bash
systemctl restart mongod
mongosh --eval 'db.runCommand({ connectionStatus: 1 })'
```

### Port 3000 Sudah Digunakan
```bash
netstat -tlnp | grep :3000
# Kill process yang menggunakan port 3000
```

### Permission Error
```bash
chown -R genieacs:genieacs /opt/genieacs
chown -R genieacs:genieacs /var/log/genieacs
```

## Update & Upgrade

### Update GenieACS
```bash
npm update -g genieacs
systemctl restart genieacs-cwmp genieacs-fs genieacs-ui genieacs-nbi
```

### Update Database Schema
```bash
mongorestore --db genieacs --drop db/
systemctl restart genieacs-cwmp genieacs-fs genieacs-ui genieacs-nbi
```

## Kontribusi

Kontribusi selalu diterima! Silakan buat pull request atau laporkan issue jika menemukan bug.

## Kontak & Support

- **WhatsApp**: [081368888498](https://wa.me/6281368888498)


## Donasi

Jika script ini membantu Anda, silakan berikan donasi untuk pengembangan lebih lanjut:

![bronze](https://github.com/user-attachments/assets/49395502-a0cc-4e34-a452-cd2da88d60ae)

## Lisensi

Script ini bebas digunakan untuk keperluan komersial dan non-komersial.

## Changelog

### v2.1.0 (2025-10-24)
- ✅ **NEW**: Script change-logo.sh untuk ganti logo mudah
- ✅ **NEW**: Script change-theme.sh untuk ganti tema/background
- ✅ **NEW**: Script genieacs-manager.sh (management suite lengkap)
- ✅ **NEW**: LOGO-GUIDE.md dan THEME-GUIDE.md
- ✅ **NEW**: Support Dark Theme seperti di foto
- ✅ **NEW**: Custom color themes (Blue, Green, Red, Purple, Gray)
- ✅ **NEW**: Interactive menu untuk semua operasi
- ✅ **NEW**: Automatic backup sebelum perubahan

### v2.0.0 (2025-10-24)
- ✅ Perbaikan script darkmode.sh untuk instalasi lengkap
- ✅ Penambahan MongoDB 6.0 support
- ✅ Perbaikan systemd services dengan restart policy
- ✅ Penambahan script backup otomatis
- ✅ Update README dengan dokumentasi lengkap
- ✅ Perbaikan error handling dan logging

### v1.2.13 (Previous)
- Instalasi GenieACS original
- Dark mode theme basic
- MongoDB 4.4 support

---

**⚠️ PENTING**: Script ini akan mengupdate konfigurasi GenieACS yang ada. Pastikan untuk melakukan backup terlebih dahulu jika Anda memiliki konfigurasi custom.
