-- RasaKuliner: pemisahan sumber data lokasi (aman dijalankan ulang)
-- Jalankan pada database rasakuliner. Data lama otomatis menjadi sumber database.
SET @db_name = DATABASE();

SET @ddl = IF(
  (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA=@db_name AND TABLE_NAME='lokasi_kuliner' AND COLUMN_NAME='sumber_data')=0,
  "ALTER TABLE lokasi_kuliner ADD COLUMN sumber_data ENUM('database','seller') NOT NULL DEFAULT 'database' AFTER google_place_id",
  "SELECT 'kolom sumber_data sudah tersedia' AS info"
);
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @ddl = IF(
  (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA=@db_name AND TABLE_NAME='lokasi_kuliner' AND COLUMN_NAME='seller_user_id')=0,
  "ALTER TABLE lokasi_kuliner ADD COLUMN seller_user_id INT(10) UNSIGNED DEFAULT NULL AFTER sumber_data",
  "SELECT 'kolom seller_user_id sudah tersedia' AS info"
);
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @ddl = IF(
  (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA=@db_name AND TABLE_NAME='lokasi_kuliner' AND INDEX_NAME='idx_lokasi_sumber')=0,
  "ALTER TABLE lokasi_kuliner ADD KEY idx_lokasi_sumber (sumber_data)",
  "SELECT 'index idx_lokasi_sumber sudah tersedia' AS info"
);
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @ddl = IF(
  (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA=@db_name AND TABLE_NAME='lokasi_kuliner' AND INDEX_NAME='idx_lokasi_seller')=0,
  "ALTER TABLE lokasi_kuliner ADD KEY idx_lokasi_seller (seller_user_id)",
  "SELECT 'index idx_lokasi_seller sudah tersedia' AS info"
);
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @ddl = IF(
  (SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_SCHEMA=@db_name AND TABLE_NAME='lokasi_kuliner' AND CONSTRAINT_NAME='fk_lokasi_seller_user')=0,
  "ALTER TABLE lokasi_kuliner ADD CONSTRAINT fk_lokasi_seller_user FOREIGN KEY (seller_user_id) REFERENCES users(id) ON DELETE SET NULL",
  "SELECT 'foreign key fk_lokasi_seller_user sudah tersedia' AS info"
);
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;
