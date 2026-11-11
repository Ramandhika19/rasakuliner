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
<main class="seller-shell">
<aside class="seller-sidebar">
  <div class="seller-avatar"><?php if ($sellerProfile->foto_profil) { ?><img src="<?= $this->url->get($sellerProfile->foto_profil) ?>" alt="Foto profil"><?php } else { ?><?= Phalcon\Text::upper($this->slice($sellerName, 0, 1)) ?><?php } ?></div>
  <b><?= $this->escaper->escapeHtml($sellerProfile->nama_usaha) ?></b><small>Area Seller</small>
  <nav><a href="<?= $this->url->get('seller') ?>">▦　Dashboard</a><a class="selected" href="<?= $this->url->get('seller/tambah') ?>">＋　Tambah Kuliner</a><a href="<?= $this->url->get('seller/profil') ?>">♙　Profil Usaha</a><a href="<?= $this->url->get('logout') ?>">↪　Keluar</a></nav>
</aside>
<section class="seller-content">
  <a class="text-link" href="<?= $this->url->get('seller') ?>">← Kembali ke dashboard</a>
  <div class="seller-top"><div><span class="eyebrow">Katalog usaha</span><h1><?= ($isEdit ? 'Edit data kuliner' : 'Tambah kuliner baru') ?></h1><p>Lengkapi informasi makanan khas daerah yang ingin kamu promosikan.</p></div></div>
  <?php if ($error) { ?><div class="form-alert"><?= $this->escaper->escapeHtml($error) ?></div><?php } ?>
  <form method="post" enctype="multipart/form-data" class="seller-form seller-form-card">
    <label>Nama makanan / minuman<input name="nama" required value="<?= $this->escaper->escapeHtml((empty($food->nama) ? ('') : ($food->nama))) ?>" placeholder="Contoh: Ayam Betutu"></label>
    <label>Daerah asal<input name="daerah" required value="<?= $this->escaper->escapeHtml((empty($food->daerah) ? ('') : ($food->daerah))) ?>" placeholder="Contoh: Bali"></label>
    <label>Kategori<input name="kategori" required value="<?= $this->escaper->escapeHtml((empty($food->kategori) ? ('') : ($food->kategori))) ?>" placeholder="Makanan berat, minuman, camilan..."></label>
    <label class="full">Foto makanan</label>
    <div class="upload-dropzone full" data-dropzone>
      <input type="file" name="gambar[]" accept="image/jpeg,image/png,image/webp" multiple <?php if (!$isEdit) { ?>required<?php } ?>>
      <div class="dropzone-prompt"><span class="dropzone-icon">＋</span><b>Tarik 1–3 gambar di sini</b><small>Pilih maksimal 3 foto · JPG, PNG, WEBP · maks. 4 MB per foto</small></div>
      <div class="multi-preview-grid" data-multi-preview></div>
      <?php if ($isEdit) { ?><small class="current-image-note">Foto saat ini tetap digunakan jika kamu tidak memilih foto baru. Pilih 1–3 foto untuk mengganti seluruh galeri.</small><?php } ?>
    </div>
    <label class="full">Alamat / nama tempat<input id="seller-address" name="lokasi_alamat" required value="<?= $this->escaper->escapeHtml((empty($food->lokasi_alamat) ? ('') : ($food->lokasi_alamat))) ?>" placeholder="Cari alamat usaha, nama jalan, atau tempat..."></label>
    <div class="map-picker-wrap full">
      <div class="map-picker-toolbar"><button type="button" class="button button-secondary" id="seller-map-search">Cari alamat</button><button type="button" class="button button-secondary" id="seller-map-current">Gunakan lokasi saya</button><a id="seller-google-maps" class="map-google-link" href="https://www.google.com/maps" target="_blank" rel="noopener">Buka Google Maps ↗</a></div>
      <div id="seller-location-map" class="seller-location-map" data-lat="<?= (empty($food->latitude) ? ('') : ($food->latitude)) ?>" data-lng="<?= (empty($food->longitude) ? ('') : ($food->longitude)) ?>"></div>
      <div class="map-coordinates"><span id="seller-map-status">Klik peta untuk menentukan lokasi atau cari alamat di atas.</span><span>OpenStreetMap</span></div>
      <input type="hidden" id="seller-latitude" name="latitude" value="<?= (empty($food->latitude) ? ('') : ($food->latitude)) ?>">
      <input type="hidden" id="seller-longitude" name="longitude" value="<?= (empty($food->longitude) ? ('') : ($food->longitude)) ?>">
      <small class="form-hint">Pilih titik lokasi usaha pada peta. Pin bisa digeser untuk memperbaiki posisi. Koordinat dipakai sebagai marker OpenStreetMap; Google Maps hanya tautan navigasi.</small>
    </div>
    <label class="full">Deskripsi<textarea name="deskripsi" rows="5" required placeholder="Ceritakan keunikan, bahan, dan cita rasa kuliner ini..."><?= $this->escaper->escapeHtml((empty($food->deskripsi) ? ('') : ($food->deskripsi))) ?></textarea></label>
    <div class="form-hint full">Setelah disimpan, data berstatus <b>Menunggu</b> dan akan ditinjau admin sebelum tampil di website.</div>
    <button class="button" type="submit">Simpan pengajuan →</button>
  </form>
</section>
</main>
<script src="<?= $this->url->get('assets/vendor/leaflet/leaflet.js') ?>"></script>
<script src="<?= $this->url->get('assets/js/seller-location.js') ?>?v=<?= $assetVer ?>"></script>

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
