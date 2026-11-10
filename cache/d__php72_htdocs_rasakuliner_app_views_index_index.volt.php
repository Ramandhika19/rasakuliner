<!doctype html>
<html lang="id">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?= (empty($title) ? ('RasaKuliner') : ($title)) ?></title>
    <link rel="icon" type="image/svg+xml" href="<?= $this->url->get('img/rasakuliner-mark.png') ?>?v=1">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Bricolage+Grotesque:opsz,wght@12..96,600..800&family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="<?= $this->url->get('assets/css/style.css') ?>?v=<?= $assetVer ?>" rel="stylesheet">
</head>
<body>
<script>window.RASA_LOGO_URL = "<?= $this->url->get('img/rasakuliner-mark.png') ?>?v=1";</script>
<header class="site-header">
  <a class="brand" href="<?= $this->url->get('') ?>"><span class="brand-mark"><img src="<?= $this->url->get('img/rasakuliner-mark.png') ?>?v=1" alt=""></span><span>RasaKuliner</span></a>
  <nav class="main-nav">
    <a href="<?= $this->url->get('') ?>" class="<?= (isset($active) && $active == 'home' ? 'active' : '') ?>">Beranda</a>
    <a href="<?= $this->url->get('kuliner') ?>" class="<?= (isset($active) && $active == 'kuliner' ? 'active' : '') ?>">Jelajahi Kuliner</a>
    <a href="<?= $this->url->get('peta') ?>" class="<?= (isset($active) && $active == 'peta' ? 'active' : '') ?>">Peta Kuliner</a>
    <a href="<?= $this->url->get('cerita') ?>" class="<?= (isset($active) && $active == 'cerita' ? 'active' : '') ?>">Cerita & Blog</a>
    <a href="<?= $this->url->get('kuliner#kontribusi') ?>">Portal Seller</a>
  </nav>
  <?php if ($isSeller) { ?>
  <div class="seller-user-menu"><a class="seller-user-trigger" href="<?= $this->url->get('seller') ?>"><?php if ($headerSellerPhoto) { ?><span class="seller-user-avatar"><img src="<?= $this->url->get($headerSellerPhoto) ?>" alt="Foto profil"></span><?php } else { ?><span class="seller-user-avatar"><?= Phalcon\Text::upper($this->slice($headerSellerName, 0, 1)) ?></span><?php } ?><span><?= $this->escaper->escapeHtml($headerSellerName) ?></span><span>⌄</span></a><div class="seller-user-dropdown"><a href="<?= $this->url->get('seller') ?>">Dashboard Seller</a><a href="<?= $this->url->get('seller/profil') ?>">Profil Usaha</a><a href="<?= $this->url->get('seller/tambah') ?>">Tambah Kuliner</a><a href="<?= $this->url->get('logout') ?>">Keluar</a></div></div>
  <?php } elseif ($isUser) { ?>
  <div class="seller-user-menu"><a class="seller-user-trigger" href="<?= $this->url->get('') ?>"><span class="seller-user-avatar"><?= Phalcon\Text::upper($this->slice($headerUserName, 0, 1)) ?></span><span><?= $this->escaper->escapeHtml($headerUserName) ?></span><span>⌄</span></a><div class="seller-user-dropdown"><a href="<?= $this->url->get('logout') ?>">Keluar</a></div></div>
  <?php } elseif ($isAdmin) { ?>
  <a class="login-link" href="<?= $this->url->get('admin/seller') ?>">Panel Admin <span>↗</span></a>
  <a class="login-link" href="<?= $this->url->get('logout') ?>">Keluar</a>
  <?php } else { ?>
  <a class="login-link" href="<?= $this->url->get('login-user') ?>">Login User <span>↗</span></a>
  <?php } ?>
  <button class="menu-toggle" aria-label="Buka menu">☰</button>
</header>

<main>
<section class="hero">
  <div class="hero-shade"></div>
  <div class="hero-content">
    <span class="eyebrow light">Arsip rasa & cerita Indonesia</span>
    <h1>Sistem Informasi Kuliner<br>Tradisional Indonesia</h1>
    <p>Dari dapur keluarga hingga warisan lintas generasi. Temukan hidangan, kenali asal-usulnya, dan selami cerita di balik setiap rasa.</p>
    <form class="hero-search" action="<?= $this->url->get('kuliner') ?>" method="get"><span>⌕</span><input name="q" placeholder="Cari kuliner, bahan, atau daerah asal..." /><button>Cari Rasa</button></form>
    <div class="quick-tags"><span>Coba kata kunci:</span><a href="<?= $this->url->get('kuliner?q=Rendang') ?>">Rendang</a><a href="<?= $this->url->get('kuliner?q=Gudeg') ?>">Gudeg</a><a href="<?= $this->url->get('kuliner?q=Ayam') ?>">Ayam Betutu</a><a href="<?= $this->url->get('kuliner?q=Papeda') ?>">Papeda</a></div>
  </div>
</section>
<section class="section container">
  <div class="section-head"><div><span class="eyebrow">Pilihan untuk penjelajah rasa</span><h2>Kenali rasa, temukan ceritanya</h2></div><a class="text-link" href="<?= $this->url->get('kuliner') ?>">Jelajahi semua kuliner ↗</a></div>
  <div class="food-grid four">
  <?php foreach ($featured as $item) { ?>
    <a class="food-card" data-gallery="<?= $this->escaper->escapeHtml($item->gambar_gallery) ?>" href="<?= $this->url->get('kuliner/detail/' . $item->id) ?>"><div class="food-image"><img src="<?= $item->gambar_url ?>" alt="<?= $item->nama ?>"><span class="save">♧</span></div><div class="food-info"><small>⌖ <?= $item->daerah ?></small><h3><?= $item->nama ?></h3><p><?= $item->deskripsi ?></p><span class="tag"><?= $item->kategori ?></span></div></a>
  <?php } ?>
  </div>
</section>
<section class="section soft">
 <div class="container">
  <div class="section-head"><div><span class="eyebrow">Koleksi pilihan</span><h2>Ikuti rasa ingin tahu Anda</h2></div></div>
  <div class="feature-strip">
   <a href="<?= $this->url->get('kuliner') ?>"><img src="https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=500&q=85"><span><b>Hangat dalam semangkuk</b><small>Sup, soto, dan sajian kaya rempah</small><em>Lihat koleksi ↗</em></span></a>
   <a href="<?= $this->url->get('kuliner') ?>"><img src="https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=500&q=85"><span><b>Manis dari dapur tradisi</b><small>Jejak manis dari berbagai daerah</small><em>Lihat koleksi ↗</em></span></a>
   <a href="<?= $this->url->get('kuliner') ?>"><img src="https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=500&q=85"><span><b>Dibungkus daun, dirawat waktu</b><small>Aroma khas dalam setiap sajian</small><em>Lihat koleksi ↗</em></span></a>
  </div>
 </div>
</section>
<section class="section container" id="daerah">
 <div class="section-head"><div><span class="eyebrow">Dari barat hingga timur</span><h2>Setiap daerah, berbeda rasa</h2></div><a class="text-link" href="<?= $this->url->get('peta') ?>">Buka peta kuliner ↗</a></div>
 <div class="region-grid">
  <a class="region" style="--region-img:url('https://images.squarespace-cdn.com/content/v1/568297fb1115e07a05646b0d/1533455926976-EKXT0AWFFOP0KK72MPHI/Northern%2BSumatra%2B40%2Bheejennwei%28C%29.JPG')" href="<?= $this->url->get('kuliner?daerah=Sumatera%20Barat') ?>"><b>Sumatra</b><small>Rempah dan tradisi yang kaya</small></a>
  <a class="region" style="--region-img:url('https://cdn.getyourguide.com/image/format%3Dauto%2Cfit%3Dcrop%2Cgravity%3Dauto%2Cquality%3D60%2Cwidth%3D900%2Cheight%3D700%2Cdpr%3D2/tour_img/07bf78a13c07fdff441c3ea0f97b35eb276d3f90f6b581d455496bf9980aef8c.jpg')" href="<?= $this->url->get('kuliner?daerah=Jawa') ?>"><b>Jawa</b><small>Kelezatan di setiap sajian</small></a>
  <a class="region" style="--region-img:url('https://www.i-travel.bg/static/185/images/travel_offer_images/bali-guide.jpg.jpg?h=525&w=900')" href="<?= $this->url->get('kuliner?daerah=Bali') ?>"><b>Bali & Nusa Tenggara</b><small>Tradisi dan bumbu berani</small></a>
  <a class="region" style="--region-img:url('https://cdn-jpr.jawapos.com/images/7/2025/06/09/Raja-Ampat-Papua-3728573667.jpg')" href="<?= $this->url->get('kuliner?daerah=Maluku%20%26%20Papua') ?>"><b>Indonesia Timur</b><small>Segar, unik, dan beragam</small></a>
 </div>
</section>
<section class="section container" id="cerita">
 <div class="section-head"><div><span class="eyebrow">Lebih dari sekadar hidangan</span><h2>Ada cerita di setiap rasa</h2></div><a class="text-link" href="<?= $this->url->get('cerita') ?>">Semua cerita ↗</a></div>
 <div class="story-grid">
 <?php foreach ($stories as $story) { ?>
  <article class="story-card"><a class="story-card-image" href="<?= $this->url->get('cerita/' . $story->slug) ?>"><img src="<?= $this->url->get($story->gambar) ?>" alt="<?= $this->escaper->escapeHtml($story->judul) ?>" loading="lazy"></a><small><?= $this->escaper->escapeHtml($story->kategori) ?> · <?= $this->escaper->escapeHtml($story->daerah) ?></small><h3><a href="<?= $this->url->get('cerita/' . $story->slug) ?>"><?= $this->escaper->escapeHtml($story->judul) ?></a></h3><p><?= $this->escaper->escapeHtml($story->ringkasan) ?></p><a href="<?= $this->url->get('cerita/' . $story->slug) ?>">Baca cerita ↗</a></article>
 <?php } ?>
 </div>
</section>
<section class="container contribution"><img src="<?= $this->url->get('img/kuliner/rendang.jpg') ?>" alt="Rendang khas Sumatera Barat"><div><span class="eyebrow">Jurnal rasa Nusantara</span><h2>Setiap rasa punya cerita.</h2><p>Temukan kisah di balik makanan khas, resep keluarga, bahan lokal, dan tradisi dari berbagai penjuru Indonesia.</p></div><a class="button" href="<?= $this->url->get('cerita') ?>">Jelajahi Artikel →</a></section>
</main>

<footer class="footer">
  <div class="footer-grid">
    <div><a class="brand brand-light" href="<?= $this->url->get('') ?>"><span class="brand-mark"><img src="<?= $this->url->get('img/rasakuliner-mark.png') ?>?v=1" alt=""></span>RasaKuliner</a><p>Ruang untuk mengenal, merawat, dan meneruskan kekayaan rasa Nusantara. Satu hidangan, banyak cerita.</p></div>
    <div><b>Jelajahi</b><a href="<?= $this->url->get('kuliner') ?>">Jelajahi Kuliner</a><a href="<?= $this->url->get('peta') ?>">Peta Kuliner</a><a href="<?= $this->url->get('') ?>">Koleksi Pilihan</a></div>
    <div><b>Ruang cerita</b><a href="<?= $this->url->get('cerita') ?>">Cerita & Blog</a><a href="#">Tentang Kami</a><a href="#">Kontribusi</a></div>
    <div><b>Tetap terhubung</b><a href="#">Instagram</a><a href="#">Hubungi Kami</a><a href="#">Panduan Kontribusi</a></div>
  </div>
  <div class="copyright"><span>© 2026 RasaKuliner. Merawat rasa, menjaga cerita.</span><span>Kebijakan Privasi　·　Syarat Penggunaan</span></div>
</footer>
<script src="<?= $this->url->get('assets/js/app.js') ?>?v=<?= $assetVer ?>"></script>
</body>
</html>
