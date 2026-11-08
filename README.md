# RasaNusantara — Phalcon MVC

## Struktur
- `app/config/config.ini` — konfigurasi aplikasi dan database
- `app/config/services.php` — service DI: database, view/Volt, URL
- `app/controllers/` — controller halaman, autentikasi, seller, dan admin
- `app/library/SmtpMailer.php` — helper SMTP Gmail
- `app/views/` — template Volt
- `public/` — front controller dan asset
- `database/rasakuliner.sql` — struktur database

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
- `admin_email = email admin penerima notifikasi pendaftaran`
- `app_url = http://localhost/rasakuliner/public` (sesuaikan domain)

Jangan memasukkan password SMTP, App Password, atau secret lain ke Git. Jika kredensial pernah terlanjur dibagikan, segera cabut/ganti kredensial tersebut. Helper SMTP menggunakan SSL port 465 dan tidak memerlukan library tambahan.

### Menyiapkan akun admin
Belum ada akun admin bawaan. Buat akun melalui aplikasi/SQL dengan password yang sudah di-hash oleh PHP, lalu tambahkan role `admin` pada tabel `user_roles`. Contoh membuat hash aman dari terminal PHP:
```bash
php -r "echo password_hash('GANTI_PASSWORD_KUAT', PASSWORD_DEFAULT), PHP_EOL;"
```
Masukkan hasil hash ke kolom `users.password_hash`, lalu hubungkan user ke role admin:
```sql
INSERT INTO user_roles (user_id, role_id)
SELECT ID_USER, id FROM roles WHERE slug='admin';
```
Ganti `ID_USER` dengan ID akun admin yang dibuat. Setelah itu admin bisa login melalui halaman Login Seller yang sama; sistem akan mengarahkannya ke panel admin.

## Menjalankan
1. Letakkan folder project di `D:/php72/htdocs/rasakuliner`.
2. Pastikan ekstensi Phalcon dan PDO MySQL aktif.
3. Import `database/rasakuliner.sql` melalui phpMyAdmin.
4. Sesuaikan database dan SMTP di `app/config/config.ini`.
5. Buka `http://localhost/rasakuliner/public/`.

## Catatan
- Versi aplikasi ini menggunakan gaya API Phalcon yang tersedia pada instalasi project.
- Pastikan Apache mengaktifkan rewrite dan `AllowOverride All`.
- Folder cache dan folder upload harus dapat ditulis oleh Apache/PHP.
