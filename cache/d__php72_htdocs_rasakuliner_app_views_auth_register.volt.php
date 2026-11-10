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

<main class="auth-page"><section class="auth-card"><span class="eyebrow">Bergabung sebagai mitra</span><h1>Kenalkan rasa khas daerahmu.</h1><p class="auth-intro">Daftarkan usaha makanan atau minuman khas daerah. Pendaftaran akan diperiksa admin sebelum akses Seller diaktifkan.</p>
<?php if ($error) { ?><div class="form-alert" role="alert" style="margin:16px 0;padding:14px 16px;border-radius:10px"><?= $this->escaper->escapeHtml($error) ?></div><?php } ?>
<?php if ($success) { ?><div class="form-alert" role="status" style="background:#eaf8ef;color:#176b36;border:1px solid #b8e3c5;padding:14px 16px;border-radius:10px;margin:16px 0;line-height:1.6"><strong>Pendaftaran berhasil disimpan.</strong><br><?= $this->escaper->escapeHtml($success) ?></div><?php } ?>
<form method="post" class="seller-form">
<label>Nama lengkap<input name="nama" required maxlength="120" placeholder="Nama pemilik usaha"></label>
<label>Email<input type="email" name="email" required placeholder="nama@email.com"></label>
<label>Password<input type="password" name="password" required minlength="8" placeholder="Minimal 8 karakter"></label>
<label>Nama usaha / brand<input name="nama_usaha" required maxlength="160" placeholder="Contoh: Warung Bali Asli"></label>
<label>Jenis usaha<input name="jenis_usaha" placeholder="Makanan, minuman, oleh-oleh..."></label>
<label>Nomor WhatsApp<input name="nomor_telepon" placeholder="08xxxxxxxxxx"></label>
<label class="full">Alamat usaha<textarea name="alamat" rows="3" placeholder="Alamat dan kota usaha"></textarea></label>
<button class="button" type="submit">Kirim Pendaftaran →</button>
</form><p class="auth-foot">Sudah punya akun seller? <a href="<?= $this->url->get('login-seller') ?>">Login di sini</a></p></section></main>

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
