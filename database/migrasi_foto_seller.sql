-- Jalankan sekali di database rasakuliner melalui phpMyAdmin.
-- Menambahkan foto profil seller; aman untuk data profil yang sudah ada.
ALTER TABLE seller_profiles ADD COLUMN foto_profil VARCHAR(500) NULL AFTER alamat;
