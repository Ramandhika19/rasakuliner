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

## Menjalankan
1. Letakkan folder `rasakuliner` di `D:/php72/htdocs/rasakuliner`.
2. Pastikan ekstensi Phalcon aktif pada PHP yang digunakan Apache. File bootstrap ini memakai gaya API Phalcon 3 (`Phalcon\Config\Adapter\Ini` dan `Phalcon\Di\FactoryDefault`).
3. Import `database/rasakuliner.sql` lewat phpMyAdmin.
4. Sesuaikan `[database]` di `app/config/config.ini` jika username/password MySQL berbeda.
5. Pastikan `mod_rewrite` aktif di Apache dan `AllowOverride All` berlaku untuk folder project.
6. Buka `http://localhost/rasakuliner/public/` atau `http://localhost/rasakuliner/public/kuliner`.

## Catatan versi
Jika `Phalcon\Config\Adapter\Ini` juga tidak ditemukan, versi/komponen Phalcon yang terpasang berbeda. Jalankan `php -r "echo Phalcon\\Version::get();"` pada PHP CLI dan periksa `phpinfo()` dari Apache; keduanya harus memakai ekstensi yang sesuai.
