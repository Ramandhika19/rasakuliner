-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 11, 2026 at 05:03 AM
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
  `slug` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `judul` varchar(180) COLLATE utf8mb4_unicode_ci NOT NULL,
  `kategori` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `daerah` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Nusantara',
  `ringkasan` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `isi` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('draft','published') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'published',
  `unggulan` tinyint(1) NOT NULL DEFAULT 0,
  `views` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `published_at` datetime NOT NULL DEFAULT current_timestamp(),
  `gambar` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `penulis` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Redaksi RasaKuliner',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cerita`
--

INSERT INTO `cerita` (`id`, `slug`, `judul`, `kategori`, `daerah`, `ringkasan`, `isi`, `status`, `unggulan`, `views`, `published_at`, `gambar`, `penulis`, `created_at`, `updated_at`) VALUES
(1, 'rempah-yang-menyatukan-meja-nusantara', 'Rempah yang menyatukan meja Nusantara', 'Bahan & tradisi', 'Nusantara', 'Dari kunyit hingga lengkuas, rempah bukan hanya pemberi aroma. Ia menyimpan jejak perdagangan, kebiasaan, dan identitas dapur keluarga Indonesia.', 'Di banyak dapur Indonesia, aroma bawang, kunyit, jahe, serai, dan lengkuas menjadi tanda bahwa sebuah masakan sedang dimulai. Setiap daerah memiliki racikan sendiri. Ada bumbu yang ditumbuk halus, diiris, dibakar, atau dimasukkan utuh agar aromanya keluar perlahan. Perbedaan cara mengolah inilah yang membuat satu bahan dapat menghadirkan rasa yang begitu beragam.\r\n\r\nRempah juga membawa cerita perjalanan antarpulau dan antargenerasi. Pengetahuan memilih bahan, menyangrai kemiri, atau menentukan kapan santan dimasukkan sering diwariskan melalui praktik sehari-hari, bukan hanya melalui catatan resep. Di rumah, ukuran bumbu kadang cukup disebut \'secukupnya\' karena tangan dan ingatan menjadi alat ukur.\r\n\r\nSaat menikmati masakan berbumbu, kita sebenarnya sedang mengenal kekayaan alam dan kebiasaan masyarakat yang membentuknya. Menjaga resep keluarga berarti ikut merawat pengetahuan tentang bahan lokal, musim, dan cara memasak yang telah tumbuh lama.', 'published', 1, 0, '2026-11-10 17:33:32', 'img/kuliner/rendang.jpg', 'Redaksi RasaKuliner', '2026-11-10 09:33:32', '2026-11-10 09:33:33'),
(2, 'tumpeng-doa-yang-disajikan-bersama', 'Tumpeng: doa yang disajikan bersama', 'Cerita di balik rasa', 'Jawa', 'Bentuk kerucut dan lauk yang mengelilinginya menjadikan tumpeng lebih dari sajian perayaan: ia adalah simbol syukur dan kebersamaan.', 'Tumpeng mudah dikenali dari nasi berbentuk kerucut yang berdiri di tengah aneka lauk. Dalam banyak tradisi masyarakat Jawa, tumpeng hadir pada acara syukuran, kelahiran, peringatan, hingga pertemuan keluarga. Bentuknya yang menjulang sering dimaknai sebagai pengingat untuk bersyukur dan mengarahkan harapan kepada Yang Maha Kuasa.\r\n\r\nLauk pendampingnya dapat berbeda menurut daerah dan kemampuan keluarga. Ayam, telur, urap, tempe, tahu, sambal, dan ikan memiliki rasa serta makna masing-masing. Penataan lauk mengundang orang untuk berkumpul mengitari satu hidangan, lalu membaginya bersama-sama.\r\n\r\nTradisi tumpeng terus berkembang. Kini tumpeng hadir dalam berbagai ukuran dan bentuk, tetapi semangat utamanya tetap sama: merayakan momen penting dengan rasa syukur, doa, dan kebersamaan.', 'published', 1, 0, '2026-11-10 17:33:32', 'img/kuliner/nasi-liwet.jpg', 'Redaksi RasaKuliner', '2026-11-10 09:33:32', '2026-11-10 09:33:33'),
(3, 'sagu-kehidupan-dari-timur-indonesia', 'Sagu, kehidupan dari timur Indonesia', 'Catatan pangan', 'Maluku & Papua', 'Sagu menjadi sumber pangan penting di Maluku dan Papua, diolah menjadi papeda, sagu lempeng, hingga aneka kudapan.', 'Di sejumlah wilayah Maluku dan Papua, sagu tumbuh dekat dengan kehidupan masyarakat. Batang pohon sagu menyimpan pati yang diolah menjadi bahan pangan. Proses pengolahannya membutuhkan pengetahuan tentang alam, waktu, dan kerja bersama, sehingga sagu bukan sekadar bahan makanan, melainkan bagian dari hubungan masyarakat dengan lingkungannya.\r\n\r\nSalah satu hidangan yang dikenal luas adalah papeda. Teksturnya bening dan lengket, dengan rasa yang cenderung netral. Papeda biasanya disantap bersama ikan kuah kuning berbumbu kunyit, jeruk, dan rempah. Perpaduan tekstur sagu dengan kuah ikan yang segar menciptakan pengalaman makan yang khas.\r\n\r\nSelain papeda, sagu diolah menjadi sagu lempeng dan berbagai kudapan. Mengenal olahan sagu membantu kita memahami keragaman sumber karbohidrat Nusantara serta pentingnya menjaga pangan lokal.', 'published', 1, 1, '2026-11-10 17:33:32', 'img/kuliner/papeda.jpg', 'Redaksi RasaKuliner', '2026-11-10 09:33:32', '2026-11-11 01:57:59'),
(4, 'rendang-sabar-dalam-api-kecil', 'Rendang: kesabaran dalam api kecil', 'Kuliner daerah', 'Sumatera Barat', 'Rahasia rendang bukan hanya bumbu yang kaya, tetapi juga proses memasak perlahan hingga santan dan rempah menyatu.', 'Rendang berasal dari tradisi kuliner Minangkabau dan dikenal karena proses memasaknya yang panjang. Potongan daging dimasak bersama santan serta bumbu seperti cabai, bawang, jahe, lengkuas, serai, dan aneka rempah. Selama dimasak, cairan santan berangsur menyusut dan bumbu meresap ke dalam daging.\r\n\r\nMemasak rendang membutuhkan perhatian. Api dijaga agar tidak terlalu besar, sementara masakan diaduk berkala supaya tidak mudah gosong. Pada tahap awal, hidangan masih berkuah; semakin lama dimasak, warnanya menjadi lebih gelap dan teksturnya lebih kering. Tiap keluarga dapat memiliki komposisi bumbu dan tingkat kekeringan yang berbeda.\r\n\r\nRendang juga lekat dengan acara adat dan pertemuan keluarga. Ketahanannya ketika dimasak hingga kering membuatnya cocok dibawa dalam perjalanan. Di balik rasanya yang kuat, rendang mengajarkan ketekunan dan kebersamaan dalam menyiapkan hidangan.', 'published', 1, 0, '2026-10-31 17:33:33', 'img/kuliner/rendang.jpg', 'Dapur Minang', '2026-11-10 09:33:33', '2026-11-10 09:33:33'),
(5, 'gudeg-manis-yang-mewakili-yogyakarta', 'Gudeg, manis yang mewakili Yogyakarta', 'Kuliner daerah', 'DI Yogyakarta', 'Nangka muda, santan, dan daun jati menghasilkan gudeg dengan warna serta rasa manis yang akrab dari dapur Yogyakarta.', 'Gudeg dibuat dari nangka muda yang dimasak lama bersama santan dan bumbu. Daun jati kerap digunakan untuk membantu memberi warna cokelat kemerahan yang khas. Proses memasak perlahan membuat nangka menjadi empuk dan bumbunya meresap.\r\n\r\nDi meja makan, gudeg sering disajikan bersama nasi, ayam, telur, tahu atau tempe, serta sambal krecek. Perpaduan rasa manis gudeg dan pedas gurih krecek membuat satu piring terasa seimbang. Ada pula variasi gudeg basah dan gudeg kering yang berbeda dari sisi kuah dan daya simpannya.\r\n\r\nGudeg berkembang bersama kehidupan kota Yogyakarta. Dari hidangan rumahan hingga sajian warung dan oleh-oleh, makanan ini menjadi salah satu cara mengenali karakter kuliner daerah yang akrab dan bersahaja.', 'published', 0, 0, '2026-11-01 17:33:33', 'img/kuliner/gudeg.jpg', 'Redaksi RasaKuliner', '2026-11-10 09:33:33', '2026-11-10 09:33:33'),
(6, 'ayam-betutu-bumbu-genep-bali', 'Ayam Betutu dan kekayaan bumbu genep Bali', 'Kuliner daerah', 'Bali', 'Bumbu genep menghadirkan lapisan aroma rempah pada ayam betutu, hidangan Bali yang erat dengan tradisi dan perayaan.', 'Ayam betutu dikenal dengan bumbu Bali yang kaya, sering disebut bumbu genep. Racikannya memadukan bawang, cabai, kunyit, jahe, kencur, lengkuas, serai, kemiri, dan rempah lain. Bumbu dihaluskan lalu dilumurkan ke ayam hingga masuk ke bagian dalam.\r\n\r\nSecara tradisional, betutu dimasak perlahan agar daging menjadi empuk dan bumbu meresap. Cara memasak dan tingkat kepedasannya dapat berbeda antarwilayah maupun keluarga. Hidangan ini kerap hadir dalam acara adat, pertemuan keluarga, dan perayaan.\r\n\r\nMenikmati ayam betutu bukan hanya soal rasa pedas dan aromanya. Hidangan ini memperlihatkan bagaimana satu racikan bumbu dapat menjadi penanda identitas dapur Bali dan diwariskan dari satu generasi ke generasi berikutnya.', 'published', 1, 0, '2026-11-02 17:33:33', 'img/kuliner/ayam-betutu.jpg', 'Redaksi RasaKuliner', '2026-11-10 09:33:33', '2026-11-10 09:33:33'),
(7, 'pempek-palembang-ikan-dan-cuko', 'Pempek Palembang: ikan, sagu, dan kuah cuko', 'Kuliner daerah', 'Sumatera Selatan', 'Tekstur kenyal pempek berpadu dengan cuko bercita rasa asam, manis, dan pedas yang menjadi ciri khas Palembang.', 'Pempek merupakan olahan ikan dan tepung sagu yang sangat lekat dengan Palembang. Adonan ikan dibuat dengan takaran yang menjaga rasa ikan tetap terasa, lalu dibentuk menjadi berbagai jenis. Ada pempek kapal selam berisi telur, lenjer berbentuk panjang, adaan yang bulat, dan kulit yang memanfaatkan kulit ikan.\r\n\r\nPempek biasanya direbus terlebih dahulu. Sebelum disajikan, pempek dapat digoreng hingga bagian luarnya sedikit renyah. Pendamping utamanya adalah cuko, kuah gelap dari gula merah, asam, bawang putih, dan cabai. Rasa cuko yang kuat memberi kontras pada pempek yang gurih.\r\n\r\nKebiasaan menyantap pempek menunjukkan kekayaan hasil sungai dan keterampilan mengolah ikan. Setiap penjual dapat memiliki racikan cuko sendiri, sehingga pengalaman mencicipi pempek selalu punya ciri tersendiri.', 'published', 0, 1, '2026-11-03 17:33:33', 'img/kuliner/pempek.jpg', 'Redaksi RasaKuliner', '2026-11-10 09:33:33', '2026-11-10 09:33:50'),
(8, 'rawon-kuah-hitam-khas-jawa-timur', 'Rawon: cerita di balik kuah hitam Jawa Timur', 'Kuliner daerah', 'Jawa Timur', 'Kluwek memberi warna gelap dan rasa khas pada rawon, sup daging yang akrab disajikan dengan tauge pendek dan sambal.', 'Rawon memiliki ciri yang langsung terlihat: kuah berwarna hitam pekat. Warna dan karakter rasanya berasal dari kluwek, biji tanaman yang diolah dengan benar sebelum digunakan sebagai bumbu. Kluwek berpadu dengan bawang, ketumbar, serai, lengkuas, dan rempah lain untuk membentuk kuah yang gurih.\r\n\r\nDaging sapi dimasak hingga empuk di dalam kuah berbumbu. Rawon sering disajikan dengan nasi, tauge pendek, telur asin, sambal, dan kerupuk. Tambahan sederhana itu memberi tekstur segar dan rasa asin-pedas yang melengkapi kuah.\r\n\r\nRawon dikenal luas di Jawa Timur, terutama dalam tradisi makan di rumah maupun warung. Setiap tempat punya racikan yang sedikit berbeda, tetapi kluwek tetap menjadi unsur penting yang membuat rawon mudah dikenali.', 'published', 0, 0, '2026-11-04 17:33:33', 'img/kuliner/rawon.jpg', 'Redaksi RasaKuliner', '2026-11-10 09:33:33', '2026-11-10 09:33:33'),
(9, 'sate-lilit-aroma-serai-dari-bali', 'Sate lilit: aroma serai dari dapur Bali', 'Kuliner daerah', 'Bali', 'Daging ikan atau ayam berbumbu dililitkan pada batang serai, lalu dibakar hingga harum dan matang.', 'Berbeda dari sate yang berupa potongan daging pada tusuk, sate lilit dibuat dari daging cincang atau ikan yang dicampur kelapa parut dan bumbu. Adonan kemudian dililitkan pada batang serai atau tusuk pipih sebelum dibakar.\r\n\r\nBumbu Bali memberi rasa gurih dan aroma rempah. Ketika terkena panas bara, serai ikut mengeluarkan wangi yang menyatu dengan adonan. Sate lilit dapat dibuat dari ikan, ayam, atau bahan lain sesuai kebiasaan keluarga dan daerah.\r\n\r\nHidangan ini sering menjadi bagian dari sajian Bali bersama lawar, nasi, dan sambal. Teknik melilit adonan memperlihatkan kreativitas mengolah bahan sederhana menjadi makanan dengan karakter kuat.', 'published', 0, 0, '2026-11-05 17:33:33', 'img/kuliner/sate-lilit.jpg', 'Redaksi RasaKuliner', '2026-11-10 09:33:33', '2026-11-10 09:33:33'),
(10, 'coto-makassar-kuah-rempah-dan-kacang', 'Coto Makassar: hangatnya kuah rempah dan kacang', 'Kuliner daerah', 'Sulawesi Selatan', 'Daging dan jeroan dimasak dalam kuah kaya rempah serta kacang, lalu disantap bersama ketupat atau buras.', 'Coto Makassar adalah hidangan berkuah yang dikenal dengan rasa gurih dan aroma rempah. Daging sapi dan bagian jeroan direbus hingga empuk, sementara kuahnya diracik dari bumbu yang ditumis dan campuran kacang tanah yang dihaluskan. Hasilnya adalah kuah dengan tekstur lebih pekat dan rasa yang berlapis.\r\n\r\nCoto biasanya disajikan panas bersama ketupat atau buras. Taburan daun bawang, bawang goreng, jeruk nipis, dan sambal dapat ditambahkan sesuai selera. Perasan jeruk membantu memberi kesegaran pada kuah yang kaya rasa.\r\n\r\nDi Makassar, coto menjadi pilihan sarapan maupun santapan pada waktu lain. Hidangan ini memperlihatkan kuatnya tradisi makan bersama dan kecintaan pada olahan daging berbumbu.', 'published', 0, 0, '2026-11-06 17:33:33', 'img/kuliner/coto-makassar.jpg', 'Redaksi RasaKuliner', '2026-11-10 09:33:33', '2026-11-10 09:33:33'),
(11, 'bika-ambon-berongga-dari-medan', 'Bika Ambon: tekstur berongga yang terkenal dari Medan', 'Jajanan tradisional', 'Sumatera Utara', 'Kue berongga dengan aroma pandan dan serai ini menjadi salah satu buah tangan yang lekat dengan Medan.', 'Bika Ambon dikenal dari teksturnya yang berongga seperti sarang dan terasa kenyal ketika digigit. Adonannya menggunakan bahan seperti tepung tapioka, telur, gula, santan, serta ragi atau bahan pengembang. Aroma pandan dan serai sering digunakan untuk memberi wangi yang khas.\r\n\r\nProses fermentasi dan pemanggangan berpengaruh pada terbentuknya rongga-rongga di dalam kue. Karena itu, waktu istirahat adonan dan pengaturan panas perlu diperhatikan. Hasil yang baik memiliki permukaan kecokelatan, bagian dalam lembut, dan aroma yang harum.\r\n\r\nMeski namanya memuat kata Ambon, kue ini justru sangat dikenal sebagai oleh-oleh dari Medan. Perjalanan nama dan popularitasnya menjadi contoh menarik bagaimana makanan dapat membangun identitas sebuah kota.', 'published', 0, 0, '2026-11-07 17:33:33', 'img/kuliner/bika-ambon.jpg', 'Redaksi RasaKuliner', '2026-11-10 09:33:33', '2026-11-10 09:33:33'),
(12, 'arsik-ikan-mas-rasa-andaliman-batak', 'Arsik ikan mas: rasa andaliman dari dapur Batak', 'Kuliner daerah', 'Sumatera Utara', 'Ikan mas dimasak dengan andaliman, asam cikala, dan bumbu khas Batak yang menghadirkan rasa segar sekaligus hangat.', 'Arsik merupakan hidangan ikan mas yang lekat dengan tradisi masyarakat Batak di Sumatera Utara. Ikan dimasak bersama bumbu kuning, bawang, cabai, jahe, kunyit, serai, serta bahan khas seperti andaliman dan asam cikala. Bumbu tersebut menghasilkan rasa yang segar, aromatik, dan sedikit getir hangat.\r\n\r\nDalam beberapa cara memasak, ikan disusun bersama bumbu dan rempah utuh lalu dimasak perlahan dengan sedikit air hingga bumbu meresap. Keutuhan bentuk ikan sering dijaga karena hidangan ini juga memiliki tempat dalam acara adat dan pertemuan keluarga.\r\n\r\nAndaliman menjadi salah satu penanda rasa yang membuat arsik berbeda dari olahan ikan berbumbu kuning lainnya. Mengenal arsik berarti mengenal bahan lokal dan tradisi yang hidup di sekitar Danau Toba.', 'published', 0, 0, '2026-11-08 17:33:33', 'img/kuliner/arsik-ikan-mas.jpg', 'Redaksi RasaKuliner', '2026-11-10 09:33:33', '2026-11-10 09:33:33'),
(13, 'ayam-taliwang-pedas-dari-lombok', 'Ayam Taliwang: pedas berani dari Lombok', 'Kuliner daerah', 'Nusa Tenggara Barat', 'Ayam bakar berbumbu cabai dan terasi ini dikenal dengan rasa pedas yang kuat serta aroma bakaran yang menggoda.', 'Ayam Taliwang berasal dari Lombok, Nusa Tenggara Barat. Ayam berukuran relatif kecil biasanya dibumbui dengan cabai, bawang, terasi, tomat, dan rempah lain. Setelah bumbu meresap, ayam dibakar hingga permukaannya matang dan aromanya keluar.\r\n\r\nRasa pedas menjadi salah satu ciri yang paling mudah diingat. Namun, tiap rumah makan dapat menyajikan tingkat pedas, tekstur, dan cara pembakaran yang berbeda. Ayam Taliwang sering dinikmati bersama plecing kangkung, nasi hangat, dan sambal.\r\n\r\nHidangan ini memperlihatkan karakter kuliner Lombok yang berani menggunakan cabai dan memadukan rasa bakar dengan sambal segar. Kombinasi tersebut menjadikannya salah satu sajian yang dicari ketika berkunjung ke Lombok.', 'published', 0, 0, '2026-11-09 17:33:33', 'img/kuliner/ayam-taliwang.jpg', 'Redaksi RasaKuliner', '2026-11-10 09:33:33', '2026-11-10 09:33:33'),
(14, 'tinutuan-bubur-manado-penuh-sayuran', 'Tinutuan: bubur Manado yang penuh warna', 'Kuliner daerah', 'Sulawesi Utara', 'Labu, jagung, dan sayuran menyatu dalam bubur hangat yang biasa disantap dengan sambal roa dan ikan asin.', 'Tinutuan atau bubur Manado merupakan hidangan berbahan beras yang dimasak bersama aneka sayuran. Labu kuning, jagung, bayam, kangkung, dan daun kemangi dapat digunakan sesuai musim dan kebiasaan rumah. Sayuran membuat warna bubur cerah dan teksturnya beragam.\r\n\r\nTinutuan umumnya disajikan hangat dengan sambal roa, ikan asin, atau lauk pendamping lain. Rasa buburnya cenderung ringan sehingga sambal dan lauk memberi kontras gurih serta pedas. Hidangan ini kerap dinikmati sebagai menu sarapan.\r\n\r\nBahan yang sederhana dan mudah ditemukan menjadikan tinutuan dekat dengan keseharian masyarakat. Ia juga mengingatkan bahwa makanan tradisional tidak selalu harus rumit untuk terasa kaya dan memuaskan.', 'published', 0, 0, '2026-11-10 17:33:33', 'img/kuliner/tinutuan.jpg', 'Redaksi RasaKuliner', '2026-11-10 09:33:33', '2026-11-10 09:33:33'),
(15, 'klepon-manis-gula-merah-dalam-gigitan', 'Klepon: manis gula merah dalam satu gigitan', 'Jajanan tradisional', 'Jawa', 'Bola ketan hijau berisi gula merah cair dan dibalut kelapa parut ini menyimpan kejutan manis di setiap gigitan.', 'Klepon dibuat dari tepung ketan yang diberi warna hijau, sering menggunakan pandan atau suji. Adonan dibentuk menjadi bola kecil dan diisi gula merah. Setelah direbus hingga mengapung, klepon digulingkan pada kelapa parut agar permukaannya terasa gurih.\r\n\r\nCiri khas klepon adalah gula merah di bagian dalam yang meleleh ketika digigit. Karena itu, klepon sering dimakan dalam satu atau dua gigitan dengan hati-hati. Perpaduan rasa manis, aroma pandan, dan kelapa menjadikannya jajanan pasar yang mudah dikenali.\r\n\r\nKlepon hadir di banyak pasar tradisional dan acara keluarga. Meski bahan serta bentuknya sederhana, proses membuatnya membutuhkan ketelitian agar isian tidak bocor dan kelapa tetap segar.', 'published', 0, 0, '2026-11-10 17:33:33', 'img/kuliner/klepon.jpg', 'Redaksi RasaKuliner', '2026-11-10 09:33:33', '2026-11-10 09:33:33');

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
(47, NULL, 'Jagung Bose', 'Nusa Tenggara Timur', 'Bubur jagung pulut dan kacang tanah bersantan, hidangan harian masyarakat Timor.', 'Olahan jagung', 'img/kuliner/jagung-bose.jpg', 0, 'approved', NULL, NULL, NULL, NULL, '2026-11-02 09:36:40', '2026-11-06 03:07:14', NULL, NULL, NULL);

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
(47, 47, 'img/kuliner/jagung-bose.jpg', 1, '2026-11-06 03:42:35');

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
  `latitude` decimal(10,7) DEFAULT NULL,
  `longitude` decimal(10,7) DEFAULT NULL,
  `jam_buka` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `kisaran_harga` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rating` decimal(2,1) DEFAULT NULL,
  `telepon` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `google_place_id` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `lokasi_kuliner`
--

INSERT INTO `lokasi_kuliner` (`id`, `kuliner_id`, `nama_tempat`, `alamat`, `kota`, `latitude`, `longitude`, `jam_buka`, `kisaran_harga`, `rating`, `telepon`, `created_at`, `updated_at`) VALUES
(69, 3, 'Ayam Betutu Ibu Nia - Renon', 'Jl. Merdeka No. 1, Renon, Denpasar', 'Denpasar', NULL, NULL, NULL, NULL, NULL, '0823-3913-4073', '2026-11-11 00:00:00', '2026-11-11 03:58:18'),
(70, 3, 'Ayam Betutu Khas Gilimanuk - Merdeka', 'Jl. Merdeka No. 88 No. 5, Sumerta Kelod, Denpasar Timur', 'Denpasar', NULL, NULL, NULL, NULL, NULL, '0811-3993-387', '2026-11-11 00:00:00', '2026-11-11 03:58:18'),
(71, 3, 'Betutu Panggang Biang Koripan 7 Waturenggong', 'Jl. Waturenggong No. 145, Panjer, Denpasar Selatan', 'Denpasar', NULL, NULL, NULL, NULL, NULL, '0878-6971-2949', '2026-11-11 00:00:00', '2026-11-11 03:58:18'),
(72, 3, 'Ayam Betutu Bu Ferdi', 'Jl. Buana Kubu, Tegal Harum, Denpasar Barat', 'Denpasar', NULL, NULL, NULL, NULL, NULL, '0813-3807-0288', '2026-11-11 00:00:00', '2026-11-11 03:58:18'),
(73, 3, 'Warung Makan Ayam Betutu Bu Kadek Wati', 'Jl. Gatot Subroto Barat, Denpasar Utara', 'Denpasar', NULL, NULL, NULL, NULL, NULL, '0822-3776-7772', '2026-11-11 00:00:00', '2026-11-11 03:58:18'),
(74, 3, 'Ayam Betutu Pak Man Kuta', 'Jl. Pudak Sari No. 72, Kuta, Badung', 'Badung', NULL, NULL, NULL, NULL, NULL, NULL, '2026-11-11 00:00:00', '2026-11-11 03:58:18'),
(75, 3, 'Ayam Betutu Khas Gilimanuk - Central Park Kuta', 'Jl. Patih Jelantik, Komp. Istana Kuta Galeria, Kuta, Badung', 'Badung', NULL, NULL, NULL, NULL, NULL, '0812-3903-3922', '2026-11-11 00:00:00', '2026-11-11 03:58:18'),
(76, 3, 'Ayam Betutu Khas Gilimanuk - Tuban', 'Jl. Raya Tuban No. 2X, Tuban, Kuta, Badung', 'Badung', NULL, NULL, NULL, NULL, NULL, '0361-757535', '2026-11-11 00:00:00', '2026-11-11 03:58:18'),
(77, 35, 'Warung Wardani - Yudistira', 'Jl. Yudistira No. 2, Dangin Puri Kauh, Denpasar Utara', 'Denpasar', NULL, NULL, '08.00 – 16.00', 'Rp30.000 – 45.000', NULL, '0361-224398', '2026-11-11 00:00:00', '2026-11-11 03:58:18'),
(78, 35, 'Warung Tresni', 'Jl. Drupadi II No. 54, Renon, Denpasar Selatan', 'Denpasar', NULL, NULL, NULL, NULL, NULL, NULL, '2026-11-11 00:00:00', '2026-11-11 03:58:18'),
(79, 12, 'Bendega Renon', 'Jl. Cok Agung Tresna No. 37, Dangin Puri Klod, Denpasar Timur', 'Denpasar', NULL, NULL, NULL, NULL, NULL, '0877-6407-8434', '2026-11-11 00:00:00', '2026-11-11 03:58:18');

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
  `lokasi_id` int(10) UNSIGNED DEFAULT NULL,
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

--
-- Dumping data for table `seller_email_actions`
--

INSERT INTO `seller_email_actions` (`id`, `user_id`, `token_hash`, `expires_at`, `used_at`, `created_at`) VALUES
(5, 11, '16505548f5dc8d914f3959e6b7fbaa2aea0e272a0cc65bd75648352c00676ea6', '2026-11-10 16:13:59', '2026-11-08 16:14:54', '2026-11-08 08:13:59'),
(7, 14, 'c309908e4e30b4fabed4ff0627955e4ddc420d41b2d3ce62c85741bcc053dffe', '2026-11-11 08:21:14', '2026-11-09 08:23:02', '2026-11-09 00:21:14'),
(8, 15, '48f0376b56efdce1ad6edd04bdf4d974080eead27dcbc57c6131809856dea04c', '2026-11-11 10:58:58', '2026-11-09 10:59:33', '2026-11-09 02:58:58');

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
(11, 'Ayam Taliwang Lombok', 'Makanan berat', '085837213871', 'Nusa Dua', NULL, 'verified', 1, '2026-11-08 16:14:54', NULL, '2026-11-08 08:13:55', '2026-11-08 08:14:54'),
(14, 'Rendang Gacor', 'Makanan berat', '085837213871', 'Jimbaran', 'img/profil/14/profil-14-20261109012837-11f25c8d.png', 'verified', 1, '2026-11-09 08:23:02', NULL, '2026-11-09 00:21:09', '2026-11-09 00:28:37'),
(15, 'aaa', 'aaa', '234123412', 'asfdasdf', 'img/profil/15/profil-15-20261109040410-60856438.png', 'verified', 1, '2026-11-09 10:59:33', NULL, '2026-11-09 02:58:53', '2026-11-09 03:04:10');

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
(11, 'Rama', 'ramagm841@gmail.com', '$2y$10$/t28qtt8qN0vBKCR6fMT5O6/4qAP2Sm0fd7uUMETIGOFBu574bqay', 'active', NULL, '2026-11-11 10:31:22', '2026-11-08 08:13:55', '2026-11-11 02:31:22'),
(14, 'Samuel', 'ivansamuel284@gmail.com', '$2y$10$7toTH.eUqYMtlcO7Y0tXr.H.pFmj0HEt1biVd0rqHwfHYnQ4X6Oue', 'active', NULL, '2026-11-09 08:27:41', '2026-11-09 00:21:09', '2026-11-09 00:27:41'),
(15, 'anton', 'vegaaefg@gmail.com', '$2y$10$ojKyaiexCE.zB0uGoo7mF.K6bn/jQ6HUTOMty8DHor22O3wac1avq', 'active', NULL, '2026-11-09 11:00:42', '2026-11-09 02:58:53', '2026-11-09 03:00:42');

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
(1, 2, NULL, '2026-11-06 02:52:00'),
(11, 2, 1, '2026-11-08 08:14:54'),
(14, 2, 1, '2026-11-09 00:23:02'),
(15, 2, 1, '2026-11-09 02:59:33');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cerita`
--
ALTER TABLE `cerita`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cerita_slug` (`slug`),
  ADD KEY `idx_cerita_status_published` (`status`,`published_at`),
  ADD KEY `idx_cerita_category` (`kategori`);

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
  ADD KEY `idx_reviews_lokasi` (`lokasi_id`),
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
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `kuliner`
--
ALTER TABLE `kuliner`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

--
-- AUTO_INCREMENT for table `kuliner_gambar`
--
ALTER TABLE `kuliner_gambar`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;

--
-- AUTO_INCREMENT for table `lokasi_kuliner`
--
ALTER TABLE `lokasi_kuliner`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=102;

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
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

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
  ADD CONSTRAINT `fk_reviews_lokasi` FOREIGN KEY (`lokasi_id`) REFERENCES `lokasi_kuliner` (`id`) ON DELETE SET NULL,
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
