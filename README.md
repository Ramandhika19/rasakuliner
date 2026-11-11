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
4. Import migration `database/migrations/20261108_seller_email_actions.sql` untuk database yang sudah ada.\n5. Sesuaikan database dan SMTP di `app/config/config.ini`.
5. Buka `http://localhost/rasakuliner/public/`.

## Catatan
- Versi aplikasi ini menggunakan gaya API Phalcon yang tersedia pada instalasi project.
- Pastikan Apache mengaktifkan rewrite dan `AllowOverride All`.
- Folder cache dan folder upload harus dapat ditulis oleh Apache/PHP.


## Integrasi ulasan asli Google Maps (Google Places API)
Halaman detail kuliner dapat mengambil rating, jumlah rating, dan cuplikan review asli dari tempat yang cocok dengan nama, alamat, serta koordinat lokasi di database. Integrasi menggunakan Places API (New), bukan scraping halaman Google Maps.

### Aktivasi di komputer lokal
1. Buka Google Cloud Console, pilih/buat project, aktifkan billing, lalu aktifkan **Places API (New)**.
2. Buat API key dan batasi key untuk Places API. Jangan masukkan key ke repository publik.
3. Salin `app/config/google_maps.example.php` menjadi `app/config/google_maps.local.php`.
4. Isi nilai `api_key` pada file lokal tersebut. File lokal ini diabaikan Git.
5. Pastikan ekstensi PHP cURL aktif di XAMPP, lalu restart Apache.
6. Hapus cache Volt jika tampilan belum berubah.

Integrasi mencari kandidat Google berdasarkan nama tempat + alamat dan memberi bias koordinat database. Kandidat yang terlalu jauh atau tidak cukup mirip tidak ditampilkan agar review tidak salah dikaitkan ke kuliner. Hasil API di-cache lokal selama 6 jam. Jika belum ada kecocokan, halaman menampilkan pesan dan tidak mengarang rating/review.
