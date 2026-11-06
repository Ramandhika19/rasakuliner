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
  <div class="seller-user-menu"><a class="seller-user-trigger" href="<?= $this->url->get('seller') ?>"><?php if ($headerSellerPhoto) { ?><span class="seller-user-avatar"><img src="<?= $this->url->get($headerSellerPhoto) ?>" alt="Foto profil"></span><?php } else { ?><span class="seller-user-avatar"><?= Phalcon\Text::upper($this->slice($headerSellerName, 0, 1)) ?></span><?php } ?><span><?= $this->escaper->escapeHtml($headerSellerName) ?></span><span>⌄</span></a><div class="seller-user-dropdown"><a href="<?= $this->url->get('seller') ?>">Dashboard Seller</a><a href="<?= $this->url->get('seller/profil') ?>">Profil Usaha</a><a href="<?= $this->url->get('seller/tambah') ?>">Tambah Kuliner</a><a href="<?= $this->url->get('logout') ?>">Keluar</a></div></div>
  <?php } else { ?>
  <a class="login-link" href="<?= $this->url->get('login-seller') ?>">Login Seller <span>↗</span></a>
  <?php } ?>
  <button class="menu-toggle" aria-label="Buka menu">☰</button>
</header>

<main class="seller-shell">
<aside class="seller-sidebar">
  <div class="seller-avatar"><?php if ($sellerProfile->foto_profil) { ?><img src="<?= $this->url->get($sellerProfile->foto_profil) ?>" alt="Foto profil"><?php } else { ?><?= Phalcon\Text::upper($this->slice($sellerName, 0, 1)) ?><?php } ?></div>
  <b><?= $this->escaper->escapeHtml($sellerProfile->nama_usaha) ?></b><small>Area Seller</small>
  <nav><a href="<?= $this->url->get('seller') ?>">▦　Dashboard</a><a href="<?= $this->url->get('seller/tambah') ?>">＋　Tambah Kuliner</a><a class="selected" href="<?= $this->url->get('seller/profil') ?>">♙　Profil Usaha</a><a href="<?= $this->url->get('logout') ?>">↪　Keluar</a></nav>
</aside>
<section class="seller-content">
  <div class="seller-top"><div><span class="eyebrow">Identitas mitra</span><h1>Profil Usaha</h1><p>Perbarui identitas, kontak, alamat, dan foto profil usahamu.</p></div></div>
  <?php if ($error) { ?><div class="form-alert"><?= $this->escaper->escapeHtml($error) ?></div><?php } ?>
  <form method="post" enctype="multipart/form-data" class="seller-form seller-form-card">
    <label class="full">Foto profil usaha</label>
    <div class="upload-dropzone profile-dropzone full" data-dropzone>
      <input type="file" name="foto_profil" accept="image/jpeg,image/png,image/webp">
      <div class="dropzone-prompt"><span class="dropzone-icon">＋</span><b>Tarik foto profil ke sini</b><small>atau klik untuk memilih · JPG, PNG, WEBP · maks. 4 MB</small></div>
      <img class="dropzone-preview" src="<?php if ($sellerProfile->foto_profil) { ?><?= $this->url->get($sellerProfile->foto_profil) ?><?php } ?>" alt="Pratinjau foto profil" <?php if (!$sellerProfile->foto_profil) { ?>hidden<?php } ?>>
      <small class="current-image-note">Foto tersimpan otomatis di folder uploads/profil/<?= $sellerProfile->user_id ?>. Jika tidak memilih gambar baru, foto saat ini tetap digunakan.</small>
    </div>
    <label>Nama usaha<input name="nama_usaha" required value="<?= $this->escaper->escapeHtml($sellerProfile->nama_usaha) ?>"></label>
    <label>Jenis usaha<input name="jenis_usaha" value="<?= $this->escaper->escapeHtml($sellerProfile->jenis_usaha) ?>"></label>
    <label>Nomor telepon / WhatsApp<input name="nomor_telepon" value="<?= $this->escaper->escapeHtml($sellerProfile->nomor_telepon) ?>"></label>
    <label class="full">Alamat usaha<textarea name="alamat" rows="4"><?= $this->escaper->escapeHtml($sellerProfile->alamat) ?></textarea></label>
    <div class="form-hint full">Status verifikasi: <b><?= ucwords($sellerProfile->verification_status) ?></b></div>
    <button class="button" type="submit">Simpan profil</button>
  </form>
</section>
</main>

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
