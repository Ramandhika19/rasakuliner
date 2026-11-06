# RasaNusantara — Phalcon MVC

Starter website RasaNusantara dengan dua halaman: Beranda dan Jelajahi Kuliner.

## Struktur
- `app/config/config.ini` — konfigurasi database dan aplikasi bergaya INI
- `app/config/services.php` — service DI: database, view/Volt, URL
- `app/controllers/` — controller halaman
- `app/models/` — query data kuliner
- `app/library/` — tempat helper tambahan
- `app/views/` — template Volt
- `public/` — front controller dan asset CSS/JS
- `database/rasakuliner.sql` — database dan data contoh

## Akun, peran, dan moderasi
Skema database menyediakan `users`, `roles`, `permissions`, `user_roles`, dan `role_permissions` untuk akun serta akses berbasis peran. Peran awalnya adalah `user`, `seller`, dan `admin`; belum ada akun admin bawaan.

Seller memiliki profil di `seller_profiles` dan dapat mengajukan kuliner melalui kolom status pada `kuliner` (`draft`, `pending`, `approved`, atau `rejected`). Pengajuan menautkan pemilik, admin peninjau, waktu peninjauan, dan alasan penolakan. Jika kolom `status` tersedia, data publik, unggulan, dan pilihan daerah hanya mengambil kuliner berstatus `approved`. Untuk database lama yang belum memiliki kolom tersebut, aplikasi tetap menampilkan data yang ada agar halaman tidak gagal; data pada skema lama dianggap sudah terbit. Tabel-tabel ini menyiapkan struktur database; alur login, pengiriman pengajuan, serta halaman moderasi belum tersedia di aplikasi.

## Portal Seller\n- Menu **Kontribusi** mengarahkan calon mitra untuk mendaftar sebagai seller melalui `/daftar-seller`; seller yang sudah memiliki akun masuk melalui `/login-seller`.\n- Seller mendapat dashboard di `/seller` untuk melihat data kuliner, status pengajuan, jumlah ulasan, dan rating; profil usaha di `/seller/profil`; serta halaman tambah/edit data kuliner. Data baru atau perubahan dikirim kembali dengan status `pending` agar ditinjau admin.\n- Setelah memperbarui aplikasi, impor `database/migrasi_seller_reviews.sql` melalui phpMyAdmin untuk menyiapkan tabel `reviews` yang dipakai statistik rating. Migrasi ini membuat tabel ulasan kosong; statistik akan terisi setelah alur ulasan pengunjung menyimpan data ke tabel tersebut.\n- Pastikan tabel `users`, `roles`, `user_roles`, `seller_profiles`, dan kolom kepemilikan/status pada `kuliner` sudah tersedia dari `database/rasakuliner.sql`.\n\n## Menjalankan
1. Letakkan folder `rasakuliner` di `D:/php72/htdocs/rasakuliner`.
2. Pastikan ekstensi Phalcon aktif pada PHP yang digunakan Apache. File bootstrap ini memakai gaya API Phalcon 3 (`Phalcon\Config\Adapter\Ini` dan `Phalcon\Di\FactoryDefault`).
3. Import `database/rasakuliner.sql` lewat phpMyAdmin.
4. Sesuaikan `[database]` di `app/config/config.ini` jika username/password MySQL berbeda.
5. Pastikan `mod_rewrite` aktif di Apache dan `AllowOverride All` berlaku untuk folder project.
6. Buka `http://localhost/rasakuliner/public/` atau `http://localhost/rasakuliner/public/kuliner`.

## Catatan versi
Jika `Phalcon\Config\Adapter\Ini` juga tidak ditemukan, versi/komponen Phalcon yang terpasang berbeda. Jalankan `php -r "echo Phalcon\\Version::get();"` pada PHP CLI dan periksa `phpinfo()` dari Apache; keduanya harus memakai ekstensi yang sesuai.

## Peta & detail kuliner
- `/peta` — Peta Kuliner (Leaflet + OpenStreetMap, gratis tanpa API key): cari tempat terdekat dari lokasi GPS atau titik yang diklik di peta, filter radius/jenis/kata kunci.
- `/kuliner/detail/{id}` — halaman detail kuliner dengan peta semua lokasinya (dari latitude & longitude), jarak dari lokasi pengguna, dan tautan rute Google Maps.
- Tabel baru `lokasi_kuliner` (kuliner_id, nama_tempat, alamat, kota, latitude, longitude, jam_buka, kisaran_harga, rating, telepon). Untuk database yang sudah ada, import `database/migrasi_lokasi.sql` (tidak menghapus data lama). Data lokasi bawaan adalah data contoh; ganti dengan data asli lewat phpMyAdmin.
- Butuh internet di browser untuk memuat Leaflet (unpkg) dan tile OpenStreetMap.
