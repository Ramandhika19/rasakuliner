-- RasaKuliner: gunakan data lokasi internal dan review database saja.
-- Aman dijalankan ulang pada MySQL 5.7+. Tabel reviews tidak diubah/dihapus.
-- Backup database sebelum menjalankan migration pada database produksi.
DROP TABLE IF EXISTS `google_review_links`;

SET @db_name = DATABASE();

-- Hapus metadata integrasi Google lama jika masih ada pada database lama.
SET @drop_google_place_id = (
  SELECT IF(COUNT(*) > 0, 'ALTER TABLE `lokasi_kuliner` DROP COLUMN `google_place_id`', 'SELECT 1')
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'lokasi_kuliner' AND COLUMN_NAME = 'google_place_id'
);
PREPARE stmt_google_place_id FROM @drop_google_place_id;
EXECUTE stmt_google_place_id;
DEALLOCATE PREPARE stmt_google_place_id;

SET @drop_google_maps_url = (
  SELECT IF(COUNT(*) > 0, 'ALTER TABLE `lokasi_kuliner` DROP COLUMN `google_maps_url`', 'SELECT 1')
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'lokasi_kuliner' AND COLUMN_NAME = 'google_maps_url'
);
PREPARE stmt_google_maps_url FROM @drop_google_maps_url;
EXECUTE stmt_google_maps_url;
DEALLOCATE PREPARE stmt_google_maps_url;

SET @drop_matching_status = (
  SELECT IF(COUNT(*) > 0, 'ALTER TABLE `lokasi_kuliner` DROP COLUMN `status_pencocokan`', 'SELECT 1')
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'lokasi_kuliner' AND COLUMN_NAME = 'status_pencocokan'
);
PREPARE stmt_matching_status FROM @drop_matching_status;
EXECUTE stmt_matching_status;
DEALLOCATE PREPARE stmt_matching_status;

-- Rating lokasi eksternal dihapus; rating resmi tetap ada di tabel reviews.
SET @drop_external_rating = (
  SELECT IF(COUNT(*) > 0, 'ALTER TABLE `lokasi_kuliner` DROP COLUMN `rating`', 'SELECT 1')
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'lokasi_kuliner' AND COLUMN_NAME = 'rating'
);
PREPARE stmt_external_rating FROM @drop_external_rating;
EXECUTE stmt_external_rating;
DEALLOCATE PREPARE stmt_external_rating;
