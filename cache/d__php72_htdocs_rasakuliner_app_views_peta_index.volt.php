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
<main class="peta-page" id="peta-app" data-items="<?= $this->escaper->escapeHtml($itemsJson) ?>" data-base="<?= $this->url->get('') ?>">
 <aside class="peta-panel">
  <div class="peta-head">
   <span class="eyebrow">Peta kuliner</span>
   <h1>Temukan rasa terdekat</h1>
   <p>Cari tempat makanan khas di sekitar Anda. Klik peta untuk memindahkan titik pencarian.</p>
  </div>
  <?php if ($dbError != '') { ?><div class="peta-alert"><?= $this->escaper->escapeHtml($dbError) ?></div><?php } ?>
  <form class="peta-search" onsubmit="return false">
   <span>⌕</span><input id="peta-q" type="search" placeholder="Cari makanan, tempat, atau kota..." autocomplete="off">
  </form>
  <div class="peta-filters">
   <label>Radius
    <select id="peta-radius">
     <option value="1">1 km</option><option value="3">3 km</option><option value="5">5 km</option>
     <option value="10">10 km</option><option value="25" selected>25 km</option><option value="50">50 km</option>
     <option value="100">100 km</option><option value="0">Semua</option>
    </select>
   </label>
   <label>Jenis
    <select id="peta-kat">
     <option value="">Semua</option>
     <?php foreach ($kategori as $k) { ?><option value="<?= $this->escaper->escapeHtml($k) ?>"><?= $this->escaper->escapeHtml($k) ?></option><?php } ?>
    </select>
   </label>
   <button type="button" id="peta-locate" class="button">◎ Lokasi saya</button>
  </div>
  <div class="peta-meta"><b id="peta-count"><?= $total ?> tempat</b><span id="peta-status"></span></div>
  <div class="peta-list" id="peta-list"></div>
 </aside>
 <section class="peta-map-wrap"><div id="map" class="peta-map"></div></section>
</main>
<script src="<?= $this->url->get('assets/vendor/leaflet/leaflet.js') ?>"></script>
<script src="<?= $this->url->get('assets/js/maputil.js') ?>?v=<?= $assetVer ?>"></script>
<script src="<?= $this->url->get('assets/js/peta.js') ?>?v=<?= $assetVer ?>"></script>

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
