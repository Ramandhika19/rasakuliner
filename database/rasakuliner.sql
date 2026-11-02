CREATE DATABASE IF NOT EXISTS rasakuliner CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE rasakuliner;

DROP TABLE IF EXISTS cerita;
DROP TABLE IF EXISTS kuliner;

CREATE TABLE kuliner (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(120) NOT NULL,
  daerah VARCHAR(100) NOT NULL,
  deskripsi TEXT NOT NULL,
  kategori VARCHAR(80) NOT NULL,
  gambar VARCHAR(500) NOT NULL,
  unggulan TINYINT(1) NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

INSERT INTO kuliner (nama, daerah, deskripsi, kategori, gambar, unggulan) VALUES
('Rendang','Sumatera Barat','Daging berbumbu rempah dan santan, dimasak perlahan hingga kaya rasa.','Berempah','https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?auto=format&fit=crop&w=900&q=85',1),
('Gudeg','DI Yogyakarta','Nangka muda bersantan dengan cita rasa manis khas dapur Yogyakarta.','Olahan sayur','https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=900&q=85',1),
('Ayam Betutu','Bali','Ayam dengan bumbu genep yang meresap hingga ke setiap seratnya.','Pedas','https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=900&q=85',1),
('Papeda','Maluku & Papua','Bubur sagu bertekstur lembut, nikmat dengan ikan kuah kuning.','Berbahan sagu','https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=900&q=85',1),
('Pempek','Sumatera Selatan','Olahan ikan dan sagu dengan kuah cuko yang asam, manis, dan pedas.','Olahan ikan','https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=900&q=85',0),
('Coto Makassar','Sulawesi Selatan','Sup daging berkuah rempah dan kacang, disajikan bersama ketupat.','Berempah','https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=900&q=85',0),
('Soto Banjar','Kalimantan Selatan','Soto ayam beraroma rempah hangat dengan ketupat dan perkedel.','Hidangan berkuah','https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=900&q=85',0),
('Klepon','Jawa','Kue beras berisi gula merah, berbalut kelapa parut yang gurih.','Jajanan tradisional','https://images.unsplash.com/photo-1563805042-7684c019e1cb?auto=format&fit=crop&w=900&q=85',0),
('Se’i Sapi','Nusa Tenggara Timur','Irisan daging sapi asap dengan aroma khas, ditemani sambal lu’at.','Olahan daging','https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=900&q=85',0);

CREATE TABLE cerita (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  judul VARCHAR(180) NOT NULL,
  kategori VARCHAR(80) NOT NULL,
  ringkasan TEXT NOT NULL,
  gambar VARCHAR(500) NOT NULL
) ENGINE=InnoDB;

INSERT INTO cerita (judul,kategori,ringkasan,gambar) VALUES
('Rempah yang menyatukan meja Nusantara','Bahan & tradisi','Mengenal bumbu yang berpindah dari satu dapur ke dapur lain, menjadi pengikat ingatan dan rasa.','https://images.unsplash.com/photo-1532336414038-cf19250c5757?auto=format&fit=crop&w=900&q=85'),
('Tumpeng: doa yang disajikan bersama','Cerita di balik rasa','Bukan hanya nasi berbentuk kerucut. Ada makna kebersamaan dalam setiap lauk yang mengelilinginya.','https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=900&q=85'),
('Sagu, kehidupan dari timur Indonesia','Catatan pangan','Menelusuri kedekatan sagu dengan keseharian dan tradisi masyarakat Maluku dan Papua.','https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=900&q=85');
