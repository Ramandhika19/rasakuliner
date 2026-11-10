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

<link rel="stylesheet" href="<?= $this->url->get('assets/vendor/leaflet/leaflet.css') ?>">
<main class="container detail-page" id="detail-app" data-items="<?php if ($isViewer) { ?><?= $this->escaper->escapeHtml($lokasiJson) ?><?php } else { ?>[]<?php } ?>" data-focus="<?= $focus ?>" data-base="<?= $this->url->get('') ?>">
 <div class="breadcrumb"><a href="<?= $this->url->get('') ?>">Beranda</a>　›　<a href="<?= $this->url->get('kuliner') ?>">Jelajahi Kuliner</a>　›　<span><?= $this->escaper->escapeHtml($kuliner->nama) ?></span></div>

 <section class="detail-hero">
  <div class="detail-media">
   <div class="detail-photo" data-gallery="<?= $this->escaper->escapeHtml($kuliner->gambar_gallery) ?>"><img src="<?= $this->escaper->escapeHtml($kuliner->gambar_url) ?>" alt="<?= $this->escaper->escapeHtml($kuliner->nama) ?>"></div>
   <?php if ($this->length($kuliner->gambar_list) > 1) { ?>
   <div class="detail-gallery-thumbs" aria-label="Galeri foto kuliner">
    <?php $v37944934931iterator = $kuliner->gambar_list; $v37944934931incr = 0; $v37944934931loop = new stdClass(); $v37944934931loop->self = &$v37944934931loop; $v37944934931loop->length = count($v37944934931iterator); $v37944934931loop->index = 1; $v37944934931loop->index0 = 1; $v37944934931loop->revindex = $v37944934931loop->length; $v37944934931loop->revindex0 = $v37944934931loop->length - 1; ?><?php foreach ($v37944934931iterator as $photo) { ?><?php $v37944934931loop->first = ($v37944934931incr == 0); $v37944934931loop->index = $v37944934931incr + 1; $v37944934931loop->index0 = $v37944934931incr; $v37944934931loop->revindex = $v37944934931loop->length - $v37944934931incr; $v37944934931loop->revindex0 = $v37944934931loop->length - ($v37944934931incr + 1); $v37944934931loop->last = ($v37944934931incr == ($v37944934931loop->length - 1)); ?>
     <button type="button" class="detail-gallery-thumb" data-photo-index="<?= $v37944934931loop->index0 ?>" aria-label="Lihat foto <?= $v37944934931loop->index ?>"><img src="<?= $this->escaper->escapeHtml($photo) ?>" alt="Foto <?= $this->escaper->escapeHtml($kuliner->nama) ?>"></button>
    <?php $v37944934931incr++; } ?>
   </div>
   <?php } ?>
  </div>
  <div class="detail-info">
   <span class="eyebrow">Kuliner khas <?= $this->escaper->escapeHtml($kuliner->daerah) ?></span>
   <h1><?= $this->escaper->escapeHtml($kuliner->nama) ?></h1>
   <span class="tag"><?= $this->escaper->escapeHtml($kuliner->kategori) ?></span>
   <p><?= $this->escaper->escapeHtml($kuliner->deskripsi) ?></p>
   <div class="detail-facts">
    <div><small>Asal daerah</small><strong><?= $this->escaper->escapeHtml($kuliner->daerah) ?></strong></div>
    <div><small>Kategori</small><strong><?= $this->escaper->escapeHtml($kuliner->kategori) ?></strong></div>
   </div>
   <div class="detail-actions">
    <a class="button" href="#lokasi">Lihat lokasi <span aria-hidden="true">↓</span></a>
    <a class="outline-button" href="<?= $this->url->get('peta') ?>">Jelajahi peta ↗</a>
   </div>
  </div>
 </section>

 <section class="detail-location" id="lokasi">
  <div class="section-head">
   <div><span class="eyebrow">Tempat menikmati</span><h2>Lokasi <?= $this->escaper->escapeHtml($kuliner->nama) ?></h2></div>
   <?php if ($isViewer) { ?><button type="button" id="detail-locate" class="outline-button as-button">◎ Hitung jarak dari lokasi saya</button><?php } ?>
  </div>
  <?php if ($dbError != '') { ?><div class="peta-alert"><?= $this->escaper->escapeHtml($dbError) ?></div><?php } ?>
  <?php if ($isViewer) { ?>
  <div class="detail-grid">
   <div class="detail-map-wrap"><div id="map" class="detail-map"></div></div>
   <div class="detail-places" id="detail-list">
    <?php if ($this->length($lokasi) == 0) { ?>
     <div class="empty-state">
      <h3><?php if ($alamatDatabase != '') { ?>Alamat dari database<?php } else { ?>Lokasi belum tersedia<?php } ?></h3>
      <?php if ($alamatDatabase != '') { ?>
       <p><?= $this->escaper->escapeHtml($alamatDatabase) ?><?php if ($kuliner->daerah) { ?>, <?= $this->escaper->escapeHtml($kuliner->daerah) ?><?php } ?></p>
       <div class="place-links">
        <a href="<?= $this->escaper->escapeHtml($alamatMapsUrl) ?>" target="_blank" rel="noopener">Cari alamat di Google Maps ↗</a>
        <a href="<?= $this->escaper->escapeHtml($alamatOsmUrl) ?>" target="_blank" rel="noopener">Cari alamat di OpenStreetMap ↗</a>
       </div>
      <?php } else { ?>
       <p>Alamat belum diisi pada data kuliner. Seller dapat memperbarui alamat melalui halaman edit kuliner.</p>
      <?php } ?>
     </div>
    <?php } ?>
   </div>
  </div>
  <div class="map-credit">Peta © kontributor OpenStreetMap. Titik lokasi berasal dari latitude &amp; longitude di database.</div>
  <?php } else { ?><div class="map-login-prompt"><h3>Masuk untuk membuka peta kuliner</h3><p>Login sebagai User atau Seller untuk melihat peta dan menghitung jarak lokasi kuliner.</p><a class="button" href="<?= $this->url->get('login-user') ?>">Login User</a> <a class="outline-button" href="<?= $this->url->get('login') ?>">Login Seller</a></div><?php } ?>
 </section>


 <section class="detail-reviews" id="ulasan">
  <div class="section-head"><div><span class="eyebrow">Cerita pengunjung</span><h2>Ulasan &amp; rating</h2><p class="review-intro">Pengalaman komunitas RasaKuliner dan referensi ulasan dari Google Maps.</p></div></div>
  <div class="review-overview">
   <div class="review-score"><?php if ($reviewTotal > 0) { ?><strong><?= $reviewAverageDisplay ?></strong><span class="review-stars">★★★★★</span><?php } else { ?><strong>—</strong><small>Belum ada rating</small><?php } ?><small><?= $reviewTotal ?> ulasan RasaKuliner</small></div>
   <div class="review-overview-copy"><b>Suara para penikmat kuliner</b><p>Rating dihitung dari ulasan yang ditulis langsung oleh pengguna RasaKuliner.</p></div>
  </div>
  <div class="google-review-section">
   <div class="google-review-heading"><div><span class="eyebrow">Sumber eksternal</span><h3>Ulasan di Google Maps</h3><p>Temukan rating dan pengalaman pengunjung langsung di Google Maps. Ulasan Google dibuka dari sumber aslinya agar informasinya tetap akurat.</p></div><span class="google-mark">Google Maps</span></div>
   <?php if ($this->length($googleReviewPlaces) > 0) { ?>
    <div class="google-review-grid">
    <?php $v37944934931iterator = $googleReviewPlaces; $v37944934931incr = 0; $v37944934931loop = new stdClass(); $v37944934931loop->self = &$v37944934931loop; $v37944934931loop->length = count($v37944934931iterator); $v37944934931loop->index = 1; $v37944934931loop->index0 = 1; $v37944934931loop->revindex = $v37944934931loop->length; $v37944934931loop->revindex0 = $v37944934931loop->length - 1; ?><?php foreach ($v37944934931iterator as $place) { ?><?php $v37944934931loop->first = ($v37944934931incr == 0); $v37944934931loop->index = $v37944934931incr + 1; $v37944934931loop->index0 = $v37944934931incr; $v37944934931loop->revindex = $v37944934931loop->length - $v37944934931incr; $v37944934931loop->revindex0 = $v37944934931loop->length - ($v37944934931incr + 1); $v37944934931loop->last = ($v37944934931incr == ($v37944934931loop->length - 1)); ?>
     <article class="google-review-card"><div><b><?= $this->escaper->escapeHtml($place->name) ?></b><?php if ($place->rating) { ?><span class="review-stars">★ <?= $place->rating ?></span><?php } ?></div><p><?= $this->escaper->escapeHtml($place->address) ?></p><a href="<?= $this->escaper->escapeHtml($place->url) ?>" target="_blank" rel="noopener">Baca ulasan di Google Maps ↗</a></article>
    <?php $v37944934931incr++; } ?>
    </div>
   <?php } else { ?>
    <p class="muted">Lokasi belum memiliki tautan Google Maps. Seller dapat melengkapi alamat tempat terlebih dahulu.</p>
   <?php } ?>
  </div>
  <div class="community-review-heading"><h3>Review komunitas RasaKuliner</h3><span><?= $reviewTotal ?> ulasan</span></div>
  <?php if ($reviewError) { ?><div class="peta-alert"><?= $this->escaper->escapeHtml($reviewError) ?></div><?php } ?>
  <?php if ($reviewSuccess) { ?><div class="review-success"><?= $this->escaper->escapeHtml($reviewSuccess) ?></div><?php } ?>
  <?php if ($isUser) { ?>
  <form class="review-form" method="post" action="<?= $this->url->get('review/' . $kuliner->id) ?>">
   <label>Rating<select name="rating" required><option value="">Pilih rating</option><option value="5">★★★★★ - Sangat suka</option><option value="4">★★★★ - Suka</option><option value="3">★★★ - Cukup</option><option value="2">★★ - Kurang</option><option value="1">★ - Tidak suka</option></select></label>
   <label>Ulasan<textarea name="komentar" rows="4" maxlength="1500" required placeholder="Bagikan pengalamanmu mencoba kuliner ini..."></textarea></label>
   <button class="button" type="submit">Kirim Review</button>
  </form>
  <?php } elseif ($isSeller || $isAdmin) { ?><div class="map-login-prompt"><p>Akun Seller dapat membaca semua ulasan. Fitur menulis review tersedia khusus untuk akun User.</p></div><?php } else { ?><div class="map-login-prompt"><p>Login sebagai User untuk memberikan rating dan review.</p><a class="button" href="<?= $this->url->get('login-user') ?>">Login User</a> <a class="outline-button" href="<?= $this->url->get('daftar-user') ?>">Daftar User</a></div><?php } ?>
  <div class="review-list"><?php $v37944934931iterated = false; ?><?php $v37944934931iterator = $reviews; $v37944934931incr = 0; $v37944934931loop = new stdClass(); $v37944934931loop->self = &$v37944934931loop; $v37944934931loop->length = count($v37944934931iterator); $v37944934931loop->index = 1; $v37944934931loop->index0 = 1; $v37944934931loop->revindex = $v37944934931loop->length; $v37944934931loop->revindex0 = $v37944934931loop->length - 1; ?><?php foreach ($v37944934931iterator as $review) { ?><?php $v37944934931loop->first = ($v37944934931incr == 0); $v37944934931loop->index = $v37944934931incr + 1; $v37944934931loop->index0 = $v37944934931incr; $v37944934931loop->revindex = $v37944934931loop->length - $v37944934931incr; $v37944934931loop->revindex0 = $v37944934931loop->length - ($v37944934931incr + 1); $v37944934931loop->last = ($v37944934931incr == ($v37944934931loop->length - 1)); ?><?php $v37944934931iterated = true; ?><article class="review-card"><div><strong><?= $this->escaper->escapeHtml((empty($review->nama_pengunjung) ? ('Pengunjung') : ($review->nama_pengunjung))) ?></strong><span class="review-stars"><?= $review->rating ?> ★</span></div><p><?= $this->escaper->escapeHtml($review->komentar) ?></p><small><?= $review->created_at ?></small></article><?php $v37944934931incr++; } if (!$v37944934931iterated) { ?><p class="muted">Belum ada ulasan. Jadilah yang pertama berbagi pengalaman.</p><?php } ?></div>
 </section>

 <?php if ($this->length($lainnya) > 0) { ?>
 <section class="section">
  <div class="section-head"><div><span class="eyebrow">Jelajahi lagi</span><h2>Kuliner lainnya</h2></div></div>
  <div class="food-grid three">
  <?php $v37944934931iterator = $lainnya; $v37944934931incr = 0; $v37944934931loop = new stdClass(); $v37944934931loop->self = &$v37944934931loop; $v37944934931loop->length = count($v37944934931iterator); $v37944934931loop->index = 1; $v37944934931loop->index0 = 1; $v37944934931loop->revindex = $v37944934931loop->length; $v37944934931loop->revindex0 = $v37944934931loop->length - 1; ?><?php foreach ($v37944934931iterator as $item) { ?><?php $v37944934931loop->first = ($v37944934931incr == 0); $v37944934931loop->index = $v37944934931incr + 1; $v37944934931loop->index0 = $v37944934931incr; $v37944934931loop->revindex = $v37944934931loop->length - $v37944934931incr; $v37944934931loop->revindex0 = $v37944934931loop->length - ($v37944934931incr + 1); $v37944934931loop->last = ($v37944934931incr == ($v37944934931loop->length - 1)); ?>
   <a class="food-card" href="<?= $this->url->get('kuliner/detail/' . $item->id) ?>"><div class="food-image"><img src="<?= $this->escaper->escapeHtml($item->gambar_url) ?>" alt="<?= $this->escaper->escapeHtml($item->nama) ?>"></div><div class="food-info"><small>⌖ <?= $this->escaper->escapeHtml($item->daerah) ?></small><h3><?= $this->escaper->escapeHtml($item->nama) ?></h3><p><?= $this->escaper->escapeHtml($item->deskripsi) ?></p><span class="tag"><?= $this->escaper->escapeHtml($item->kategori) ?></span></div></a>
  <?php $v37944934931incr++; } ?>
  </div>
 </section>
 <?php } ?>
</main>
<?php if ($isViewer) { ?><script src="<?= $this->url->get('assets/vendor/leaflet/leaflet.js') ?>"></script>
<script src="<?= $this->url->get('assets/js/maputil.js') ?>?v=<?= $assetVer ?>"></script>
<script src="<?= $this->url->get('assets/js/detail.js') ?>?v=<?= $assetVer ?>"></script><?php } ?>

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
