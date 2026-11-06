-- Jalankan sekali pada database rasakuliner.
CREATE TABLE IF NOT EXISTS kuliner_gambar (
 id INT UNSIGNED NOT NULL AUTO_INCREMENT,
 kuliner_id INT UNSIGNED NOT NULL,
 gambar VARCHAR(500) NOT NULL,
 urutan TINYINT UNSIGNED NOT NULL DEFAULT 1,
 created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 PRIMARY KEY (id),
 KEY idx_kuliner_gambar_kuliner (kuliner_id),
 CONSTRAINT fk_kuliner_gambar_kuliner FOREIGN KEY (kuliner_id) REFERENCES kuliner(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Pindahkan gambar utama lama ke tabel galeri agar tetap muncul sebagai foto pertama.
INSERT INTO kuliner_gambar (kuliner_id,gambar,urutan)
SELECT k.id,k.gambar,1 FROM kuliner k
WHERE k.gambar IS NOT NULL AND k.gambar <> ''
AND NOT EXISTS (SELECT 1 FROM kuliner_gambar kg WHERE kg.kuliner_id=k.id);
