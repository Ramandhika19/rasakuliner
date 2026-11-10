<!doctype html>
<html lang="id">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?= (empty($title) ? ('RasaKuliner') : ($title)) ?></title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Bricolage+Grotesque:opsz,wght@12..96,600..800&family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="<?= $this->url->get('assets/css/style.css') ?>?v=<?= $assetVer ?>" rel="stylesheet">
</head>
<body>
<header class="site-header">
  <a class="brand" href="<?= $this->url->get('') ?>"><span class="brand-mark">✿</span><span>RasaKuliner</span></a>
  <nav class="main-nav">
    <a href="<?= $this->url->get('') ?>" class="<?= (isset($active) && $active == 'home' ? 'active' : '') ?>">Beranda</a>
    <a href="<?= $this->url->get('kuliner') ?>" class="<?= (isset($active) && $active == 'kuliner' ? 'active' : '') ?>">Jelajahi Kuliner</a>
    <a href="<?= $this->url->get('peta') ?>" class="<?= (isset($active) && $active == 'peta' ? 'active' : '') ?>">Peta Kuliner</a>
    <a href="<?= $this->url->get('#cerita') ?>">Cerita & Blog</a>
    <a href="<?= $this->url->get('kuliner#kontribusi') ?>">Kontribusi</a>
  </nav>
  <?php if ($isSeller) { ?>
  <div class="seller-user-menu"><a class="seller-user-trigger" href="<?= $this->url->get('seller') ?>"><?php if ($headerSellerPhoto) { ?><span class="seller-user-avatar"><img src="<?= $this->url->get($headerSellerPhoto) ?>" alt="Foto profil"></span><?php } else { ?><span class="seller-user-avatar"><?= Phalcon\Text::upper($this->slice($headerSellerName, 0, 1)) ?></span><?php } ?><span><?= $this->escaper->escapeHtml($headerSellerName) ?></span><span>⌄</span></a><div class="seller-user-dropdown"><a href="<?= $this->url->get('seller') ?>">Dashboard Seller</a><a href="<?= $this->url->get('seller/profil') ?>">Profil Usaha</a><a href="<?= $this->url->get('seller/tambah') ?>">Tambah Kuliner</a><a href="<?= $this->url->get('logout') ?>">Keluar</a></div></div>
  <?php } elseif ($isAdmin) { ?>
  <a class="login-link" href="<?= $this->url->get('admin/seller') ?>">Panel Admin <span>↗</span></a>
  <a class="login-link" href="<?= $this->url->get('logout') ?>">Keluar</a>
  <?php } else { ?>
  <a class="login-link" href="<?= $this->url->get('login-seller') ?>">Login Seller <span>↗</span></a>
  <?php } ?>
  <button class="menu-toggle" aria-label="Buka menu">☰</button>
</header>

<main class="email-verify-page">
  <section class="email-verify-card">
    <div class="email-verify-top">
      <span class="email-verify-mark">✿</span>
      <span>RASAKULINER <small>MITRA KULINER NUSANTARA</small></span>
    </div>
    <div class="email-verify-body">
      <span class="eyebrow">Ruang verifikasi mitra</span>
      <h1>Konfirmasi pendaftaran Seller</h1>
      <p class="email-verify-lead">Satu langkah untuk menyambut mitra kuliner baru ke dalam keluarga RasaKuliner.</p>
      <?php if (isset($decisionError) && $decisionError) { ?>
        <div class="verify-alert verify-alert-error"><strong>Tautan tidak dapat digunakan</strong><span><?= $this->escaper->escapeHtml($decisionError) ?></span></div>
      <?php } elseif (isset($message) && $message) { ?>
        <div class="verify-success-icon">✓</div>
        <h2 class="verify-success-title">Keputusan berhasil diproses</h2>
        <div class="verify-alert verify-alert-success"><?= $this->escaper->escapeHtml($message) ?></div>
        <a class="button" href="<?= $this->url->get('admin/seller') ?>">Kembali ke panel admin</a>
      <?php } elseif (isset($action) && $action) { ?>
        <div class="verify-status"><span class="verify-dot"></span> MENUNGGU VERIFIKASI</div>
        <div class="verify-profile">
          <div class="verify-profile-label">PROFIL CALON MITRA</div>
          <h2><?= $this->escaper->escapeHtml((empty($action['nama_usaha']) ? ('Nama usaha belum tersedia') : ($action['nama_usaha']))) ?></h2>
          <div class="verify-profile-row"><span>Pemilik</span><strong><?= $this->escaper->escapeHtml((empty($action['nama']) ? ('Tidak tersedia') : ($action['nama']))) ?></strong></div>
          <div class="verify-profile-row"><span>Email</span><strong><?= $this->escaper->escapeHtml((empty($action['email']) ? ('Tidak tersedia') : ($action['email']))) ?></strong></div>
        </div>
        <?php if ($decision == 'approve') { ?>
          <div class="verify-explain"><strong>Jika disetujui</strong><p>Status Seller akan berubah menjadi aktif, role Seller diberikan, dan pendaftar akan menerima email pemberitahuan.</p></div>
        <?php } else { ?>
          <div class="verify-explain verify-explain-warn"><strong>Jika ditolak</strong><p>Status pendaftaran akan menjadi ditolak. Sertakan alasan agar calon mitra mengetahui hal yang perlu diperbaiki.</p></div>
        <?php } ?>
        <?php if (isset($error) && $error) { ?><div class="verify-alert verify-alert-error"><?= $this->escaper->escapeHtml($error) ?></div><?php } ?>
        <form method="post" class="verify-form">
          <?php if ($decision == 'reject') { ?>
            <label>Alasan penolakan<textarea name="rejection_reason" rows="4" required placeholder="Contoh: Informasi alamat usaha belum lengkap..."></textarea></label>
          <?php } ?>
          <button class="verify-submit <?php if ($decision == 'reject') { ?>is-reject<?php } ?>" type="submit"><?php if ($decision == 'approve') { ?>✓ Konfirmasi & aktifkan Seller<?php } else { ?>Tolak pendaftaran Seller<?php } ?></button>
        </form>
        <p class="verify-footnote">Tautan pribadi · Berlaku 48 jam · Hanya dapat digunakan satu kali</p>
      <?php } ?>
    </div>
    <div class="email-verify-footer">RASAKULINER <span>Merawat rasa, menjaga cerita.</span></div>
  </section>
</main>

<footer class="footer">
  <div class="footer-grid">
    <div><a class="brand brand-light" href="<?= $this->url->get('') ?>"><span class="brand-mark">✿</span >RasaKuliner</a><p>Ruang untuk mengenal, merawat, dan meneruskan kekayaan rasa Nusantara. Satu hidangan, banyak cerita.</p></div>
    <div><b>Jelajahi</b><a href="<?= $this->url->get('kuliner') ?>">Jelajahi Kuliner</a><a href="<?= $this->url->get('peta') ?>">Peta Kuliner</a><a href="<?= $this->url->get('') ?>">Koleksi Pilihan</a></div>
    <div><b>Ruang cerita</b><a href="<?= $this->url->get('#cerita') ?>">Cerita & Blog</a><a href="#">Tentang Kami</a><a href="#">Kontribusi</a></div>
    <div><b>Tetap terhubung</b><a href="#">Instagram</a><a href="#">Hubungi Kami</a><a href="#">Panduan Kontribusi</a></div>
  </div>
  <div class="copyright"><span>© 2026 RasaKuliner. Merawat rasa, menjaga cerita.</span><span>Kebijakan Privasi　·　Syarat Penggunaan</span></div>
</footer>
<script src="<?= $this->url->get('assets/js/app.js') ?>?v=<?= $assetVer ?>"></script>
</body>
</html>
