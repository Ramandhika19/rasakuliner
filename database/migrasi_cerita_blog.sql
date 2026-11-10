-- Migrasi Cerita & Blog RasaKuliner
-- Jalankan sekali melalui phpMyAdmin pada database rasakuliner.
-- Memperluas tabel cerita lama dan mengisi 15 artikel dengan foto kuliner lokal.

ALTER TABLE cerita
  ADD COLUMN slug VARCHAR(200) NOT NULL DEFAULT '' AFTER id,
  ADD COLUMN daerah VARCHAR(100) NOT NULL DEFAULT 'Nusantara' AFTER kategori,
  ADD COLUMN penulis VARCHAR(100) NOT NULL DEFAULT 'Redaksi RasaKuliner' AFTER gambar,
  ADD COLUMN isi LONGTEXT NOT NULL AFTER ringkasan,
  ADD COLUMN status ENUM('draft','published') NOT NULL DEFAULT 'published' AFTER isi,
  ADD COLUMN unggulan TINYINT(1) NOT NULL DEFAULT 0 AFTER status,
  ADD COLUMN views INT UNSIGNED NOT NULL DEFAULT 0 AFTER unggulan,
  ADD COLUMN published_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER views,
  ADD COLUMN created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  ADD UNIQUE KEY uq_cerita_slug (slug),
  ADD KEY idx_cerita_status_published (status,published_at),
  ADD KEY idx_cerita_category (kategori);

INSERT INTO cerita
(id,slug,judul,kategori,daerah,ringkasan,gambar,penulis,isi,status,unggulan,views,published_at)
VALUES
(1,'rempah-yang-menyatukan-meja-nusantara','Rempah yang menyatukan meja Nusantara','Bahan & tradisi','Nusantara','Dari kunyit hingga lengkuas, rempah bukan hanya pemberi aroma. Ia menyimpan jejak perdagangan, kebiasaan, dan identitas dapur keluarga Indonesia.','img/kuliner/rendang.jpg','Redaksi RasaKuliner','Di banyak dapur Indonesia, aroma bawang, kunyit, jahe, serai, dan lengkuas menjadi tanda bahwa sebuah masakan sedang dimulai. Setiap daerah memiliki racikan sendiri. Ada bumbu yang ditumbuk halus, diiris, dibakar, atau dimasukkan utuh agar aromanya keluar perlahan. Perbedaan cara mengolah inilah yang membuat satu bahan dapat menghadirkan rasa yang begitu beragam.

Rempah juga membawa cerita perjalanan antarpulau dan antargenerasi. Pengetahuan memilih bahan, menyangrai kemiri, atau menentukan kapan santan dimasukkan sering diwariskan melalui praktik sehari-hari, bukan hanya melalui catatan resep. Di rumah, ukuran bumbu kadang cukup disebut ''secukupnya'' karena tangan dan ingatan menjadi alat ukur.

Saat menikmati masakan berbumbu, kita sebenarnya sedang mengenal kekayaan alam dan kebiasaan masyarakat yang membentuknya. Menjaga resep keluarga berarti ikut merawat pengetahuan tentang bahan lokal, musim, dan cara memasak yang telah tumbuh lama.','published',1,0,DATE_SUB(NOW(), INTERVAL 15 DAY)),
(2,'tumpeng-doa-yang-disajikan-bersama','Tumpeng: doa yang disajikan bersama','Cerita di balik rasa','Jawa','Bentuk kerucut dan lauk yang mengelilinginya menjadikan tumpeng lebih dari sajian perayaan: ia adalah simbol syukur dan kebersamaan.','img/kuliner/nasi-liwet.jpg','Redaksi RasaKuliner','Tumpeng mudah dikenali dari nasi berbentuk kerucut yang berdiri di tengah aneka lauk. Dalam banyak tradisi masyarakat Jawa, tumpeng hadir pada acara syukuran, kelahiran, peringatan, hingga pertemuan keluarga. Bentuknya yang menjulang sering dimaknai sebagai pengingat untuk bersyukur dan mengarahkan harapan kepada Yang Maha Kuasa.

Lauk pendampingnya dapat berbeda menurut daerah dan kemampuan keluarga. Ayam, telur, urap, tempe, tahu, sambal, dan ikan memiliki rasa serta makna masing-masing. Penataan lauk mengundang orang untuk berkumpul mengitari satu hidangan, lalu membaginya bersama-sama.

Tradisi tumpeng terus berkembang. Kini tumpeng hadir dalam berbagai ukuran dan bentuk, tetapi semangat utamanya tetap sama: merayakan momen penting dengan rasa syukur, doa, dan kebersamaan.','published',1,0,DATE_SUB(NOW(), INTERVAL 13 DAY)),
(3,'sagu-kehidupan-dari-timur-indonesia','Sagu, kehidupan dari timur Indonesia','Catatan pangan','Maluku & Papua','Sagu menjadi sumber pangan penting di Maluku dan Papua, diolah menjadi papeda, sagu lempeng, hingga aneka kudapan.','img/kuliner/papeda.jpg','Redaksi RasaKuliner','Di sejumlah wilayah Maluku dan Papua, sagu tumbuh dekat dengan kehidupan masyarakat. Batang pohon sagu menyimpan pati yang diolah menjadi bahan pangan. Proses pengolahannya membutuhkan pengetahuan tentang alam, waktu, dan kerja bersama, sehingga sagu bukan sekadar bahan makanan, melainkan bagian dari hubungan masyarakat dengan lingkungannya.

Salah satu hidangan yang dikenal luas adalah papeda. Teksturnya bening dan lengket, dengan rasa yang cenderung netral. Papeda biasanya disantap bersama ikan kuah kuning berbumbu kunyit, jeruk, dan rempah. Perpaduan tekstur sagu dengan kuah ikan yang segar menciptakan pengalaman makan yang khas.

Selain papeda, sagu diolah menjadi sagu lempeng dan berbagai kudapan. Mengenal olahan sagu membantu kita memahami keragaman sumber karbohidrat Nusantara serta pentingnya menjaga pangan lokal.','published',1,0,DATE_SUB(NOW(), INTERVAL 11 DAY)),
(4,'rendang-sabar-dalam-api-kecil','Rendang: kesabaran dalam api kecil','Kuliner daerah','Sumatera Barat','Rahasia rendang bukan hanya bumbu yang kaya, tetapi juga proses memasak perlahan hingga santan dan rempah menyatu.','img/kuliner/rendang.jpg','Dapur Minang','Rendang berasal dari tradisi kuliner Minangkabau dan dikenal karena proses memasaknya yang panjang. Potongan daging dimasak bersama santan serta bumbu seperti cabai, bawang, jahe, lengkuas, serai, dan aneka rempah. Selama dimasak, cairan santan berangsur menyusut dan bumbu meresap ke dalam daging.

Memasak rendang membutuhkan perhatian. Api dijaga agar tidak terlalu besar, sementara masakan diaduk berkala supaya tidak mudah gosong. Pada tahap awal, hidangan masih berkuah; semakin lama dimasak, warnanya menjadi lebih gelap dan teksturnya lebih kering. Tiap keluarga dapat memiliki komposisi bumbu dan tingkat kekeringan yang berbeda.

Rendang juga lekat dengan acara adat dan pertemuan keluarga. Ketahanannya ketika dimasak hingga kering membuatnya cocok dibawa dalam perjalanan. Di balik rasanya yang kuat, rendang mengajarkan ketekunan dan kebersamaan dalam menyiapkan hidangan.','published',1,0,DATE_SUB(NOW(), INTERVAL 10 DAY)),
(5,'gudeg-manis-yang-mewakili-yogyakarta','Gudeg, manis yang mewakili Yogyakarta','Kuliner daerah','DI Yogyakarta','Nangka muda, santan, dan daun jati menghasilkan gudeg dengan warna serta rasa manis yang akrab dari dapur Yogyakarta.','img/kuliner/gudeg.jpg','Redaksi RasaKuliner','Gudeg dibuat dari nangka muda yang dimasak lama bersama santan dan bumbu. Daun jati kerap digunakan untuk membantu memberi warna cokelat kemerahan yang khas. Proses memasak perlahan membuat nangka menjadi empuk dan bumbunya meresap.

Di meja makan, gudeg sering disajikan bersama nasi, ayam, telur, tahu atau tempe, serta sambal krecek. Perpaduan rasa manis gudeg dan pedas gurih krecek membuat satu piring terasa seimbang. Ada pula variasi gudeg basah dan gudeg kering yang berbeda dari sisi kuah dan daya simpannya.

Gudeg berkembang bersama kehidupan kota Yogyakarta. Dari hidangan rumahan hingga sajian warung dan oleh-oleh, makanan ini menjadi salah satu cara mengenali karakter kuliner daerah yang akrab dan bersahaja.','published',0,0,DATE_SUB(NOW(), INTERVAL 9 DAY)),
(6,'ayam-betutu-bumbu-genep-bali','Ayam Betutu dan kekayaan bumbu genep Bali','Kuliner daerah','Bali','Bumbu genep menghadirkan lapisan aroma rempah pada ayam betutu, hidangan Bali yang erat dengan tradisi dan perayaan.','img/kuliner/ayam-betutu.jpg','Redaksi RasaKuliner','Ayam betutu dikenal dengan bumbu Bali yang kaya, sering disebut bumbu genep. Racikannya memadukan bawang, cabai, kunyit, jahe, kencur, lengkuas, serai, kemiri, dan rempah lain. Bumbu dihaluskan lalu dilumurkan ke ayam hingga masuk ke bagian dalam.

Secara tradisional, betutu dimasak perlahan agar daging menjadi empuk dan bumbu meresap. Cara memasak dan tingkat kepedasannya dapat berbeda antarwilayah maupun keluarga. Hidangan ini kerap hadir dalam acara adat, pertemuan keluarga, dan perayaan.

Menikmati ayam betutu bukan hanya soal rasa pedas dan aromanya. Hidangan ini memperlihatkan bagaimana satu racikan bumbu dapat menjadi penanda identitas dapur Bali dan diwariskan dari satu generasi ke generasi berikutnya.','published',1,0,DATE_SUB(NOW(), INTERVAL 8 DAY)),
(7,'pempek-palembang-ikan-dan-cuko','Pempek Palembang: ikan, sagu, dan kuah cuko','Kuliner daerah','Sumatera Selatan','Tekstur kenyal pempek berpadu dengan cuko bercita rasa asam, manis, dan pedas yang menjadi ciri khas Palembang.','img/kuliner/pempek.jpg','Redaksi RasaKuliner','Pempek merupakan olahan ikan dan tepung sagu yang sangat lekat dengan Palembang. Adonan ikan dibuat dengan takaran yang menjaga rasa ikan tetap terasa, lalu dibentuk menjadi berbagai jenis. Ada pempek kapal selam berisi telur, lenjer berbentuk panjang, adaan yang bulat, dan kulit yang memanfaatkan kulit ikan.

Pempek biasanya direbus terlebih dahulu. Sebelum disajikan, pempek dapat digoreng hingga bagian luarnya sedikit renyah. Pendamping utamanya adalah cuko, kuah gelap dari gula merah, asam, bawang putih, dan cabai. Rasa cuko yang kuat memberi kontras pada pempek yang gurih.

Kebiasaan menyantap pempek menunjukkan kekayaan hasil sungai dan keterampilan mengolah ikan. Setiap penjual dapat memiliki racikan cuko sendiri, sehingga pengalaman mencicipi pempek selalu punya ciri tersendiri.','published',0,0,DATE_SUB(NOW(), INTERVAL 7 DAY)),
(8,'rawon-kuah-hitam-khas-jawa-timur','Rawon: cerita di balik kuah hitam Jawa Timur','Kuliner daerah','Jawa Timur','Kluwek memberi warna gelap dan rasa khas pada rawon, sup daging yang akrab disajikan dengan tauge pendek dan sambal.','img/kuliner/rawon.jpg','Redaksi RasaKuliner','Rawon memiliki ciri yang langsung terlihat: kuah berwarna hitam pekat. Warna dan karakter rasanya berasal dari kluwek, biji tanaman yang diolah dengan benar sebelum digunakan sebagai bumbu. Kluwek berpadu dengan bawang, ketumbar, serai, lengkuas, dan rempah lain untuk membentuk kuah yang gurih.

Daging sapi dimasak hingga empuk di dalam kuah berbumbu. Rawon sering disajikan dengan nasi, tauge pendek, telur asin, sambal, dan kerupuk. Tambahan sederhana itu memberi tekstur segar dan rasa asin-pedas yang melengkapi kuah.

Rawon dikenal luas di Jawa Timur, terutama dalam tradisi makan di rumah maupun warung. Setiap tempat punya racikan yang sedikit berbeda, tetapi kluwek tetap menjadi unsur penting yang membuat rawon mudah dikenali.','published',0,0,DATE_SUB(NOW(), INTERVAL 6 DAY)),
(9,'sate-lilit-aroma-serai-dari-bali','Sate lilit: aroma serai dari dapur Bali','Kuliner daerah','Bali','Daging ikan atau ayam berbumbu dililitkan pada batang serai, lalu dibakar hingga harum dan matang.','img/kuliner/sate-lilit.jpg','Redaksi RasaKuliner','Berbeda dari sate yang berupa potongan daging pada tusuk, sate lilit dibuat dari daging cincang atau ikan yang dicampur kelapa parut dan bumbu. Adonan kemudian dililitkan pada batang serai atau tusuk pipih sebelum dibakar.

Bumbu Bali memberi rasa gurih dan aroma rempah. Ketika terkena panas bara, serai ikut mengeluarkan wangi yang menyatu dengan adonan. Sate lilit dapat dibuat dari ikan, ayam, atau bahan lain sesuai kebiasaan keluarga dan daerah.

Hidangan ini sering menjadi bagian dari sajian Bali bersama lawar, nasi, dan sambal. Teknik melilit adonan memperlihatkan kreativitas mengolah bahan sederhana menjadi makanan dengan karakter kuat.','published',0,0,DATE_SUB(NOW(), INTERVAL 5 DAY)),
(10,'coto-makassar-kuah-rempah-dan-kacang','Coto Makassar: hangatnya kuah rempah dan kacang','Kuliner daerah','Sulawesi Selatan','Daging dan jeroan dimasak dalam kuah kaya rempah serta kacang, lalu disantap bersama ketupat atau buras.','img/kuliner/coto-makassar.jpg','Redaksi RasaKuliner','Coto Makassar adalah hidangan berkuah yang dikenal dengan rasa gurih dan aroma rempah. Daging sapi dan bagian jeroan direbus hingga empuk, sementara kuahnya diracik dari bumbu yang ditumis dan campuran kacang tanah yang dihaluskan. Hasilnya adalah kuah dengan tekstur lebih pekat dan rasa yang berlapis.

Coto biasanya disajikan panas bersama ketupat atau buras. Taburan daun bawang, bawang goreng, jeruk nipis, dan sambal dapat ditambahkan sesuai selera. Perasan jeruk membantu memberi kesegaran pada kuah yang kaya rasa.

Di Makassar, coto menjadi pilihan sarapan maupun santapan pada waktu lain. Hidangan ini memperlihatkan kuatnya tradisi makan bersama dan kecintaan pada olahan daging berbumbu.','published',0,0,DATE_SUB(NOW(), INTERVAL 4 DAY)),
(11,'bika-ambon-berongga-dari-medan','Bika Ambon: tekstur berongga yang terkenal dari Medan','Jajanan tradisional','Sumatera Utara','Kue berongga dengan aroma pandan dan serai ini menjadi salah satu buah tangan yang lekat dengan Medan.','img/kuliner/bika-ambon.jpg','Redaksi RasaKuliner','Bika Ambon dikenal dari teksturnya yang berongga seperti sarang dan terasa kenyal ketika digigit. Adonannya menggunakan bahan seperti tepung tapioka, telur, gula, santan, serta ragi atau bahan pengembang. Aroma pandan dan serai sering digunakan untuk memberi wangi yang khas.

Proses fermentasi dan pemanggangan berpengaruh pada terbentuknya rongga-rongga di dalam kue. Karena itu, waktu istirahat adonan dan pengaturan panas perlu diperhatikan. Hasil yang baik memiliki permukaan kecokelatan, bagian dalam lembut, dan aroma yang harum.

Meski namanya memuat kata Ambon, kue ini justru sangat dikenal sebagai oleh-oleh dari Medan. Perjalanan nama dan popularitasnya menjadi contoh menarik bagaimana makanan dapat membangun identitas sebuah kota.','published',0,0,DATE_SUB(NOW(), INTERVAL 3 DAY)),
(12,'arsik-ikan-mas-rasa-andaliman-batak','Arsik ikan mas: rasa andaliman dari dapur Batak','Kuliner daerah','Sumatera Utara','Ikan mas dimasak dengan andaliman, asam cikala, dan bumbu khas Batak yang menghadirkan rasa segar sekaligus hangat.','img/kuliner/arsik-ikan-mas.jpg','Redaksi RasaKuliner','Arsik merupakan hidangan ikan mas yang lekat dengan tradisi masyarakat Batak di Sumatera Utara. Ikan dimasak bersama bumbu kuning, bawang, cabai, jahe, kunyit, serai, serta bahan khas seperti andaliman dan asam cikala. Bumbu tersebut menghasilkan rasa yang segar, aromatik, dan sedikit getir hangat.

Dalam beberapa cara memasak, ikan disusun bersama bumbu dan rempah utuh lalu dimasak perlahan dengan sedikit air hingga bumbu meresap. Keutuhan bentuk ikan sering dijaga karena hidangan ini juga memiliki tempat dalam acara adat dan pertemuan keluarga.

Andaliman menjadi salah satu penanda rasa yang membuat arsik berbeda dari olahan ikan berbumbu kuning lainnya. Mengenal arsik berarti mengenal bahan lokal dan tradisi yang hidup di sekitar Danau Toba.','published',0,0,DATE_SUB(NOW(), INTERVAL 2 DAY)),
(13,'ayam-taliwang-pedas-dari-lombok','Ayam Taliwang: pedas berani dari Lombok','Kuliner daerah','Nusa Tenggara Barat','Ayam bakar berbumbu cabai dan terasi ini dikenal dengan rasa pedas yang kuat serta aroma bakaran yang menggoda.','img/kuliner/ayam-taliwang.jpg','Redaksi RasaKuliner','Ayam Taliwang berasal dari Lombok, Nusa Tenggara Barat. Ayam berukuran relatif kecil biasanya dibumbui dengan cabai, bawang, terasi, tomat, dan rempah lain. Setelah bumbu meresap, ayam dibakar hingga permukaannya matang dan aromanya keluar.

Rasa pedas menjadi salah satu ciri yang paling mudah diingat. Namun, tiap rumah makan dapat menyajikan tingkat pedas, tekstur, dan cara pembakaran yang berbeda. Ayam Taliwang sering dinikmati bersama plecing kangkung, nasi hangat, dan sambal.

Hidangan ini memperlihatkan karakter kuliner Lombok yang berani menggunakan cabai dan memadukan rasa bakar dengan sambal segar. Kombinasi tersebut menjadikannya salah satu sajian yang dicari ketika berkunjung ke Lombok.','published',0,0,DATE_SUB(NOW(), INTERVAL 1 DAY)),
(14,'tinutuan-bubur-manado-penuh-sayuran','Tinutuan: bubur Manado yang penuh warna','Kuliner daerah','Sulawesi Utara','Labu, jagung, dan sayuran menyatu dalam bubur hangat yang biasa disantap dengan sambal roa dan ikan asin.','img/kuliner/tinutuan.jpg','Redaksi RasaKuliner','Tinutuan atau bubur Manado merupakan hidangan berbahan beras yang dimasak bersama aneka sayuran. Labu kuning, jagung, bayam, kangkung, dan daun kemangi dapat digunakan sesuai musim dan kebiasaan rumah. Sayuran membuat warna bubur cerah dan teksturnya beragam.

Tinutuan umumnya disajikan hangat dengan sambal roa, ikan asin, atau lauk pendamping lain. Rasa buburnya cenderung ringan sehingga sambal dan lauk memberi kontras gurih serta pedas. Hidangan ini kerap dinikmati sebagai menu sarapan.

Bahan yang sederhana dan mudah ditemukan menjadikan tinutuan dekat dengan keseharian masyarakat. Ia juga mengingatkan bahwa makanan tradisional tidak selalu harus rumit untuk terasa kaya dan memuaskan.','published',0,0,DATE_SUB(NOW(), INTERVAL 0 DAY)),
(15,'klepon-manis-gula-merah-dalam-gigitan','Klepon: manis gula merah dalam satu gigitan','Jajanan tradisional','Jawa','Bola ketan hijau berisi gula merah cair dan dibalut kelapa parut ini menyimpan kejutan manis di setiap gigitan.','img/kuliner/klepon.jpg','Redaksi RasaKuliner','Klepon dibuat dari tepung ketan yang diberi warna hijau, sering menggunakan pandan atau suji. Adonan dibentuk menjadi bola kecil dan diisi gula merah. Setelah direbus hingga mengapung, klepon digulingkan pada kelapa parut agar permukaannya terasa gurih.

Ciri khas klepon adalah gula merah di bagian dalam yang meleleh ketika digigit. Karena itu, klepon sering dimakan dalam satu atau dua gigitan dengan hati-hati. Perpaduan rasa manis, aroma pandan, dan kelapa menjadikannya jajanan pasar yang mudah dikenali.

Klepon hadir di banyak pasar tradisional dan acara keluarga. Meski bahan serta bentuknya sederhana, proses membuatnya membutuhkan ketelitian agar isian tidak bocor dan kelapa tetap segar.','published',0,0,DATE_SUB(NOW(), INTERVAL 0 DAY))
ON DUPLICATE KEY UPDATE
  slug=VALUES(slug),judul=VALUES(judul),kategori=VALUES(kategori),daerah=VALUES(daerah),
  ringkasan=VALUES(ringkasan),gambar=VALUES(gambar),penulis=VALUES(penulis),
  isi=VALUES(isi),status=VALUES(status),unggulan=VALUES(unggulan);

ALTER TABLE cerita AUTO_INCREMENT = 16;
