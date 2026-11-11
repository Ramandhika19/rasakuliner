-- RasaKuliner: ganti lokasi seed contoh dengan usaha kuliner Bali yang dapat ditelusuri.
-- Backup database sebelum menjalankan migration ini.
-- Koordinat sengaja NULL bila belum diverifikasi; peta akan menyediakan pencarian Google Maps.

ALTER TABLE lokasi_kuliner
  MODIFY latitude DECIMAL(10,7) NULL DEFAULT NULL,
  MODIFY longitude DECIMAL(10,7) NULL DEFAULT NULL;

-- Hapus hanya 68 baris seed awal dari dump RasaKuliner (ID 1-68).
-- Data lokasi baru milik seller (ID 69 ke atas) tidak disentuh.
DELETE FROM lokasi_kuliner WHERE id BETWEEN 1 AND 68;

INSERT INTO lokasi_kuliner
(kuliner_id, nama_tempat, alamat, kota, latitude, longitude, jam_buka, kisaran_harga, rating, telepon, created_at, updated_at)
VALUES
('69', '3', 'Ayam Betutu Ibu Nia - Renon', 'Jl. Merdeka No. 1, Renon, Denpasar', 'Denpasar', NULL, NULL, NULL, NULL, NULL, '0823-3913-4073', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('70', '3', 'Ayam Betutu Khas Gilimanuk - Merdeka', 'Jl. Merdeka No. 88 No. 5, Sumerta Kelod, Denpasar Timur', 'Denpasar', NULL, NULL, NULL, NULL, NULL, '0811-3993-387', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('71', '3', 'Betutu Panggang Biang Koripan 7 Waturenggong', 'Jl. Waturenggong No. 145, Panjer, Denpasar Selatan', 'Denpasar', NULL, NULL, NULL, NULL, NULL, '0878-6971-2949', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('72', '3', 'Ayam Betutu Bu Ferdi', 'Jl. Buana Kubu, Tegal Harum, Denpasar Barat', 'Denpasar', NULL, NULL, NULL, NULL, NULL, '0813-3807-0288', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('73', '3', 'Warung Makan Ayam Betutu Bu Kadek Wati', 'Jl. Gatot Subroto Barat, Denpasar Utara', 'Denpasar', NULL, NULL, NULL, NULL, NULL, '0822-3776-7772', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('74', '3', 'Ayam Betutu Pak Man Kuta', 'Jl. Pudak Sari No. 72, Kuta, Badung', 'Badung', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('75', '3', 'Ayam Betutu Khas Gilimanuk - Central Park Kuta', 'Jl. Patih Jelantik, Komp. Istana Kuta Galeria, Kuta, Badung', 'Badung', NULL, NULL, NULL, NULL, NULL, '0812-3903-3922', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('76', '3', 'Ayam Betutu Khas Gilimanuk - Tuban', 'Jl. Raya Tuban No. 2X, Tuban, Kuta, Badung', 'Badung', NULL, NULL, NULL, NULL, NULL, '0361-757535', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('77', '35', 'Warung Wardani - Yudistira', 'Jl. Yudistira No. 2, Dangin Puri Kauh, Denpasar Utara', 'Denpasar', NULL, NULL, '08.00 – 16.00', 'Rp30.000 – 45.000', NULL, '0361-224398', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('78', '35', 'Warung Tresni', 'Jl. Drupadi II No. 54, Renon, Denpasar Selatan', 'Denpasar', NULL, NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('79', '12', 'Bendega Renon', 'Jl. Cok Agung Tresna No. 37, Dangin Puri Klod, Denpasar Timur', 'Denpasar', NULL, NULL, NULL, NULL, NULL, '0877-6407-8434', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
