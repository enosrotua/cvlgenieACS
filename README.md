# GENIEACS AUTO INSTALLER

Repository ini berisi script otomatis untuk instalasi GenieACS dengan dua pilihan tema:
- **Dark Mode Theme** - Tema gelap dengan logo custom
- **Original Theme** - Tema asli GenieACS v1.2.13

## Tampilan

<img width="1358" height="650" alt="Dark Mode Theme" src="https://github.com/user-attachments/assets/d2689a26-9eed-4449-a0d3-2edffddd7bc6" />
<img width="1358" height="650" alt="Original Theme" src="https://github.com/user-attachments/assets/c13ed312-d007-4cc2-987d-e82f171dd7ce" />

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
git clone https://github.com/enosrotua/cvlgenieACS
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

### Backup Konfigurasi
```bash
bash backup.sh
```

### Restore Konfigurasi
```bash
cd genieacs-backup-TIMESTAMP
./restore.sh
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
├── darkmode.sh          # Script instalasi Dark Mode
├── install.sh           # Script instalasi Original
├── backup.sh            # Script backup konfigurasi
├── db/                  # Database backup
│   ├── config.bson
│   ├── devices.bson
│   ├── presets.bson
│   ├── provisions.bson
│   └── virtualParameters.bson
├── config/              # Konfigurasi GenieACS
├── app-LU66VFYW.css     # Dark Mode CSS
├── logo.svg             # Logo custom
└── README.md            # Dokumentasi ini
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

- **WhatsApp**: [081947215703](https://wa.me/6281947215703)
- **Telegram**: [@alijayaNetAcs](https://t.me/alijayaNetAcs)

## Donasi

Jika script ini membantu Anda, silakan berikan donasi untuk pengembangan lebih lanjut:

[![PayPal](https://img.shields.io/badge/PayPal-Donate-blue.svg)](https://paypal.me/warnetalijayaID)

## Lisensi

Script ini bebas digunakan untuk keperluan komersial dan non-komersial.

## Changelog

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