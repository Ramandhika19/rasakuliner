-- RasaKuliner: pemisahan sumber data lokasi (aman untuk data lama)
-- Jalankan satu kali melalui phpMyAdmin pada database rasakuliner.
-- Data lama otomatis ditandai sebagai database RasaKuliner.
ALTER TABLE lokasi_kuliner
  ADD COLUMN sumber_data ENUM('database','seller') NOT NULL DEFAULT 'database' AFTER google_place_id,
  ADD COLUMN seller_user_id INT(10) UNSIGNED DEFAULT NULL AFTER sumber_data,
  ADD KEY idx_lokasi_sumber (sumber_data),
  ADD KEY idx_lokasi_seller (seller_user_id);

ALTER TABLE lokasi_kuliner
  ADD CONSTRAINT fk_lokasi_seller_user
  FOREIGN KEY (seller_user_id) REFERENCES users(id) ON DELETE SET NULL;
