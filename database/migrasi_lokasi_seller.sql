-- Jalankan sekali di phpMyAdmin pada database rasakuliner.
-- Menambahkan alamat dan koordinat titik kuliner untuk peta seller.
ALTER TABLE kuliner
  ADD COLUMN IF NOT EXISTS lokasi_alamat VARCHAR(500) NULL,
  ADD COLUMN IF NOT EXISTS latitude DECIMAL(10,7) NULL,
  ADD COLUMN IF NOT EXISTS longitude DECIMAL(10,7) NULL;
