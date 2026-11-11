-- RasaKuliner: dukungan Google Maps reviews dan review per cabang/tempat makan.
-- Backup database terlebih dahulu, lalu jalankan satu kali melalui phpMyAdmin.
-- Review lama tetap aman: lokasi_id bernilai NULL karena tempat kunjungannya tidak tercatat.

ALTER TABLE lokasi_kuliner
  ADD COLUMN google_place_id VARCHAR(120) NULL DEFAULT NULL AFTER telepon;

ALTER TABLE reviews
  ADD COLUMN lokasi_id INT(10) UNSIGNED NULL DEFAULT NULL AFTER kuliner_id,
  ADD KEY idx_reviews_lokasi (lokasi_id),
  ADD UNIQUE KEY uq_reviews_user_location (kuliner_id, lokasi_id, user_id),
  ADD CONSTRAINT fk_reviews_lokasi
    FOREIGN KEY (lokasi_id) REFERENCES lokasi_kuliner(id)
    ON DELETE SET NULL;
