# RasaNusantara — Phalcon MVC

## Struktur
- `app/config/config.ini` — konfigurasi aplikasi dan database
- `app/config/services.php` — service DI: database, view/Volt, URL
- `app/controllers/` — controller halaman, autentikasi, seller, dan admin
- `app/library/SmtpMailer.php` — helper SMTP Gmail
- `app/views/` — template Volt
- `public/` — front controller dan asset
- `database/rasakuliner.sql` — struktur database lengkap beserta 15 artikel kuliner
- `database/migrasi_cerita_blog.sql` — migrasi tabel artikel untuk database lama

## Verifikasi Seller langsung dari email admin

Email ke `caesarramandhika@gmail.com` menyertakan tombol **TERIMA SELLER** dan **TOLAK SELLER**. Tautan membuka halaman konfirmasi; status database baru berubah setelah keputusan dikonfirmasi. Token berlaku 48 jam dan hanya dapat digunakan satu kali. Setelah keputusan, email hasil diterima/ditolak dikirim ke alamat pendaftar.

Sebelum memakai fitur ini pada database yang sudah ada, import file `database/migrations/20261108_seller_email_actions.sql` melalui phpMyAdmin. File tersebut membuat tabel token keputusan email.

## Verifikasi pendaftaran Seller melalui email

Alur pendaftaran:
1. Calon Seller mengisi formulir `/daftar-seller`.
2. Data dibuat dengan status `pending`; role Seller belum diberikan dan pengguna belum bisa login.
3. Sistem mengirim pemberitahuan ke email admin.
4. Admin login melalui `/login-seller`, lalu membuka `/admin/seller`.
5. Admin memilih Accept atau Reject. Jika disetujui, status menjadi `verified` dan role Seller diberikan. Jika ditolak, alasan penolakan disimpan.
6. Sistem mengirim email keputusan kepada pendaftar. Login Seller hanya berhasil jika status sudah `verified`.

### Konfigurasi SMTP Gmail
Isi bagian `[mailer]` pada `app/config/config.ini` di komputer/server lokal:
- `host = smtp.gmail.com`
- `port = 465`
- `username = alamat Gmail pengirim`
- `password = App Password Gmail` (bukan password login Gmail)
- `from_email = alamat Gmail pengirim`
- `from_name = RasaKuliner`
- `admin_email = caesarramandhika@gmail.com` (satu-satunya email yang boleh login sebagai admin dan menyetujui/menolak Seller)
- `app_url = http://localhost/rasakuliner/public` (sesuaikan domain)

Jangan memasukkan password SMTP, App Password, atau secret lain ke Git. Jika kredensial pernah terlanjur dibagikan, segera cabut/ganti kredensial tersebut. Helper SMTP menggunakan SSL port 465 dan tidak memerlukan library tambahan.

### Menyiapkan akun admin
Hanya akun dengan email `caesarramandhika@gmail.com` yang dapat membuka panel verifikasi dan memproses pendaftaran Seller. Buat akun admin satu kali dengan email tersebut melalui phpMyAdmin/SQL. Buat hash password dari terminal PHP terlebih dahulu:
```bash
php -r "echo password_hash('GANTI_PASSWORD_KUAT', PASSWORD_DEFAULT), PHP_EOL;"
```
Salin hasil hash, lalu jalankan SQL berikut dan ganti nama, email, serta hash password:
```sql
INSERT INTO users (nama, email, password_hash, status)
VALUES ('Administrator', 'caesarramandhika@gmail.com', 'TEMPEL_HASH_DI_SINI', 'active');

SET @admin_id = LAST_INSERT_ID();
INSERT INTO user_roles (user_id, role_id)
SELECT @admin_id, id FROM roles WHERE slug='admin';
```
Setelah itu admin bisa login melalui halaman Login Seller yang sama; sistem akan mengarahkannya ke panel admin di `/admin/seller`.

## Menjalankan
1. Letakkan folder project di `D:/php72/htdocs/rasakuliner`.
2. Pastikan ekstensi Phalcon dan PDO MySQL aktif.
3. Import `database/rasakuliner.sql` melalui phpMyAdmin.
4. Import migration `database/migrations/20261108_seller_email_actions.sql` untuk database yang sudah ada.\n6. Sesuaikan database dan SMTP di `app/config/config.ini`.
7. Buka `http://localhost/rasakuliner/public/`.

## Catatan
- Versi aplikasi ini menggunakan gaya API Phalcon yang tersedia pada instalasi project.
- Pastikan Apache mengaktifkan rewrite dan `AllowOverride All`.
- Folder cache dan folder upload harus dapat ditulis oleh Apache/PHP.


## Sumber data lokasi dan peta seluruh Indonesia

Peta RasaKuliner menggunakan Leaflet + OpenStreetMap untuk menampilkan koordinat lokasi usaha di seluruh Indonesia. Data kuliner dan lokasi usaha dipisahkan:

- `kuliner`: jenis makanan/minuman, daerah asal, kategori, deskripsi, dan gambar.
- `lokasi_kuliner`: cabang/tempat usaha yang menjual kuliner, alamat, latitude, longitude, serta sumber data.
- `lokasi_kuliner.sumber_data = database`: lokasi yang dimasukkan oleh admin atau berasal dari database awal.
- `lokasi_kuliner.sumber_data = seller`: lokasi yang dikirim oleh Mitra Seller terverifikasi.
- `lokasi_kuliner.google_place_id`: ID referensi untuk membuka tempat yang cocok di Google Maps, bukan sumber koordinat marker OpenStreetMap.

Google Maps dipakai sebagai tautan referensi/navigasi eksternal. Project tidak memanggil Google Places API, tidak memerlukan API key atau billing, dan tidak menyalin koordinat/review Google ke peta OpenStreetMap. Koordinat marker OSM harus berasal dari pemilihan pin, geocoding OpenStreetMap/Nominatim, atau verifikasi admin/seller.

### Alur data Mitra Seller

1. Admin memverifikasi akun Seller melalui `/admin/seller`.
2. Seller terverifikasi mengirim kuliner, alamat usaha, dan titik latitude/longitude melalui peta OpenStreetMap.
3. Pengajuan tersimpan sebagai `pending` dan belum tampil untuk publik.
4. Admin memeriksa pengajuan melalui `/admin/kuliner`, termasuk membuka koordinat di OpenStreetMap.
5. Setelah disetujui, data kuliner berstatus `approved` dan lokasi usaha dibuat/ditautkan sebagai sumber `seller`. Lokasi tersebut muncul pada peta dan dapat difilter terpisah dari database RasaKuliner.

### Migrasi database

Backup database terlebih dahulu. Untuk database lama, jalankan:

- `database/migrations/20261111_sumber_lokasi.sql` — menambahkan sumber data lokasi dan relasi pemilik seller. Script ini memeriksa kolom/index/foreign key sehingga aman dijalankan ulang.
- `database/migrasi_review_per_tempat.sql` — migrasi ulasan per tempat jika belum pernah dijalankan.

Untuk instalasi baru, `database/rasakuliner.sql` sudah menyertakan kolom sumber data lokasi. Migration sumber lokasi tetap boleh dijalankan karena bersifat idempotent.

### Ulasan

- Review komunitas disimpan di tabel `reviews` dan dipisahkan per lokasi melalui `reviews.lokasi_id`.
- Google Maps dibuka melalui tautan eksternal pada masing-masing lokasi. Pengguna dapat membaca/menulis review Google di halaman Google Maps.
- Tidak ada pengambilan ulasan Google otomatis, API key, atau biaya Places API. Review komunitas RasaKuliner tetap gratis dan terpisah.

### Cakupan dan kelengkapan data

Cakupan aplikasi adalah seluruh Indonesia. Data awal berisi jenis kuliner Nusantara; data jenis makanan tidak otomatis berarti sudah memiliki outlet fisik. Setiap marker membutuhkan baris `lokasi_kuliner` dengan koordinat yang benar. Jangan mengisi koordinat berdasarkan tebakan atau titik tengah kota/provinsi. Lokasi yang belum memiliki koordinat tetap dapat tampil di daftar, tetapi tidak dibuatkan marker sampai titiknya diverifikasi.
