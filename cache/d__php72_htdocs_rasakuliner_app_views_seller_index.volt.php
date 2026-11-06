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

<main class="seller-shell"><aside class="seller-sidebar"><div class="seller-avatar"><?= Phalcon\Text::upper($this->slice($sellerName, 0, 1)) ?></div><b><?= $this->escaper->escapeHtml($sellerProfile->nama_usaha) ?></b><small>Area Seller</small><nav><a class="selected" href="<?= $this->url->get('seller') ?>">▦　Dashboard</a><a href="<?= $this->url->get('seller/tambah') ?>">＋　Tambah Kuliner</a><a href="<?= $this->url->get('seller/profil') ?>">♙　Profil Usaha</a><a href="<?= $this->url->get('logout') ?>">↪　Keluar</a></nav></aside>
<section class="seller-content"><div class="seller-top"><div><span class="eyebrow">Ruang pengelolaan</span><h1>Dashboard Seller</h1><p>Halo, <?= $this->escaper->escapeHtml($sellerName) ?>. Kelola kuliner dan pantau respons pengunjung di sini.</p></div><a class="button" href="<?= $this->url->get('seller/tambah') ?>">＋ Tambah Data</a></div>
<div class="seller-verification <?= $sellerProfile->verification_status ?>"><b>Status akun: <?= ucwords($sellerProfile->verification_status) ?></b><span><?php if ($sellerProfile->verification_status == 'verified') { ?>Profil usaha telah diverifikasi.<?php } elseif ($sellerProfile->verification_status == 'rejected') { ?>Silakan periksa kembali data profil usaha.<?php } else { ?>Profil usaha menunggu verifikasi admin. Data kuliner yang dikirim juga perlu ditinjau sebelum tampil publik.<?php } ?></span></div>
<div class="seller-metrics"><article><small>Total kuliner</small><strong><?= (empty($stats->total) ? (0) : ($stats->total)) ?></strong></article><article><small>Sudah tayang</small><strong><?= (empty($stats->approved) ? (0) : ($stats->approved)) ?></strong></article><article><small>Menunggu review</small><strong><?= (empty($stats->pending) ? (0) : ($stats->pending)) ?></strong></article><article><small>Total ulasan</small><strong><?= (empty($reviewStats->total) ? (0) : ($reviewStats->total)) ?></strong></article></div>
<div class="seller-section-head"><div><h2>Data kuliner saya</h2><p>Data baru akan ditinjau admin sebelum ditampilkan ke pengunjung.</p></div></div>
<div class="seller-table-wrap"><table class="seller-table"><thead><tr><th>Kuliner</th><th>Daerah</th><th>Status</th><th>Ulasan</th><th>Aksi</th></tr></thead><tbody>
<?php $v25755415431iterated = false; ?><?php foreach ($foods as $item) { ?><?php $v25755415431iterated = true; ?><tr><td><b><?= $this->escaper->escapeHtml($item->nama) ?></b><small><?= $this->escaper->escapeHtml($item->kategori) ?></small></td><td><?= $this->escaper->escapeHtml($item->daerah) ?></td><td><span class="status-pill <?= $item->status ?>"><?= ucwords($item->status) ?></span><?php if ($item->rejection_reason) { ?><small><?= $this->escaper->escapeHtml($item->rejection_reason) ?></small><?php } ?></td><td><?= $item->review_count ?><small>★ <?= (empty($item->avg_rating) ? ('—') : ($item->avg_rating)) ?></small></td><td><a href="<?= $this->url->get('seller/edit/' . $item->id) ?>">Edit</a><form method="post" action="<?= $this->url->get('seller/hapus/' . $item->id) ?>" onsubmit="return confirm('Hapus data kuliner ini?')"><button type="submit">Hapus</button></form></td></tr>
<?php } if (!$v25755415431iterated) { ?><tr><td colspan="5" class="seller-empty">Belum ada data kuliner. Mulai dengan menambahkan makanan atau minuman khas usahamu.</td></tr><?php } ?>
</tbody></table></div>
<div class="seller-review-note"><b>Ringkasan ulasan pengunjung</b><span>Rata-rata rating: <strong>★ <?= (empty($reviewStats->average) ? ('—') : ($reviewStats->average)) ?></strong> dari <?= (empty($reviewStats->total) ? (0) : ($reviewStats->total)) ?> ulasan.</span><p>Ulasan dan rating akan muncul di sini setelah pengunjung mengirim review pada halaman kuliner.</p></div>
</section></main>

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
