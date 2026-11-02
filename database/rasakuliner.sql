-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 02, 2026 at 03:16 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `rasakuliner`
--

-- --------------------------------------------------------

--
-- Table structure for table `cerita`
--

CREATE TABLE `cerita` (
  `id` int(10) UNSIGNED NOT NULL,
  `judul` varchar(180) NOT NULL,
  `kategori` varchar(80) NOT NULL,
  `ringkasan` text NOT NULL,
  `gambar` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cerita`
--

INSERT INTO `cerita` (`id`, `judul`, `kategori`, `ringkasan`, `gambar`) VALUES
(1, 'Rempah yang menyatukan meja Nusantara', 'Bahan & tradisi', 'Mengenal bumbu yang berpindah dari satu dapur ke dapur lain, menjadi pengikat ingatan dan rasa.', 'https://images.unsplash.com/photo-1532336414038-cf19250c5757?auto=format&fit=crop&w=900&q=85'),
(2, 'Tumpeng: doa yang disajikan bersama', 'Cerita di balik rasa', 'Bukan hanya nasi berbentuk kerucut. Ada makna kebersamaan dalam setiap lauk yang mengelilinginya.', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=900&q=85'),
(3, 'Sagu, kehidupan dari timur Indonesia', 'Catatan pangan', 'Menelusuri kedekatan sagu dengan keseharian dan tradisi masyarakat Maluku dan Papua.', 'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=900&q=85');

-- --------------------------------------------------------

--
-- Table structure for table `kuliner`
--

CREATE TABLE `kuliner` (
  `id` int(10) UNSIGNED NOT NULL,
  `nama` varchar(120) NOT NULL,
  `daerah` varchar(100) NOT NULL,
  `deskripsi` text NOT NULL,
  `kategori` varchar(80) NOT NULL,
  `gambar` varchar(500) NOT NULL,
  `unggulan` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `kuliner`
--

INSERT INTO `kuliner` (`id`, `nama`, `daerah`, `deskripsi`, `kategori`, `gambar`, `unggulan`, `created_at`) VALUES
(1, 'Rendang', 'Sumatera Barat', 'Daging berbumbu rempah dan santan, dimasak perlahan hingga kaya rasa.', 'Berempah', 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?auto=format&fit=crop&w=900&q=85', 1, '2026-11-02 02:15:38'),
(2, 'Gudeg', 'DI Yogyakarta', 'Nangka muda bersantan dengan cita rasa manis khas dapur Yogyakarta.', 'Olahan sayur', 'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=900&q=85', 1, '2026-11-02 02:15:38'),
(3, 'Ayam Betutu', 'Bali', 'Ayam dengan bumbu genep yang meresap hingga ke setiap seratnya.', 'Pedas', 'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=900&q=85', 1, '2026-11-02 02:15:38'),
(4, 'Papeda', 'Maluku & Papua', 'Bubur sagu bertekstur lembut, nikmat dengan ikan kuah kuning.', 'Berbahan sagu', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=900&q=85', 1, '2026-11-02 02:15:38'),
(5, 'Pempek', 'Sumatera Selatan', 'Olahan ikan dan sagu dengan kuah cuko yang asam, manis, dan pedas.', 'Olahan ikan', 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=900&q=85', 0, '2026-11-02 02:15:38'),
(6, 'Coto Makassar', 'Sulawesi Selatan', 'Sup daging berkuah rempah dan kacang, disajikan bersama ketupat.', 'Berempah', 'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=900&q=85', 0, '2026-11-02 02:15:38'),
(7, 'Soto Banjar', 'Kalimantan Selatan', 'Soto ayam beraroma rempah hangat dengan ketupat dan perkedel.', 'Hidangan berkuah', 'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=900&q=85', 0, '2026-11-02 02:15:38'),
(8, 'Klepon', 'Jawa', 'Kue beras berisi gula merah, berbalut kelapa parut yang gurih.', 'Jajanan tradisional', 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?auto=format&fit=crop&w=900&q=85', 0, '2026-11-02 02:15:38'),
(9, 'Se’i Sapi', 'Nusa Tenggara Timur', 'Irisan daging sapi asap dengan aroma khas, ditemani sambal lu’at.', 'Olahan daging', 'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=900&q=85', 0, '2026-11-02 02:15:38'),
(10, 'teste', 'tes', 'tes', '', '', 0, '2026-11-02 02:16:02');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cerita`
--
ALTER TABLE `cerita`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `kuliner`
--
ALTER TABLE `kuliner`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cerita`
--
ALTER TABLE `cerita`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `kuliner`
--
ALTER TABLE `kuliner`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
