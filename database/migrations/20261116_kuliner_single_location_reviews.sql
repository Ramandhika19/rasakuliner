-- RasaKuliner: satu produk kuliner memiliki satu titik lokasi dan review terhubung langsung ke produk.
-- WAJIB backup database sebelum menjalankan. Data cabang di lokasi_kuliner akan dihapus.
-- Alamat dan koordinat utama tetap dipertahankan pada tabel kuliner.
SET @db_name = DATABASE();

SET @drop_review_location_fk = (
 SELECT IF(COUNT(*)>0,'ALTER TABLE `reviews` DROP FOREIGN KEY `fk_reviews_lokasi`','SELECT 1')
 FROM information_schema.TABLE_CONSTRAINTS
 WHERE CONSTRAINT_SCHEMA=@db_name AND TABLE_NAME='reviews'
 AND CONSTRAINT_NAME='fk_reviews_lokasi' AND CONSTRAINT_TYPE='FOREIGN KEY'
);
PREPARE stmt_review_location_fk FROM @drop_review_location_fk;
EXECUTE stmt_review_location_fk;
DEALLOCATE PREPARE stmt_review_location_fk;

SET @drop_review_location_unique = (
 SELECT IF(COUNT(*)>0,'ALTER TABLE `reviews` DROP INDEX `uq_reviews_user_location`','SELECT 1')
 FROM information_schema.STATISTICS
 WHERE TABLE_SCHEMA=@db_name AND TABLE_NAME='reviews' AND INDEX_NAME='uq_reviews_user_location'
);
PREPARE stmt_review_location_unique FROM @drop_review_location_unique;
EXECUTE stmt_review_location_unique;
DEALLOCATE PREPARE stmt_review_location_unique;

SET @drop_review_location_idx = (
 SELECT IF(COUNT(*)>0,'ALTER TABLE `reviews` DROP INDEX `idx_reviews_lokasi`','SELECT 1')
 FROM information_schema.STATISTICS
 WHERE TABLE_SCHEMA=@db_name AND TABLE_NAME='reviews' AND INDEX_NAME='idx_reviews_lokasi'
);
PREPARE stmt_review_location_idx FROM @drop_review_location_idx;
EXECUTE stmt_review_location_idx;
DEALLOCATE PREPARE stmt_review_location_idx;

SET @drop_review_location_col = (
 SELECT IF(COUNT(*)>0,'ALTER TABLE `reviews` DROP COLUMN `lokasi_id`','SELECT 1')
 FROM information_schema.COLUMNS
 WHERE TABLE_SCHEMA=@db_name AND TABLE_NAME='reviews' AND COLUMN_NAME='lokasi_id'
);
PREPARE stmt_review_location_col FROM @drop_review_location_col;
EXECUTE stmt_review_location_col;
DEALLOCATE PREPARE stmt_review_location_col;

DROP TABLE IF EXISTS `lokasi_kuliner`;
