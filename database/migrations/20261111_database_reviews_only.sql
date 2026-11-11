-- RasaKuliner: gunakan data lokasi internal dan review database saja.
-- Aman dijalankan ulang pada MySQL 5.7+. Tabel reviews tidak diubah/dihapus.
DROP TABLE IF EXISTS `google_review_links`;

SET @db_name = DATABASE();
SET @drop_google_place_id = (
  SELECT IF(COUNT(*) > 0,
    'ALTER TABLE `lokasi_kuliner` DROP COLUMN `google_place_id`',
    'SELECT 1')
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'lokasi_kuliner'
    AND COLUMN_NAME = 'google_place_id'
);
PREPARE stmt_google_place_id FROM @drop_google_place_id;
EXECUTE stmt_google_place_id;
DEALLOCATE PREPARE stmt_google_place_id;

SET @drop_external_rating = (
  SELECT IF(COUNT(*) > 0,
    'ALTER TABLE `lokasi_kuliner` DROP COLUMN `rating`',
    'SELECT 1')
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'lokasi_kuliner'
    AND COLUMN_NAME = 'rating'
);
PREPARE stmt_external_rating FROM @drop_external_rating;
EXECUTE stmt_external_rating;
DEALLOCATE PREPARE stmt_external_rating;
