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


## Ulasan Google Maps dan ulasan komunitas

Halaman detail kuliner menyediakan dua sumber ulasan yang terpisah:

- **Google Maps:** sistem mencocokkan setiap baris `lokasi_kuliner` dengan Google Places, menyimpan hanya `google_place_id`, lalu meminta rating, jumlah penilaian, dan maksimal lima ulasan publik melalui Place Details (New). Konten ulasan Google tidak disimpan di database/cache aplikasi.
- **RasaKuliner:** pengguna dengan role User dapat memberi rating dan komentar untuk cabang/tempat makan tertentu. Setiap review disimpan pada `reviews.lokasi_id`, sehingga ulasan antar-cabang tidak tercampur. Review lama tetap dipertahankan dengan `lokasi_id = NULL` karena tempat kunjungannya belum tercatat.

### Migrasi database lama

Backup database terlebih dahulu, lalu jalankan satu kali file `database/migrasi_review_per_tempat.sql` melalui phpMyAdmin. Migrasi menambahkan:
- `lokasi_kuliner.google_place_id` untuk menyimpan ID tempat Google.
- `reviews.lokasi_id` dan foreign key ke `lokasi_kuliner.id`.

Jika mengimpor `database/rasakuliner.sql` dari awal, struktur kolom tersebut sudah termasuk di dump.

### Konfigurasi Google Places API

Tambahkan API key pada bagian [vars] di `app/config/config.ini` lokal:

```ini
[vars]
siteName = RasaNusantara
googleMapsApiKey = MASUKKAN_API_KEY_LOKAL
```

Aktifkan **Places API (New)** dan billing pada Google Cloud project, lalu batasi API key sesuai kebutuhan server. Pastikan PHP cURL aktif. Jangan commit API key ke repository.

**Catatan biaya:** permintaan Text Search digunakan untuk menemukan Place ID yang belum tersimpan. Permintaan Place Details dengan field `reviews` termasuk SKU **Place Details Enterprise + Atmosphere**, sehingga biayanya lebih tinggi daripada hanya mengambil rating dan jumlah penilaian. Periksa harga dan kuota Google Maps Platform sebelum mengaktifkan fitur di produksi.

Google hanya mengembalikan maksimal lima ulasan yang diurutkan berdasarkan relevansi. Tampilan wajib menyertakan atribusi Google Maps, atribusi penulis, serta tautan untuk membuka ulasan sumber di Google Maps. Pengunjung yang ingin menulis ulasan Google tetap diarahkan ke Google Maps; formulir RasaKuliner hanya menyimpan ulasan ke database RasaKuliner.
