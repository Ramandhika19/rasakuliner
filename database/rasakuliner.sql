-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 02, 2026 at 10:45 AM
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
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `kuliner`
--

INSERT INTO `kuliner` (`id`, `owner_user_id`, `nama`, `daerah`, `deskripsi`, `kategori`, `gambar`, `unggulan`, `status`, `submitted_at`, `reviewed_by`, `reviewed_at`, `rejection_reason`, `created_at`, `updated_at`) VALUES
(1, NULL, 'Rendang', 'Sumatera Barat', 'Daging berbumbu rempah dan santan, dimasak perlahan hingga kaya rasa.', 'Berempah', 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?auto=format&fit=crop&w=900&q=85', 1, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 08:49:05', '2026-11-02 08:49:05'),
(2, NULL, 'Gudeg', 'DI Yogyakarta', 'Nangka muda bersantan dengan cita rasa manis khas dapur Yogyakarta.', 'Olahan sayur', 'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=900&q=85', 1, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 08:49:05', '2026-11-02 08:49:05'),
(3, NULL, 'Ayam Betutu', 'Bali', 'Ayam dengan bumbu genep yang meresap hingga ke setiap seratnya.', 'Pedas', 'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=900&q=85', 1, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 08:49:05', '2026-11-02 08:49:05'),
(4, NULL, 'Papeda', 'Maluku & Papua', 'Bubur sagu bertekstur lembut, nikmat dengan ikan kuah kuning.', 'Berbahan sagu', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=900&q=85', 1, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 08:49:05', '2026-11-02 08:49:05'),
(5, NULL, 'Pempek', 'Sumatera Selatan', 'Olahan ikan dan sagu dengan kuah cuko yang asam, manis, dan pedas.', 'Olahan ikan', 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 08:49:05', '2026-11-02 08:49:05'),
(6, NULL, 'Coto Makassar', 'Sulawesi Selatan', 'Sup daging berkuah rempah dan kacang, disajikan bersama ketupat.', 'Berempah', 'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 08:49:05', '2026-11-02 08:49:05'),
(7, NULL, 'Soto Banjar', 'Kalimantan Selatan', 'Soto ayam beraroma rempah hangat dengan ketupat dan perkedel.', 'Hidangan berkuah', 'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 08:49:05', '2026-11-02 08:49:05'),
(8, NULL, 'Klepon', 'Jawa', 'Kue beras berisi gula merah, berbalut kelapa parut yang gurih.', 'Jajanan tradisional', 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 08:49:05', '2026-11-02 08:49:05'),
(9, NULL, 'Se’i Sapi', 'Nusa Tenggara Timur', 'Irisan daging sapi asap dengan aroma khas, ditemani sambal lu’at.', 'Olahan daging', 'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 08:49:05', '2026-11-02 08:49:05'),
(10, NULL, 'Soto Betawi', 'DKI Jakarta', 'Soto berkuah santan dan susu yang gurih, berisi daging sapi dan jeroan, disajikan dengan emping dan acar.', 'Hidangan berkuah', 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:39', '2026-11-02 09:36:40'),
(11, NULL, 'Kerak Telor', 'DKI Jakarta', 'Telur bebek dan beras ketan disangrai bersama serundeng kelapa, jajanan khas Betawi yang wangi gosong.', 'Jajanan tradisional', 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:39', '2026-11-02 09:36:40'),
(12, NULL, 'Gado-Gado', 'DKI Jakarta', 'Sayuran rebus, tahu, dan lontong disiram saus kacang yang kental, manis, dan gurih.', 'Olahan sayur', 'https://images.unsplash.com/photo-1512058564366-18510be2db19?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:39', '2026-11-02 09:36:40'),
(13, NULL, 'Nasi Liwet', 'Jawa Barat', 'Nasi gurih yang ditanak bersama santan, daun salam, dan serai, dinikmati bersama ikan asin dan lalapan.', 'Nasi & lauk', 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:39', '2026-11-02 09:36:40'),
(14, NULL, 'Batagor', 'Jawa Barat', 'Bakso tahu goreng berisi ikan tenggiri dengan siraman saus kacang dan jeruk limau.', 'Olahan ikan', 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:39', '2026-11-02 09:36:40'),
(15, NULL, 'Sate Maranggi', 'Jawa Barat', 'Sate daging sapi atau kambing yang dimarinasi bumbu ketumbar dan kecap, dinikmati dengan sambal oncom.', 'Olahan daging', 'https://images.unsplash.com/photo-1498837167922-ddd27525d352?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:39', '2026-11-02 09:36:40'),
(16, NULL, 'Pepes Ikan', 'Jawa Barat', 'Ikan berbumbu kunyit dan kemangi yang dibungkus daun pisang lalu dikukus atau dibakar.', 'Olahan ikan', 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:39', '2026-11-02 09:36:40'),
(17, NULL, 'Lumpia Semarang', 'Jawa Tengah', 'Kulit tipis berisi rebung, udang, dan telur, hasil perpaduan rasa Tionghoa dan Jawa di Semarang.', 'Jajanan tradisional', 'https://images.unsplash.com/photo-1574484284002-952d92456975?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:39', '2026-11-02 09:36:40'),
(18, NULL, 'Soto Kudus', 'Jawa Tengah', 'Soto bening dengan irisan daging kerbau atau ayam, disajikan dalam mangkuk kecil yang menggoda.', 'Hidangan berkuah', 'https://images.unsplash.com/photo-1476224203421-9ac39bcb3327?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:39', '2026-11-02 09:36:40'),
(19, NULL, 'Rawon', 'Jawa Timur', 'Sup daging berkuah hitam dari kluwek, ditemani tauge pendek, telur asin, dan sambal.', 'Hidangan berkuah', 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?auto=format&fit=crop&w=900&q=85', 1, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:39', '2026-11-02 09:36:40'),
(20, NULL, 'Rujak Cingur', 'Jawa Timur', 'Irisan cingur sapi, sayur, dan buah dalam bumbu petis, kacang, dan cabai khas Surabaya.', 'Olahan daging', 'https://images.unsplash.com/photo-1565958011703-44f9829ba187?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-02 09:36:40'),
(21, NULL, 'Soto Lamongan', 'Jawa Timur', 'Soto ayam berkuah kuning bening dengan taburan koya yang gurih dan sambal segar.', 'Hidangan berkuah', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-02 09:36:40'),
(22, NULL, 'Sate Madura', 'Jawa Timur', 'Sate ayam berbumbu kacang atau kecap dengan daging kecil-kecil, dibakar di atas arang.', 'Olahan daging', 'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-02 09:36:40'),
(23, NULL, 'Bakpia Pathok', 'DI Yogyakarta', 'Kue kecil berisi kacang hijau manis dengan kulit lembut, oleh-oleh andalan dari kampung Pathuk.', 'Jajanan tradisional', 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-02 09:36:40'),
(24, NULL, 'Sate Klathak', 'DI Yogyakarta', 'Sate kambing bertusuk jeruji besi yang hanya dibumbui garam, dibakar hingga harum.', 'Olahan daging', 'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-02 09:36:40'),
(25, NULL, 'Mie Aceh', 'Aceh', 'Mi kuning tebal berbumbu kari yang pekat, dimasak bersama daging, kambing, atau seafood.', 'Berempah', 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?auto=format&fit=crop&w=900&q=85', 1, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-02 09:36:40'),
(26, NULL, 'Ayam Tangkap', 'Aceh', 'Ayam goreng garing yang disajikan dengan daun pandan, kari, dan cabai hijau yang harum.', 'Berempah', 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-02 09:36:40'),
(27, NULL, 'Bika Ambon', 'Sumatera Utara', 'Kue berongga seperti sarang lebah dengan aroma santan dan pandan, kebanggaan Medan.', 'Jajanan tradisional', 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-02 09:36:40'),
(28, NULL, 'Soto Medan', 'Sumatera Utara', 'Soto berkuah santan beraroma rempah dengan potongan ayam atau daging dan perkedel.', 'Hidangan berkuah', 'https://images.unsplash.com/photo-1512058564366-18510be2db19?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-02 09:36:40'),
(29, NULL, 'Arsik Ikan Mas', 'Sumatera Utara', 'Ikan mas berbumbu andaliman dan asam cikala, hidangan adat Batak yang segar dan berani.', 'Olahan ikan', 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-02 09:36:40'),
(30, NULL, 'Nasi Kapau', 'Sumatera Barat', 'Nasi dengan lauk gulai nangka, tunjang, dan dendeng yang disajikan bertingkat ala Kapau.', 'Berempah', 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-02 09:36:40'),
(31, NULL, 'Sate Padang', 'Sumatera Barat', 'Sate daging sapi dengan kuah kental dari tepung beras, kunyit, dan rempah yang pedas gurih.', 'Olahan daging', 'https://images.unsplash.com/photo-1498837167922-ddd27525d352?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-02 09:36:40'),
(32, NULL, 'Tekwan', 'Sumatera Selatan', 'Bakso ikan mungil dalam kuah udang yang segar, bersama jamur, bengkoang, dan soun.', 'Hidangan berkuah', 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-02 09:36:40'),
(33, NULL, 'Pindang Patin', 'Sumatera Selatan', 'Ikan patin dalam kuah asam pedas segar dengan nanas dan tomat khas Palembang.', 'Olahan ikan', 'https://images.unsplash.com/photo-1574484284002-952d92456975?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-02 09:36:40'),
(34, NULL, 'Lawar', 'Bali', 'Campuran sayur, kelapa parut, dan daging cincang dengan bumbu genep, sajian upacara dan harian.', 'Olahan sayur', 'https://images.unsplash.com/photo-1476224203421-9ac39bcb3327?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-02 09:36:40'),
(35, NULL, 'Sate Lilit', 'Bali', 'Daging ikan atau ayam cincang berbumbu kelapa, dililitkan pada batang serai lalu dibakar.', 'Olahan ikan', 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-02 09:36:40'),
(36, NULL, 'Ayam Taliwang', 'Nusa Tenggara Barat', 'Ayam bakar dengan sambal cabai rawit yang pedas menyengat, hidangan kebanggaan Lombok.', 'Pedas', 'https://images.unsplash.com/photo-1565958011703-44f9829ba187?auto=format&fit=crop&w=900&q=85', 1, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-02 09:36:40'),
(37, NULL, 'Plecing Kangkung', 'Nusa Tenggara Barat', 'Kangkung rebus dengan sambal tomat terasi yang segar dan pedas, taburan kacang kedelai goreng.', 'Olahan sayur', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-02 09:36:40'),
(38, NULL, 'Konro Bakar', 'Sulawesi Selatan', 'Iga sapi bakar dengan bumbu kluwek dan rempah khas Makassar, disajikan dengan kuah konro.', 'Olahan daging', 'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=900&q=85', 1, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-02 09:36:40'),
(39, NULL, 'Pallubasa', 'Sulawesi Selatan', 'Sup daging dan jeroan berkuah kelapa sangrai, disantap dengan telur mentah dan nasi.', 'Hidangan berkuah', 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-02 09:36:40'),
(40, NULL, 'Es Pisang Ijo', 'Sulawesi Selatan', 'Pisang berbalut adonan hijau pandan disiram sirup, bubur sumsum, dan es serut.', 'Pencuci mulut', 'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-02 09:36:40'),
(41, NULL, 'Tinutuan', 'Sulawesi Utara', 'Bubur beras dengan labu, jagung, dan aneka sayur yang dinikmati bersama ikan asin dan sambal roa.', 'Olahan sayur', 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-02 09:36:40'),
(42, NULL, 'Cakalang Fufu', 'Sulawesi Utara', 'Ikan cakalang yang diasap hingga harum, dimasak dengan bumbu rica-rica atau dibakar.', 'Olahan ikan', 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-02 09:36:40'),
(43, NULL, 'Ketupat Kandangan', 'Kalimantan Selatan', 'Ketupat dengan kuah santan kuning dan ikan haruan bakar, sarapan khas Kandangan.', 'Olahan ikan', 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-02 09:36:40'),
(44, NULL, 'Amplang', 'Kalimantan Timur', 'Kerupuk ikan renyah yang gurih, camilan oleh-oleh dari Samarinda dan sekitarnya.', 'Olahan ikan', 'https://images.unsplash.com/photo-1512058564366-18510be2db19?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-02 09:36:40'),
(45, NULL, 'Sagu Lempeng', 'Maluku & Papua', 'Lempengan sagu panggang yang renyah, biasa dicelup teh atau kuah ikan di meja pagi hari.', 'Berbahan sagu', 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-02 09:36:40'),
(46, NULL, 'Ikan Bakar Colo-Colo', 'Maluku & Papua', 'Ikan bakar dengan sambal colo-colo dari cabai, bawang, tomat, dan jeruk nipis yang segar.', 'Olahan ikan', 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-02 09:36:40'),
(47, NULL, 'Jagung Bose', 'Nusa Tenggara Timur', 'Bubur jagung pulut dan kacang tanah bersantan, hidangan harian masyarakat Timor.', 'Olahan jagung', 'https://images.unsplash.com/photo-1498837167922-ddd27525d352?auto=format&fit=crop&w=900&q=85', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-02 09:36:40');

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
-- Table structure for table `seller_profiles`
--

CREATE TABLE `seller_profiles` (
  `user_id` int(10) UNSIGNED NOT NULL,
  `nama_usaha` varchar(160) COLLATE utf8mb4_unicode_ci NOT NULL,
  `jenis_usaha` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nomor_telepon` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `alamat` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `verification_status` enum('pending','verified','rejected') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `verified_by` int(10) UNSIGNED DEFAULT NULL,
  `verified_at` datetime DEFAULT NULL,
  `rejection_reason` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

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
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

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
-- Constraints for table `lokasi_kuliner`
--
ALTER TABLE `lokasi_kuliner`
  ADD CONSTRAINT `fk_lokasi_kuliner` FOREIGN KEY (`kuliner_id`) REFERENCES `kuliner` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD CONSTRAINT `fk_role_permissions_permission` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_role_permissions_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

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
