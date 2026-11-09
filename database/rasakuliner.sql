-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 08, 2026 at 08:51 AM
-- Server version: 10.4.11-MariaDB
-- PHP Version: 7.2.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
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
  `judul` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `kategori` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ringkasan` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `gambar` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL
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
  `owner_user_id` int(10) UNSIGNED DEFAULT NULL,
  `nama` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `daerah` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deskripsi` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `kategori` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `gambar` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `unggulan` tinyint(1) NOT NULL DEFAULT 0,
  `status` enum('draft','pending','approved','rejected') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `submitted_at` datetime DEFAULT NULL,
  `reviewed_by` int(10) UNSIGNED DEFAULT NULL,
  `reviewed_at` datetime DEFAULT NULL,
  `rejection_reason` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `lokasi_alamat` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `latitude` decimal(10,7) DEFAULT NULL,
  `longitude` decimal(10,7) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `kuliner`
--

INSERT INTO `kuliner` (`id`, `owner_user_id`, `nama`, `daerah`, `deskripsi`, `kategori`, `gambar`, `unggulan`, `status`, `submitted_at`, `reviewed_by`, `reviewed_at`, `rejection_reason`, `created_at`, `updated_at`, `lokasi_alamat`, `latitude`, `longitude`) VALUES
(1, NULL, 'Rendang', 'Sumatera Barat', 'Daging berbumbu rempah dan santan, dimasak perlahan hingga kaya rasa.', 'Berempah', 'img/kuliner/rendang.jpg', 1, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 08:49:05', '2026-11-06 03:07:12', NULL, NULL, NULL),
(2, NULL, 'Gudeg', 'DI Yogyakarta', 'Nangka muda bersantan dengan cita rasa manis khas dapur Yogyakarta.', 'Olahan sayur', 'img/kuliner/gudeg.jpg', 1, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 08:49:05', '2026-11-06 03:07:12', NULL, NULL, NULL),
(3, NULL, 'Ayam Betutu', 'Bali', 'Ayam dengan bumbu genep yang meresap hingga ke setiap seratnya.', 'Pedas', 'img/kuliner/ayam-betutu.jpg', 1, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 08:49:05', '2026-11-06 03:07:12', NULL, NULL, NULL),
(4, NULL, 'Papeda', 'Maluku & Papua', 'Bubur sagu bertekstur lembut, nikmat dengan ikan kuah kuning.', 'Berbahan sagu', 'img/kuliner/papeda.jpg', 1, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 08:49:05', '2026-11-06 03:07:12', NULL, NULL, NULL),
(5, NULL, 'Pempek', 'Sumatera Selatan', 'Olahan ikan dan sagu dengan kuah cuko yang asam, manis, dan pedas.', 'Olahan ikan', 'img/kuliner/pempek.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 08:49:05', '2026-11-06 03:07:12', NULL, NULL, NULL),
(6, NULL, 'Coto Makassar', 'Sulawesi Selatan', 'Sup daging berkuah rempah dan kacang, disajikan bersama ketupat.', 'Berempah', 'img/kuliner/coto-makassar.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 08:49:05', '2026-11-06 03:07:12', NULL, NULL, NULL),
(7, NULL, 'Soto Banjar', 'Kalimantan Selatan', 'Soto ayam beraroma rempah hangat dengan ketupat dan perkedel.', 'Hidangan berkuah', 'img/kuliner/soto-banjar.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 08:49:05', '2026-11-06 03:07:12', NULL, NULL, NULL),
(8, NULL, 'Klepon', 'Jawa', 'Kue beras berisi gula merah, berbalut kelapa parut yang gurih.', 'Jajanan tradisional', 'img/kuliner/klepon.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 08:49:05', '2026-11-06 03:07:12', NULL, NULL, NULL),
(9, NULL, 'Se’i Sapi', 'Nusa Tenggara Timur', 'Irisan daging sapi asap dengan aroma khas, ditemani sambal lu’at.', 'Olahan daging', 'img/kuliner/sei-sapi.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 08:49:05', '2026-11-06 03:07:12', NULL, NULL, NULL),
(10, NULL, 'Soto Betawi', 'DKI Jakarta', 'Soto berkuah santan dan susu yang gurih, berisi daging sapi dan jeroan, disajikan dengan emping dan acar.', 'Hidangan berkuah', 'img/kuliner/soto-betawi.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:39', '2026-11-06 03:07:12', NULL, NULL, NULL),
(11, NULL, 'Kerak Telor', 'DKI Jakarta', 'Telur bebek dan beras ketan disangrai bersama serundeng kelapa, jajanan khas Betawi yang wangi gosong.', 'Jajanan tradisional', 'img/kuliner/kerak-telor.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:39', '2026-11-06 03:07:12', NULL, NULL, NULL),
(12, NULL, 'Gado-Gado', 'DKI Jakarta', 'Sayuran rebus, tahu, dan lontong disiram saus kacang yang kental, manis, dan gurih.', 'Olahan sayur', 'img/kuliner/gado-gado.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:39', '2026-11-06 03:07:12', NULL, NULL, NULL),
(13, NULL, 'Nasi Liwet', 'Jawa Barat', 'Nasi gurih yang ditanak bersama santan, daun salam, dan serai, dinikmati bersama ikan asin dan lalapan.', 'Nasi & lauk', 'img/kuliner/nasi-liwet.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:39', '2026-11-06 03:07:12', NULL, NULL, NULL),
(14, NULL, 'Batagor', 'Jawa Barat', 'Bakso tahu goreng berisi ikan tenggiri dengan siraman saus kacang dan jeruk limau.', 'Olahan ikan', 'img/kuliner/batagor.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:39', '2026-11-06 03:07:12', NULL, NULL, NULL),
(15, NULL, 'Sate Maranggi', 'Jawa Barat', 'Sate daging sapi atau kambing yang dimarinasi bumbu ketumbar dan kecap, dinikmati dengan sambal oncom.', 'Olahan daging', 'img/kuliner/sate-maranggi.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:39', '2026-11-06 03:07:13', NULL, NULL, NULL),
(16, NULL, 'Pepes Ikan', 'Jawa Barat', 'Ikan berbumbu kunyit dan kemangi yang dibungkus daun pisang lalu dikukus atau dibakar.', 'Olahan ikan', 'img/kuliner/pepes-ikan.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:39', '2026-11-06 03:07:13', NULL, NULL, NULL),
(17, NULL, 'Lumpia Semarang', 'Jawa Tengah', 'Kulit tipis berisi rebung, udang, dan telur, hasil perpaduan rasa Tionghoa dan Jawa di Semarang.', 'Jajanan tradisional', 'img/kuliner/lumpia-semarang.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:39', '2026-11-06 03:07:13', NULL, NULL, NULL),
(18, NULL, 'Soto Kudus', 'Jawa Tengah', 'Soto bening dengan irisan daging kerbau atau ayam, disajikan dalam mangkuk kecil yang menggoda.', 'Hidangan berkuah', 'img/kuliner/soto-kudus.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:39', '2026-11-06 03:07:13', NULL, NULL, NULL),
(19, NULL, 'Rawon', 'Jawa Timur', 'Sup daging berkuah hitam dari kluwek, ditemani tauge pendek, telur asin, dan sambal.', 'Hidangan berkuah', 'img/kuliner/rawon.jpg', 1, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:39', '2026-11-06 03:07:13', NULL, NULL, NULL),
(20, NULL, 'Rujak Cingur', 'Jawa Timur', 'Irisan cingur sapi, sayur, dan buah dalam bumbu petis, kacang, dan cabai khas Surabaya.', 'Olahan daging', 'img/kuliner/rujak-cingur.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-06 03:07:13', NULL, NULL, NULL),
(21, NULL, 'Soto Lamongan', 'Jawa Timur', 'Soto ayam berkuah kuning bening dengan taburan koya yang gurih dan sambal segar.', 'Hidangan berkuah', 'img/kuliner/soto-lamongan.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-06 03:07:13', NULL, NULL, NULL),
(22, NULL, 'Sate Madura', 'Jawa Timur', 'Sate ayam berbumbu kacang atau kecap dengan daging kecil-kecil, dibakar di atas arang.', 'Olahan daging', 'img/kuliner/sate-madura.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-06 03:07:13', NULL, NULL, NULL),
(23, NULL, 'Bakpia Pathok', 'DI Yogyakarta', 'Kue kecil berisi kacang hijau manis dengan kulit lembut, oleh-oleh andalan dari kampung Pathuk.', 'Jajanan tradisional', 'img/kuliner/bakpia-pathok.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-06 03:07:13', NULL, NULL, NULL),
(24, NULL, 'Sate Klathak', 'DI Yogyakarta', 'Sate kambing bertusuk jeruji besi yang hanya dibumbui garam, dibakar hingga harum.', 'Olahan daging', 'img/kuliner/sate-klathak.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-06 03:07:13', NULL, NULL, NULL),
(25, NULL, 'Mie Aceh', 'Aceh', 'Mi kuning tebal berbumbu kari yang pekat, dimasak bersama daging, kambing, atau seafood.', 'Berempah', 'img/kuliner/mie-aceh.jpg', 1, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-06 03:07:13', NULL, NULL, NULL),
(26, NULL, 'Ayam Tangkap', 'Aceh', 'Ayam goreng garing yang disajikan dengan daun pandan, kari, dan cabai hijau yang harum.', 'Berempah', 'img/kuliner/ayam-tangkap.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-06 03:07:13', NULL, NULL, NULL),
(27, NULL, 'Bika Ambon', 'Sumatera Utara', 'Kue berongga seperti sarang lebah dengan aroma santan dan pandan, kebanggaan Medan.', 'Jajanan tradisional', 'img/kuliner/bika-ambon.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-06 03:07:13', NULL, NULL, NULL),
(28, NULL, 'Soto Medan', 'Sumatera Utara', 'Soto berkuah santan beraroma rempah dengan potongan ayam atau daging dan perkedel.', 'Hidangan berkuah', 'img/kuliner/soto-medan.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-06 03:07:13', NULL, NULL, NULL),
(29, NULL, 'Arsik Ikan Mas', 'Sumatera Utara', 'Ikan mas berbumbu andaliman dan asam cikala, hidangan adat Batak yang segar dan berani.', 'Olahan ikan', 'img/kuliner/arsik-ikan-mas.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-06 03:07:13', NULL, NULL, NULL),
(30, NULL, 'Nasi Kapau', 'Sumatera Barat', 'Nasi dengan lauk gulai nangka, tunjang, dan dendeng yang disajikan bertingkat ala Kapau.', 'Berempah', 'img/kuliner/nasi-kapau.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-06 03:07:13', NULL, NULL, NULL),
(31, NULL, 'Sate Padang', 'Sumatera Barat', 'Sate daging sapi dengan kuah kental dari tepung beras, kunyit, dan rempah yang pedas gurih.', 'Olahan daging', 'img/kuliner/sate-padang.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-06 03:07:13', NULL, NULL, NULL),
(32, NULL, 'Tekwan', 'Sumatera Selatan', 'Bakso ikan mungil dalam kuah udang yang segar, bersama jamur, bengkoang, dan soun.', 'Hidangan berkuah', 'img/kuliner/tekwan.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-06 03:07:13', NULL, NULL, NULL),
(33, NULL, 'Pindang Patin', 'Sumatera Selatan', 'Ikan patin dalam kuah asam pedas segar dengan nanas dan tomat khas Palembang.', 'Olahan ikan', 'img/kuliner/pindang-patin.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-06 03:07:13', NULL, NULL, NULL),
(34, NULL, 'Lawar', 'Bali', 'Campuran sayur, kelapa parut, dan daging cincang dengan bumbu genep, sajian upacara dan harian.', 'Olahan sayur', 'img/kuliner/lawar.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-06 03:07:13', NULL, NULL, NULL),
(35, NULL, 'Sate Lilit', 'Bali', 'Daging ikan atau ayam cincang berbumbu kelapa, dililitkan pada batang serai lalu dibakar.', 'Olahan ikan', 'img/kuliner/sate-lilit.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-06 03:07:13', NULL, NULL, NULL),
(36, NULL, 'Ayam Taliwang', 'Nusa Tenggara Barat', 'Ayam bakar dengan sambal cabai rawit yang pedas menyengat, hidangan kebanggaan Lombok.', 'Pedas', 'img/kuliner/ayam-taliwang.jpg', 1, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-06 03:07:13', NULL, NULL, NULL),
(37, NULL, 'Plecing Kangkung', 'Nusa Tenggara Barat', 'Kangkung rebus dengan sambal tomat terasi yang segar dan pedas, taburan kacang kedelai goreng.', 'Olahan sayur', 'img/kuliner/plecing-kangkung.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-06 03:07:13', NULL, NULL, NULL),
(38, NULL, 'Konro Bakar', 'Sulawesi Selatan', 'Iga sapi bakar dengan bumbu kluwek dan rempah khas Makassar, disajikan dengan kuah konro.', 'Olahan daging', 'img/kuliner/konro-bakar.jpg', 1, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-06 03:07:13', NULL, NULL, NULL),
(39, NULL, 'Pallubasa', 'Sulawesi Selatan', 'Sup daging dan jeroan berkuah kelapa sangrai, disantap dengan telur mentah dan nasi.', 'Hidangan berkuah', 'img/kuliner/pallubasa.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-06 03:07:14', NULL, NULL, NULL),
(40, NULL, 'Es Pisang Ijo', 'Sulawesi Selatan', 'Pisang berbalut adonan hijau pandan disiram sirup, bubur sumsum, dan es serut.', 'Pencuci mulut', 'img/kuliner/es-pisang-ijo.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-06 03:07:14', NULL, NULL, NULL),
(41, NULL, 'Tinutuan', 'Sulawesi Utara', 'Bubur beras dengan labu, jagung, dan aneka sayur yang dinikmati bersama ikan asin dan sambal roa.', 'Olahan sayur', 'img/kuliner/tinutuan.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-06 03:07:14', NULL, NULL, NULL),
(42, NULL, 'Cakalang Fufu', 'Sulawesi Utara', 'Ikan cakalang yang diasap hingga harum, dimasak dengan bumbu rica-rica atau dibakar.', 'Olahan ikan', 'img/kuliner/cakalang-fufu.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-06 03:07:14', NULL, NULL, NULL),
(43, NULL, 'Ketupat Kandangan', 'Kalimantan Selatan', 'Ketupat dengan kuah santan kuning dan ikan haruan bakar, sarapan khas Kandangan.', 'Olahan ikan', 'img/kuliner/ketupat-kandangan.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-06 03:07:14', NULL, NULL, NULL),
(44, NULL, 'Amplang', 'Kalimantan Timur', 'Kerupuk ikan renyah yang gurih, camilan oleh-oleh dari Samarinda dan sekitarnya.', 'Olahan ikan', 'img/kuliner/amplang.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-06 03:07:14', NULL, NULL, NULL),
(45, NULL, 'Sagu Lempeng', 'Maluku & Papua', 'Lempengan sagu panggang yang renyah, biasa dicelup teh atau kuah ikan di meja pagi hari.', 'Berbahan sagu', 'img/kuliner/sagu-lempeng.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-06 03:07:14', NULL, NULL, NULL),
(46, NULL, 'Ikan Bakar Colo-Colo', 'Maluku & Papua', 'Ikan bakar dengan sambal colo-colo dari cabai, bawang, tomat, dan jeruk nipis yang segar.', 'Olahan ikan', 'img/kuliner/ikan-bakar-colo-colo.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-06 03:07:14', NULL, NULL, NULL),
(47, NULL, 'Jagung Bose', 'Nusa Tenggara Timur', 'Bubur jagung pulut dan kacang tanah bersantan, hidangan harian masyarakat Timor.', 'Olahan jagung', 'img/kuliner/jagung-bose.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-06 03:07:14', NULL, NULL, NULL),
(48, 1, 'Betutu Jeruk Nipis', 'Bali', 'Makanan Betutu Bali Lezat Dan Pedas', 'Makanan berat', 'img/kuliner/48/kuliner-48-20261106045313-c8413226.jpg', 0, 'approved', '2026-11-06 11:53:13', NULL, NULL, NULL, '2026-11-06 03:53:13', '2026-11-06 03:54:24', 'Jalan Tanah Lot, Pandak Gede, Kediri, Tabanan, Bali, 82121, Indonesia', '-8.5888411', '115.1229376');

-- --------------------------------------------------------

--
-- Table structure for table `kuliner_gambar`
--

CREATE TABLE `kuliner_gambar` (
  `id` int(10) UNSIGNED NOT NULL,
  `kuliner_id` int(10) UNSIGNED NOT NULL,
  `gambar` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `urutan` tinyint(3) UNSIGNED NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `kuliner_gambar`
--

INSERT INTO `kuliner_gambar` (`id`, `kuliner_id`, `gambar`, `urutan`, `created_at`) VALUES
(1, 1, 'img/kuliner/rendang.jpg', 1, '2026-11-06 03:42:35'),
(2, 2, 'img/kuliner/gudeg.jpg', 1, '2026-11-06 03:42:35'),
(3, 3, 'img/kuliner/ayam-betutu.jpg', 1, '2026-11-06 03:42:35'),
(4, 4, 'img/kuliner/papeda.jpg', 1, '2026-11-06 03:42:35'),
(5, 5, 'img/kuliner/pempek.jpg', 1, '2026-11-06 03:42:35'),
(6, 6, 'img/kuliner/coto-makassar.jpg', 1, '2026-11-06 03:42:35'),
(7, 7, 'img/kuliner/soto-banjar.jpg', 1, '2026-11-06 03:42:35'),
(8, 8, 'img/kuliner/klepon.jpg', 1, '2026-11-06 03:42:35'),
(9, 9, 'img/kuliner/sei-sapi.jpg', 1, '2026-11-06 03:42:35'),
(10, 10, 'img/kuliner/soto-betawi.jpg', 1, '2026-11-06 03:42:35'),
(11, 11, 'img/kuliner/kerak-telor.jpg', 1, '2026-11-06 03:42:35'),
(12, 12, 'img/kuliner/gado-gado.jpg', 1, '2026-11-06 03:42:35'),
(13, 13, 'img/kuliner/nasi-liwet.jpg', 1, '2026-11-06 03:42:35'),
(14, 14, 'img/kuliner/batagor.jpg', 1, '2026-11-06 03:42:35'),
(15, 15, 'img/kuliner/sate-maranggi.jpg', 1, '2026-11-06 03:42:35'),
(16, 16, 'img/kuliner/pepes-ikan.jpg', 1, '2026-11-06 03:42:35'),
(17, 17, 'img/kuliner/lumpia-semarang.jpg', 1, '2026-11-06 03:42:35'),
(18, 18, 'img/kuliner/soto-kudus.jpg', 1, '2026-11-06 03:42:35'),
(19, 19, 'img/kuliner/rawon.jpg', 1, '2026-11-06 03:42:35'),
(20, 20, 'img/kuliner/rujak-cingur.jpg', 1, '2026-11-06 03:42:35'),
(21, 21, 'img/kuliner/soto-lamongan.jpg', 1, '2026-11-06 03:42:35'),
(22, 22, 'img/kuliner/sate-madura.jpg', 1, '2026-11-06 03:42:35'),
(23, 23, 'img/kuliner/bakpia-pathok.jpg', 1, '2026-11-06 03:42:35'),
(24, 24, 'img/kuliner/sate-klathak.jpg', 1, '2026-11-06 03:42:35'),
(25, 25, 'img/kuliner/mie-aceh.jpg', 1, '2026-11-06 03:42:35'),
(26, 26, 'img/kuliner/ayam-tangkap.jpg', 1, '2026-11-06 03:42:35'),
(27, 27, 'img/kuliner/bika-ambon.jpg', 1, '2026-11-06 03:42:35'),
(28, 28, 'img/kuliner/soto-medan.jpg', 1, '2026-11-06 03:42:35'),
(29, 29, 'img/kuliner/arsik-ikan-mas.jpg', 1, '2026-11-06 03:42:35'),
(30, 30, 'img/kuliner/nasi-kapau.jpg', 1, '2026-11-06 03:42:35'),
(31, 31, 'img/kuliner/sate-padang.jpg', 1, '2026-11-06 03:42:35'),
(32, 32, 'img/kuliner/tekwan.jpg', 1, '2026-11-06 03:42:35'),
(33, 33, 'img/kuliner/pindang-patin.jpg', 1, '2026-11-06 03:42:35'),
(34, 34, 'img/kuliner/lawar.jpg', 1, '2026-11-06 03:42:35'),
(35, 35, 'img/kuliner/sate-lilit.jpg', 1, '2026-11-06 03:42:35'),
(36, 36, 'img/kuliner/ayam-taliwang.jpg', 1, '2026-11-06 03:42:35'),
(37, 37, 'img/kuliner/plecing-kangkung.jpg', 1, '2026-11-06 03:42:35'),
(38, 38, 'img/kuliner/konro-bakar.jpg', 1, '2026-11-06 03:42:35'),
(39, 39, 'img/kuliner/pallubasa.jpg', 1, '2026-11-06 03:42:35'),
(40, 40, 'img/kuliner/es-pisang-ijo.jpg', 1, '2026-11-06 03:42:35'),
(41, 41, 'img/kuliner/tinutuan.jpg', 1, '2026-11-06 03:42:35'),
(42, 42, 'img/kuliner/cakalang-fufu.jpg', 1, '2026-11-06 03:42:35'),
(43, 43, 'img/kuliner/ketupat-kandangan.jpg', 1, '2026-11-06 03:42:35'),
(44, 44, 'img/kuliner/amplang.jpg', 1, '2026-11-06 03:42:35'),
(45, 45, 'img/kuliner/sagu-lempeng.jpg', 1, '2026-11-06 03:42:35'),
(46, 46, 'img/kuliner/ikan-bakar-colo-colo.jpg', 1, '2026-11-06 03:42:35'),
(47, 47, 'img/kuliner/jagung-bose.jpg', 1, '2026-11-06 03:42:35'),
(64, 48, 'img/kuliner/48/kuliner-48-20261106045313-c8413226.jpg', 1, '2026-11-06 03:53:13'),
(65, 48, 'img/kuliner/48/kuliner-48-20261106045313-10b3587f.jpg', 2, '2026-11-06 03:53:13');

-- --------------------------------------------------------

--
-- Table structure for table `lokasi_kuliner`
--

CREATE TABLE `lokasi_kuliner` (
  `id` int(10) UNSIGNED NOT NULL,
  `kuliner_id` int(10) UNSIGNED NOT NULL,
  `nama_tempat` varchar(160) COLLATE utf8mb4_unicode_ci NOT NULL,
  `alamat` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `kota` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `latitude` decimal(10,7) NOT NULL,
  `longitude` decimal(10,7) NOT NULL,
  `jam_buka` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `kisaran_harga` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rating` decimal(2,1) DEFAULT NULL,
  `telepon` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `lokasi_kuliner`
--

INSERT INTO `lokasi_kuliner` (`id`, `kuliner_id`, `nama_tempat`, `alamat`, `kota`, `latitude`, `longitude`, `jam_buka`, `kisaran_harga`, `rating`, `telepon`, `created_at`, `updated_at`) VALUES
(1, 2, 'Warung Gudeg Wijilan', 'Jl. Wijilan, Panembahan, Kraton', 'Yogyakarta', '-7.8057000', '110.3665000', '06.00 – 21.00', 'Rp15.000 – 40.000', '4.6', NULL, '2026-11-02 09:06:42', '2026-11-02 09:06:42'),
(2, 2, 'Gudeg Pelataran Malioboro', 'Jl. Malioboro, Sosromenduran, Gedong Tengen', 'Yogyakarta', '-7.7931000', '110.3660000', '07.00 – 22.00', 'Rp20.000 – 50.000', '4.4', NULL, '2026-11-02 09:06:42', '2026-11-02 09:06:42'),
(3, 2, 'Gudeg Tugu Pagi', 'Jl. Jenderal Sudirman, Cokrodiningratan, Jetis', 'Yogyakarta', '-7.7835000', '110.3672000', '05.00 – 12.00', 'Rp12.000 – 30.000', '4.5', NULL, '2026-11-02 09:06:42', '2026-11-02 09:06:42'),
(4, 2, 'Gudeg Pasar Lama Makassar', 'Jl. Sulawesi, Ujung Pandang', 'Makassar', '-5.1330000', '119.4065000', '08.00 – 20.00', 'Rp20.000 – 45.000', '4.2', NULL, '2026-11-02 09:06:42', '2026-11-02 09:06:42'),
(5, 8, 'Jajan Pasar Beringharjo', 'Pasar Beringharjo, Jl. Margo Mulyo, Ngupasan', 'Yogyakarta', '-7.7988000', '110.3660000', '06.00 – 17.00', 'Rp5.000 – 20.000', '4.3', NULL, '2026-11-02 09:06:42', '2026-11-02 09:06:42'),
(6, 8, 'Jajan Pasar Gede Solo', 'Pasar Gede Hardjonagoro, Jl. Urip Sumoharjo, Sudiroprajan', 'Surakarta', '-7.5700000', '110.8310000', '06.00 – 17.00', 'Rp5.000 – 20.000', '4.5', NULL, '2026-11-02 09:06:42', '2026-11-02 09:06:42'),
(7, 8, 'Kue Tradisional Pasar Sentral', 'Jl. Gunung Bawakaraeng, Maloku, Ujung Pandang', 'Makassar', '-5.1371000', '119.4145000', '06.00 – 18.00', 'Rp5.000 – 15.000', '4.1', NULL, '2026-11-02 09:06:42', '2026-11-02 09:06:42'),
(8, 1, 'Rumah Makan Rendang Jam Gadang', 'Jl. Jam Gadang, Benteng Pasar Atas', 'Bukittinggi', '-0.3057000', '100.3693000', '08.00 – 21.00', 'Rp25.000 – 60.000', '4.7', NULL, '2026-11-02 09:06:42', '2026-11-02 09:06:42'),
(9, 1, 'Kedai Rendang Pantai Padang', 'Jl. Samudera, Padang Barat', 'Padang', '-0.9471000', '100.3544000', '09.00 – 22.00', 'Rp25.000 – 55.000', '4.5', NULL, '2026-11-02 09:06:42', '2026-11-02 09:06:42'),
(10, 1, 'Rumah Makan Padang Prawirotaman', 'Jl. Prawirotaman, Brontokusuman, Mergangsan', 'Yogyakarta', '-7.8185000', '110.3695000', '09.00 – 21.00', 'Rp20.000 – 45.000', '4.3', NULL, '2026-11-02 09:06:42', '2026-11-02 09:06:42'),
(11, 1, 'Rendang Padang Somba Opu', 'Jl. Somba Opu, Ujung Pandang', 'Makassar', '-5.1450000', '119.4080000', '09.00 – 22.00', 'Rp25.000 – 55.000', '4.4', NULL, '2026-11-02 09:06:42', '2026-11-02 09:06:42'),
(12, 3, 'Warung Betutu Ubud', 'Jl. Raya Ubud, Ubud, Gianyar', 'Ubud', '-8.5069000', '115.2625000', '10.00 – 21.00', 'Rp40.000 – 90.000', '4.6', NULL, '2026-11-02 09:06:42', '2026-11-02 09:06:42'),
(13, 3, 'Betutu Renon', 'Jl. Raya Puputan, Renon, Denpasar Selatan', 'Denpasar', '-8.6705000', '115.2300000', '10.00 – 22.00', 'Rp35.000 – 80.000', '4.4', NULL, '2026-11-02 09:06:42', '2026-11-02 09:06:42'),
(14, 4, 'Warung Papeda Kuah Kuning Jayapura', 'Jl. Ahmad Yani, Jayapura Utara', 'Jayapura', '-2.5337000', '140.7181000', '10.00 – 21.00', 'Rp30.000 – 70.000', '4.4', NULL, '2026-11-02 09:06:42', '2026-11-02 09:06:42'),
(15, 4, 'Papeda Kuah Kuning Ambon', 'Jl. Pantai Mardika, Sirimau', 'Ambon', '-3.6954000', '128.1814000', '10.00 – 21.00', 'Rp30.000 – 65.000', '4.5', NULL, '2026-11-02 09:06:42', '2026-11-02 09:06:42'),
(16, 5, 'Pempek Dekat Ampera', 'Jl. Sultan Mahmud Badaruddin II, Seberang Ulu', 'Palembang', '-2.9912000', '104.7630000', '08.00 – 21.00', 'Rp15.000 – 45.000', '4.7', NULL, '2026-11-02 09:06:42', '2026-11-02 09:06:42'),
(17, 5, 'Pempek Panakkukang', 'Jl. Boulevard, Panakkukang', 'Makassar', '-5.1566000', '119.4460000', '10.00 – 21.00', 'Rp20.000 – 50.000', '4.3', NULL, '2026-11-02 09:06:42', '2026-11-02 09:06:42'),
(18, 6, 'Coto Pantai Losari', 'Jl. Penghibur, Losari, Ujung Pandang', 'Makassar', '-5.1424000', '119.4066000', '07.00 – 22.00', 'Rp25.000 – 55.000', '4.6', NULL, '2026-11-02 09:06:42', '2026-11-02 09:06:42'),
(19, 6, 'Coto Nusantara Ratulangi', 'Jl. Dr. Sam Ratulangi, Mario', 'Makassar', '-5.1583000', '119.4141000', '06.00 – 16.00', 'Rp22.000 – 50.000', '4.5', NULL, '2026-11-02 09:06:42', '2026-11-02 09:06:42'),
(20, 6, 'Coto Panakkukang', 'Jl. Pengayoman, Panakkukang', 'Makassar', '-5.1557000', '119.4468000', '07.00 – 21.00', 'Rp22.000 – 50.000', '4.4', NULL, '2026-11-02 09:06:42', '2026-11-02 09:06:42'),
(21, 7, 'Soto Banjar Siring Martapura', 'Jl. Piere Tendean, Banjarmasin Tengah', 'Banjarmasin', '-3.3230000', '114.5900000', '06.00 – 15.00', 'Rp18.000 – 40.000', '4.6', NULL, '2026-11-02 09:06:42', '2026-11-02 09:06:42'),
(22, 7, 'Soto Banjar Pasar Lama', 'Jl. Pasar Lama, Banjarmasin Tengah', 'Banjarmasin', '-3.3180000', '114.5930000', '06.00 – 14.00', 'Rp15.000 – 35.000', '4.4', NULL, '2026-11-02 09:06:42', '2026-11-02 09:06:42'),
(23, 9, 'Se\'i Sapi Kupang Kota', 'Jl. El Tari, Oebobo', 'Kupang', '-10.1718000', '123.6070000', '10.00 – 22.00', 'Rp35.000 – 80.000', '4.6', NULL, '2026-11-02 09:06:42', '2026-11-02 09:06:42'),
(24, 9, 'Se\'i Lopo Oebobo', 'Jl. Timor Raya, Oebobo', 'Kupang', '-10.1580000', '123.6000000', '10.00 – 21.00', 'Rp35.000 – 75.000', '4.4', NULL, '2026-11-02 09:06:42', '2026-11-02 09:06:42'),
(25, 10, 'Soto Betawi H. Ma\'ruf', 'Jl. Kebon Sirih, Menteng', 'Jakarta', '-6.1853000', '106.8296000', '07.00 – 21.00', 'Rp30.000 – 60.000', '4.5', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(26, 10, 'Soto Betawi Pasar Baru', 'Jl. Pasar Baru, Sawah Besar', 'Jakarta', '-6.1642000', '106.8352000', '08.00 – 20.00', 'Rp28.000 – 55.000', '4.3', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(27, 11, 'Kerak Telor Monas', 'Kawasan Monas, Gambir', 'Jakarta', '-6.1754000', '106.8272000', '10.00 – 22.00', 'Rp20.000 – 35.000', '4.2', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(28, 12, 'Gado-Gado Boplo', 'Jl. Gereja Theresia, Menteng', 'Jakarta', '-6.1887000', '106.8333000', '09.00 – 20.00', 'Rp20.000 – 40.000', '4.5', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(29, 13, 'Nasi Liwet Sunda Dago', 'Jl. Ir. H. Juanda (Dago), Coblong', 'Bandung', '-6.8847000', '107.6134000', '10.00 – 22.00', 'Rp25.000 – 60.000', '4.4', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(30, 14, 'Batagor Kingsley', 'Jl. Veteran, Sumur Bandung', 'Bandung', '-6.9168000', '107.6128000', '09.00 – 21.00', 'Rp20.000 – 45.000', '4.5', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(31, 14, 'Batagor Riri', 'Jl. Burangrang, Lengkong', 'Bandung', '-6.9239000', '107.6194000', '09.00 – 20.00', 'Rp18.000 – 40.000', '4.4', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(32, 15, 'Sate Maranggi Cibungur', 'Jl. Veteran, Purwakarta', 'Purwakarta', '-6.5561000', '107.4431000', '09.00 – 22.00', 'Rp35.000 – 80.000', '4.6', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(33, 16, 'Pepes Ikan Ibu Eha', 'Jl. Riau, Bandung Wetan', 'Bandung', '-6.9055000', '107.6177000', '10.00 – 21.00', 'Rp25.000 – 55.000', '4.3', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(34, 17, 'Lumpia Gang Lombok', 'Jl. Gang Lombok, Semarang Tengah', 'Semarang', '-6.9724000', '110.4264000', '08.00 – 17.00', 'Rp15.000 – 35.000', '4.6', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(35, 18, 'Soto Kudus Kauman', 'Jl. Sunan Kudus, Kota Kudus', 'Kudus', '-6.8048000', '110.8405000', '06.00 – 17.00', 'Rp15.000 – 35.000', '4.5', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(36, 19, 'Rawon Nguling', 'Jl. Embong Malang, Genteng', 'Surabaya', '-7.2616000', '112.7382000', '08.00 – 21.00', 'Rp25.000 – 50.000', '4.5', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(37, 19, 'Rawon Setan', 'Jl. Embong Malang, Genteng', 'Surabaya', '-7.2625000', '112.7355000', '17.00 – 03.00', 'Rp28.000 – 55.000', '4.4', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(38, 20, 'Rujak Cingur Genteng Durasim', 'Jl. Genteng Durasim, Genteng', 'Surabaya', '-7.2584000', '112.7421000', '09.00 – 21.00', 'Rp20.000 – 40.000', '4.4', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(39, 21, 'Soto Lamongan Cak Har', 'Jl. Basuki Rahmat, Surabaya', 'Surabaya', '-7.2663000', '112.7415000', '07.00 – 22.00', 'Rp18.000 – 40.000', '4.3', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(40, 22, 'Sate Madura Pak Slamet', 'Jl. Wonokromo, Surabaya', 'Surabaya', '-7.3032000', '112.7348000', '16.00 – 23.00', 'Rp25.000 – 55.000', '4.3', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(41, 23, 'Bakpia Pathok 25', 'Jl. Aip KS Tubun, Ngampilan', 'Yogyakarta', '-7.7922000', '110.3582000', '08.00 – 21.00', 'Rp30.000 – 80.000', '4.6', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(42, 24, 'Sate Klathak Pak Pong', 'Pasar Wonokromo, Pleret, Bantul', 'Bantul', '-7.8553000', '110.4012000', '17.00 – 23.00', 'Rp30.000 – 70.000', '4.7', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(43, 25, 'Mie Razali', 'Jl. T. Panglima Polem, Banda Aceh', 'Banda Aceh', '5.5562000', '95.3203000', '11.00 – 02.00', 'Rp25.000 – 60.000', '4.6', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(44, 25, 'Mie Aceh Titi Bobrok', 'Jl. Panglima Polem, Banda Aceh', 'Banda Aceh', '5.5489000', '95.3224000', '10.00 – 23.00', 'Rp25.000 – 55.000', '4.5', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(45, 26, 'Ayam Tangkap Lampineung', 'Jl. Teuku Umar, Banda Aceh', 'Banda Aceh', '5.5546000', '95.3071000', '10.00 – 22.00', 'Rp30.000 – 65.000', '4.4', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(46, 27, 'Bika Ambon Zulaikha', 'Jl. Mojopahit, Medan Petisah', 'Medan', '3.5896000', '98.6598000', '08.00 – 21.00', 'Rp40.000 – 120.000', '4.7', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(47, 28, 'Soto Kesawan', 'Jl. Ahmad Yani, Medan Barat', 'Medan', '3.5872000', '98.6745000', '07.00 – 17.00', 'Rp20.000 – 45.000', '4.3', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(48, 29, 'Arsik Ikan Mas Parapat', 'Jl. Siantar, Parapat', 'Parapat', '2.6662000', '98.9357000', '09.00 – 21.00', 'Rp40.000 – 90.000', '4.5', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(49, 30, 'Nasi Kapau Pasar Atas', 'Pasar Atas, Bukittinggi', 'Bukittinggi', '-0.3064000', '100.3703000', '07.00 – 18.00', 'Rp25.000 – 55.000', '4.6', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(50, 31, 'Sate Padang Ajo Ramon', 'Jl. Pondok, Padang Barat', 'Padang', '-0.9507000', '100.3552000', '10.00 – 22.00', 'Rp25.000 – 50.000', '4.5', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(51, 32, 'Tekwan Model 26 Ilir', 'Jl. Kolonel Atmo, Palembang', 'Palembang', '-2.9811000', '104.7546000', '08.00 – 20.00', 'Rp15.000 – 40.000', '4.4', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(52, 33, 'Pindang Patin Pegagan', 'Jl. Pegagan, Palembang', 'Palembang', '-2.9761000', '104.7754000', '10.00 – 21.00', 'Rp30.000 – 65.000', '4.4', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(53, 34, 'Warung Lawar Kesiman', 'Jl. Kesiman, Denpasar Timur', 'Denpasar', '-8.6531000', '115.2393000', '08.00 – 20.00', 'Rp25.000 – 55.000', '4.4', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(54, 35, 'Sate Lilit Jimbaran', 'Jl. Four Seasons, Jimbaran', 'Jimbaran', '-8.7878000', '115.1659000', '11.00 – 22.00', 'Rp35.000 – 80.000', '4.5', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(55, 36, 'Ayam Taliwang Irama', 'Jl. Pelikan, Mataram', 'Mataram', '-8.5856000', '116.1128000', '10.00 – 22.00', 'Rp35.000 – 75.000', '4.6', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(56, 36, 'Ayam Taliwang Moerad', 'Jl. Sriwijaya, Mataram', 'Mataram', '-8.5783000', '116.1007000', '10.00 – 22.00', 'Rp35.000 – 70.000', '4.5', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(57, 37, 'Plecing Kangkung Bu Nur', 'Jl. Pejanggik, Mataram', 'Mataram', '-8.5898000', '116.1133000', '09.00 – 21.00', 'Rp15.000 – 35.000', '4.3', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(58, 38, 'Konro Karebosi', 'Jl. Karebosi, Ujung Pandang', 'Makassar', '-5.1405000', '119.4094000', '10.00 – 22.00', 'Rp45.000 – 100.000', '4.6', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(59, 38, 'Konro Bakar Daeng Ngawing', 'Jl. Lombok, Wajo', 'Makassar', '-5.1272000', '119.4156000', '10.00 – 22.00', 'Rp40.000 – 95.000', '4.5', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(60, 39, 'Pallubasa Serigala', 'Jl. Serigala, Makassar', 'Makassar', '-5.1399000', '119.4172000', '06.00 – 15.00', 'Rp25.000 – 55.000', '4.5', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(61, 40, 'Es Pisang Ijo Losari', 'Jl. Penghibur, Losari', 'Makassar', '-5.1436000', '119.4064000', '10.00 – 23.00', 'Rp12.000 – 30.000', '4.4', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(62, 41, 'Bubur Manado Wakeke', 'Jl. Wakeke, Manado', 'Manado', '1.4748000', '124.8421000', '06.00 – 14.00', 'Rp15.000 – 35.000', '4.4', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(63, 42, 'Cakalang Fufu Pasar Bersehati', 'Pasar Bersehati, Manado', 'Manado', '1.4967000', '124.8463000', '07.00 – 20.00', 'Rp25.000 – 60.000', '4.5', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(64, 43, 'Ketupat Kandangan Banjarmasin', 'Jl. Pasar Baru, Banjarmasin', 'Banjarmasin', '-3.3199000', '114.5934000', '06.00 – 13.00', 'Rp20.000 – 45.000', '4.4', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(65, 44, 'Amplang Samarinda Citra Niaga', 'Jl. Niaga Selatan, Samarinda', 'Samarinda', '-0.5042000', '117.1494000', '09.00 – 20.00', 'Rp20.000 – 60.000', '4.3', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(66, 45, 'Sagu Lempeng Pasar Mardika', 'Pasar Mardika, Ambon', 'Ambon', '-3.6931000', '128.1777000', '06.00 – 17.00', 'Rp10.000 – 25.000', '4.2', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(67, 46, 'Ikan Bakar Pantai Losari Ambon', 'Jl. Pantai Mardika, Ambon', 'Ambon', '-3.6964000', '128.1829000', '10.00 – 22.00', 'Rp35.000 – 85.000', '4.5', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41'),
(68, 47, 'Jagung Bose Kupang', 'Jl. Timor Raya, Kupang', 'Kupang', '-10.1735000', '123.6068000', '07.00 – 16.00', 'Rp15.000 – 35.000', '4.3', NULL, '2026-11-02 09:36:41', '2026-11-02 09:36:41');

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` int(10) UNSIGNED NOT NULL,
  `slug` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nama` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deskripsi` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `permissions`
--

INSERT INTO `permissions` (`id`, `slug`, `nama`, `deskripsi`) VALUES
(1, 'kuliner.view_published', 'Melihat kuliner terbit', 'Melihat daftar kuliner yang telah disetujui'),
(2, 'kuliner.create', 'Membuat pengajuan kuliner', 'Membuat data kuliner baru'),
(3, 'kuliner.update_own', 'Mengubah kuliner sendiri', 'Mengubah data kuliner milik sendiri'),
(4, 'kuliner.submit', 'Mengirim pengajuan kuliner', 'Mengirim data kuliner untuk ditinjau admin'),
(5, 'kuliner.review', 'Meninjau kuliner', 'Menyetujui atau menolak pengajuan kuliner'),
(6, 'kuliner.manage', 'Mengelola semua kuliner', 'Mengelola seluruh data kuliner'),
(7, 'seller.verify', 'Memverifikasi seller', 'Menyetujui atau menolak profil seller'),
(8, 'user.manage', 'Mengelola pengguna', 'Mengelola akun dan penetapan peran pengguna'),
(9, 'role.manage', 'Mengelola peran dan izin', 'Mengelola role dan permission');

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `id` int(10) UNSIGNED NOT NULL,
  `kuliner_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `nama_pengunjung` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rating` tinyint(3) UNSIGNED NOT NULL,
  `komentar` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` int(10) UNSIGNED NOT NULL,
  `slug` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nama` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `deskripsi` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `slug`, `nama`, `deskripsi`, `created_at`) VALUES
(1, 'user', 'Pengguna', 'Akun pengguna umum', '2026-11-02 08:49:05'),
(2, 'seller', 'Seller/Promotor', 'Mengajukan dan mengelola data kuliner miliknya', '2026-11-02 08:49:05'),
(3, 'admin', 'Administrator', 'Mengelola pengguna dan meninjau pengajuan kuliner', '2026-11-02 08:49:05');

-- --------------------------------------------------------

--
-- Table structure for table `role_permissions`
--

CREATE TABLE `role_permissions` (
  `role_id` int(10) UNSIGNED NOT NULL,
  `permission_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `role_permissions`
--

INSERT INTO `role_permissions` (`role_id`, `permission_id`) VALUES
(1, 1),
(2, 1),
(2, 2),
(2, 3),
(2, 4),
(3, 1),
(3, 2),
(3, 3),
(3, 4),
(3, 5),
(3, 6),
(3, 7),
(3, 8),
(3, 9);

-- --------------------------------------------------------

--
-- Table structure for table `seller_email_actions`
--

CREATE TABLE `seller_email_actions` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `token_hash` char(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expires_at` datetime NOT NULL,
  `used_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `seller_profiles`
--

CREATE TABLE `seller_profiles` (
  `user_id` int(10) UNSIGNED NOT NULL,
  `nama_usaha` varchar(160) COLLATE utf8mb4_unicode_ci NOT NULL,
  `jenis_usaha` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nomor_telepon` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `alamat` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `foto_profil` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `verification_status` enum('pending','verified','rejected') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `verified_by` int(10) UNSIGNED DEFAULT NULL,
  `verified_at` datetime DEFAULT NULL,
  `rejection_reason` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `seller_profiles`
--

INSERT INTO `seller_profiles` (`user_id`, `nama_usaha`, `jenis_usaha`, `nomor_telepon`, `alamat`, `foto_profil`, `verification_status`, `verified_by`, `verified_at`, `rejection_reason`, `created_at`, `updated_at`) VALUES
(1, 'Warung Oke', 'Makanan Betutu', '085847872972', 'Jl. Srikandi, Benoa, Kabupaten Badung', '/uploads/profil/foto_profil-20261106042725-933143b5d9.jpg', 'pending', NULL, NULL, NULL, '2026-11-06 02:52:00', '2026-11-06 03:27:25'),
(6, 'Ayam Taliwang Lombok', 'Makanan berat', '085837213871', 'Nusa Dua', NULL, 'pending', NULL, NULL, NULL, '2026-11-08 07:45:54', '2026-11-08 07:45:54');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `nama` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(190) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('active','inactive','suspended') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `email_verified_at` datetime DEFAULT NULL,
  `last_login_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `nama`, `email`, `password_hash`, `status`, `email_verified_at`, `last_login_at`, `created_at`, `updated_at`) VALUES
(1, 'Caesar', 'caesarramandhika@gmail.com', '$2y$10$cSdJardMhzb9lf7IyOYL7uxe.HRjqW6J/.zMECQztXUKfdmB.lj/G', 'active', NULL, '2026-11-06 10:56:16', '2026-11-06 02:52:00', '2026-11-06 02:56:16'),
(6, 'Rama', 'ramagm841@gmail.com', '$2y$10$l/FUOa/8bji/0wtPhD8goOsmRiVoZGfmVyhOa4SJzpeItIGcl03pW', 'active', NULL, NULL, '2026-11-08 07:45:54', '2026-11-08 07:45:54');

-- --------------------------------------------------------

--
-- Table structure for table `user_roles`
--

CREATE TABLE `user_roles` (
  `user_id` int(10) UNSIGNED NOT NULL,
  `role_id` int(10) UNSIGNED NOT NULL,
  `assigned_by` int(10) UNSIGNED DEFAULT NULL,
  `assigned_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_roles`
--

INSERT INTO `user_roles` (`user_id`, `role_id`, `assigned_by`, `assigned_at`) VALUES
(1, 2, NULL, '2026-11-06 02:52:00');

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
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_kuliner_status_created` (`status`,`created_at`),
  ADD KEY `idx_kuliner_owner_status` (`owner_user_id`,`status`),
  ADD KEY `fk_kuliner_reviewer` (`reviewed_by`);

--
-- Indexes for table `kuliner_gambar`
--
ALTER TABLE `kuliner_gambar`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_kuliner_gambar_kuliner` (`kuliner_id`);

--
-- Indexes for table `lokasi_kuliner`
--
ALTER TABLE `lokasi_kuliner`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_lokasi_kuliner_tempat` (`kuliner_id`,`nama_tempat`),
  ADD KEY `idx_lokasi_koordinat` (`latitude`,`longitude`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_reviews_kuliner` (`kuliner_id`),
  ADD KEY `fk_reviews_user` (`user_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Indexes for table `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD PRIMARY KEY (`role_id`,`permission_id`),
  ADD KEY `idx_role_permissions_permission` (`permission_id`);

--
-- Indexes for table `seller_email_actions`
--
ALTER TABLE `seller_email_actions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_seller_email_actions_token` (`token_hash`),
  ADD KEY `idx_seller_email_actions_user` (`user_id`);

--
-- Indexes for table `seller_profiles`
--
ALTER TABLE `seller_profiles`
  ADD PRIMARY KEY (`user_id`),
  ADD KEY `fk_seller_profiles_verifier` (`verified_by`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `user_roles`
--
ALTER TABLE `user_roles`
  ADD PRIMARY KEY (`user_id`,`role_id`),
  ADD KEY `idx_user_roles_role` (`role_id`),
  ADD KEY `fk_user_roles_assigner` (`assigned_by`);

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
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT for table `kuliner_gambar`
--
ALTER TABLE `kuliner_gambar`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=66;

--
-- AUTO_INCREMENT for table `lokasi_kuliner`
--
ALTER TABLE `lokasi_kuliner`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=69;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `seller_email_actions`
--
ALTER TABLE `seller_email_actions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `kuliner`
--
ALTER TABLE `kuliner`
  ADD CONSTRAINT `fk_kuliner_owner` FOREIGN KEY (`owner_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_kuliner_reviewer` FOREIGN KEY (`reviewed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `kuliner_gambar`
--
ALTER TABLE `kuliner_gambar`
  ADD CONSTRAINT `fk_kuliner_gambar_kuliner` FOREIGN KEY (`kuliner_id`) REFERENCES `kuliner` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `lokasi_kuliner`
--
ALTER TABLE `lokasi_kuliner`
  ADD CONSTRAINT `fk_lokasi_kuliner` FOREIGN KEY (`kuliner_id`) REFERENCES `kuliner` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `fk_reviews_kuliner` FOREIGN KEY (`kuliner_id`) REFERENCES `kuliner` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_reviews_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD CONSTRAINT `fk_role_permissions_permission` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_role_permissions_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `seller_email_actions`
--
ALTER TABLE `seller_email_actions`
  ADD CONSTRAINT `fk_seller_email_actions_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `seller_profiles`
--
ALTER TABLE `seller_profiles`
  ADD CONSTRAINT `fk_seller_profiles_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_seller_profiles_verifier` FOREIGN KEY (`verified_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `user_roles`
--
ALTER TABLE `user_roles`
  ADD CONSTRAINT `fk_user_roles_assigner` FOREIGN KEY (`assigned_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_user_roles_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_user_roles_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
