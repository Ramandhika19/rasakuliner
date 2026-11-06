-- Jalankan sekali di database rasakuliner melalui phpMyAdmin.
-- Menambahkan foto profil seller; aman untuk data profil yang sudah ada.
-- IF NOT EXISTS mencegah error jika kolom sudah pernah ditambahkan.
ALTER TABLE seller_profiles
    ADD COLUMN IF NOT EXISTS foto_profil VARCHAR(500) NULL AFTER alamat;
