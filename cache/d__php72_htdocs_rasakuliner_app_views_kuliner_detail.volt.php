<!doctype html>
<html lang="id">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?= (empty($title) ? ('RasaNusantara') : ($title)) ?></title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Bricolage+Grotesque:opsz,wght@12..96,600..800&family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="<?= $this->url->get('assets/css/style.css') ?>?v=<?= $assetVer ?>" rel="stylesheet">
</head>
<body>
<header class="site-header">
  <a class="brand" href="<?= $this->url->get('') ?>"><span class="brand-mark">✿</span><span>RasaNusantara</span></a>
  <nav class="main-nav">
    <a href="<?= $this->url->get('') ?>" class="<?= (isset($active) && $active == 'home' ? 'active' : '') ?>">Beranda</a>
    <a href="<?= $this->url->get('kuliner') ?>" class="<?= (isset($active) && $active == 'kuliner' ? 'active' : '') ?>">Jelajahi Kuliner</a>
    <a href="<?= $this->url->get('peta') ?>" class="<?= (isset($active) && $active == 'peta' ? 'active' : '') ?>">Peta Kuliner</a>
    <a href="<?= $this->url->get('#cerita') ?>">Cerita & Blog</a>
    <a href="<?= $this->url->get('kuliner#kontribusi') ?>">Kontribusi</a>
  </nav>
  <?php if ($isSeller) { ?>
  <div class="seller-user-menu"><a class="seller-user-trigger" href="<?= $this->url->get('seller') ?>"><span class="seller-user-avatar"><?= Phalcon\Text::upper($this->slice($headerSellerName, 0, 1)) ?></span><span><?= $this->escaper->escapeHtml($headerSellerName) ?></span><span>⌄</span></a><div class="seller-user-dropdown"><a href="<?= $this->url->get('seller') ?>">Dashboard Seller</a><a href="<?= $this->url->get('seller/profil') ?>">Profil Usaha</a><a href="<?= $this->url->get('seller/tambah') ?>">Tambah Kuliner</a><a href="<?= $this->url->get('logout') ?>">Keluar</a></div></div>
  <?php } else { ?>
  <a class="login-link" href="<?= $this->url->get('login-seller') ?>">Login Seller <span>↗</span></a>
  <?php } ?>
  <button class="menu-toggle" aria-label="Buka menu">☰</button>
</header>

<link rel="stylesheet" href="<?= $this->url->get('assets/vendor/leaflet/leaflet.css') ?>">
<main class="container detail-page" id="detail-app" data-items="<?= $this->escaper->escapeHtml($lokasiJson) ?>" data-focus="<?= $focus ?>" data-base="<?= $this->url->get('') ?>">
 <div class="breadcrumb"><a href="<?= $this->url->get('') ?>">Beranda</a>　›　<a href="<?= $this->url->get('kuliner') ?>">Jelajahi Kuliner</a>　›　<span><?= $this->escaper->escapeHtml($kuliner->nama) ?></span></div>

 <section class="detail-hero">
  <div class="detail-photo"><img src="<?= $this->escaper->escapeHtml($kuliner->gambar) ?>" alt="<?= $this->escaper->escapeHtml($kuliner->nama) ?>"></div>
  <div class="detail-info">
   <span class="eyebrow"><?= $this->escaper->escapeHtml($kuliner->daerah) ?></span>
   <h1><?= $this->escaper->escapeHtml($kuliner->nama) ?></h1>
   <span class="tag"><?= $this->escaper->escapeHtml($kuliner->kategori) ?></span>
   <p><?= $this->escaper->escapeHtml($kuliner->deskripsi) ?></p>
   <div class="detail-actions">
    <a class="button" href="#lokasi">Lihat lokasi di peta</a>
    <a class="outline-button" href="<?= $this->url->get('peta') ?>">Buka peta kuliner ↗</a>
   </div>
  </div>
 </section>

 <section class="detail-location" id="lokasi">
  <div class="section-head">
   <div><span class="eyebrow">Tempat menikmati</span><h2>Lokasi <?= $this->escaper->escapeHtml($kuliner->nama) ?></h2></div>
   <button type="button" id="detail-locate" class="outline-button as-button">◎ Hitung jarak dari lokasi saya</button>
  </div>
  <?php if ($dbError != '') { ?><div class="peta-alert"><?= $this->escaper->escapeHtml($dbError) ?></div><?php } ?>
  <div class="detail-grid">
   <div class="detail-map-wrap"><div id="map" class="detail-map"></div></div>
   <div class="detail-places" id="detail-list">
    <?php if ($this->length($lokasi) == 0) { ?><div class="empty-state"><h3>Lokasi belum tersedia</h3><p>Belum ada tempat yang tercatat untuk kuliner ini.</p></div><?php } ?>
   </div>
  </div>
  <div class="map-credit">Peta © kontributor OpenStreetMap. Titik lokasi berasal dari latitude &amp; longitude di database.</div>
 </section>

 <?php if ($this->length($lainnya) > 0) { ?>
 <section class="section">
  <div class="section-head"><div><span class="eyebrow">Jelajahi lagi</span><h2>Kuliner lainnya</h2></div></div>
  <div class="food-grid three">
  <?php foreach ($lainnya as $item) { ?>
   <a class="food-card" href="<?= $this->url->get('kuliner/detail/' . $item->id) ?>"><div class="food-image"><img src="<?= $this->escaper->escapeHtml($item->gambar) ?>" alt="<?= $this->escaper->escapeHtml($item->nama) ?>"></div><div class="food-info"><small>⌖ <?= $this->escaper->escapeHtml($item->daerah) ?></small><h3><?= $this->escaper->escapeHtml($item->nama) ?></h3><p><?= $this->escaper->escapeHtml($item->deskripsi) ?></p><span class="tag"><?= $this->escaper->escapeHtml($item->kategori) ?></span></div></a>
  <?php } ?>
  </div>
 </section>
 <?php } ?>
</main>
<script src="<?= $this->url->get('assets/vendor/leaflet/leaflet.js') ?>"></script>
<script src="<?= $this->url->get('assets/js/maputil.js') ?>?v=<?= $assetVer ?>"></script>
<script src="<?= $this->url->get('assets/js/detail.js') ?>?v=<?= $assetVer ?>"></script>

<footer class="footer">
  <div class="footer-grid">
    <div><a class="brand brand-light" href="<?= $this->url->get('') ?>"><span class="brand-mark">✿</span>RasaNusantara</a><p>Ruang untuk mengenal, merawat, dan meneruskan kekayaan rasa Nusantara. Satu hidangan, banyak cerita.</p></div>
    <div><b>Jelajahi</b><a href="<?= $this->url->get('kuliner') ?>">Jelajahi Kuliner</a><a href="<?= $this->url->get('peta') ?>">Peta Kuliner</a><a href="<?= $this->url->get('') ?>">Koleksi Pilihan</a></div>
    <div><b>Ruang cerita</b><a href="<?= $this->url->get('#cerita') ?>">Cerita & Blog</a><a href="#">Tentang Kami</a><a href="#">Kontribusi</a></div>
    <div><b>Tetap terhubung</b><a href="#">Instagram</a><a href="#">Hubungi Kami</a><a href="#">Panduan Kontribusi</a></div>
  </div>
  <div class="copyright"><span>© 2026 RasaNusantara. Merawat rasa, menjaga cerita.</span><span>Kebijakan Privasi　·　Syarat Penggunaan</span></div>
</footer>
<script src="<?= $this->url->get('assets/js/app.js') ?>?v=<?= $assetVer ?>"></script>
</body>
</html>
