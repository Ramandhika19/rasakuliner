-- Jalankan sekali pada database rasakuliner yang sudah ada.
-- Tabel review digunakan untuk statistik rating seller.
CREATE TABLE IF NOT EXISTS reviews (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  kuliner_id INT UNSIGNED NOT NULL,
  user_id INT UNSIGNED DEFAULT NULL,
  nama_pengunjung VARCHAR(120) DEFAULT NULL,
  rating TINYINT UNSIGNED NOT NULL,
  komentar TEXT DEFAULT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_reviews_kuliner (kuliner_id),
  CONSTRAINT fk_reviews_kuliner FOREIGN KEY (kuliner_id) REFERENCES kuliner(id) ON DELETE CASCADE,
  CONSTRAINT fk_reviews_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
  CONSTRAINT chk_reviews_rating CHECK (rating BETWEEN 1 AND 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
