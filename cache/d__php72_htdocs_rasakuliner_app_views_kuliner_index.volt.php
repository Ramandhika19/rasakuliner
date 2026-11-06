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

<main>
<section class="hero hero-page">
  <div class="hero-content">
    <span class="eyebrow light">Ragam rasa, satu Nusantara</span>
    <h1>Jelajahi warisan<br>kuliner kita</h1>
    <p>Telusuri hidangan dari berbagai penjuru Indonesia. Temukan asal-usul, bahan, dan cerita yang membuat setiap rasa istimewa.</p>
    <form class="hero-search" method="get" action="<?= $this->url->get('kuliner') ?>">
      <span>⌕</span>
      <input name="q" value="<?= $this->escaper->escapeHtml($search) ?>" placeholder="Cari kuliner, bahan, atau daerah asal..." />
      <?php if ($selectedRegion != '') { ?><input type="hidden" name="daerah" value="<?= $this->escaper->escapeHtml($selectedRegion) ?>"><?php } ?>
      <button>Cari Rasa</button>
    </form>
    <div class="quick-tags"><span>Coba kata kunci:</span><a href="<?= $this->url->get('kuliner?q=Rendang') ?>">Rendang</a><a href="<?= $this->url->get('kuliner?q=Soto') ?>">Soto</a><a href="<?= $this->url->get('kuliner?q=Sate') ?>">Sate</a><a href="<?= $this->url->get('kuliner?q=Ikan') ?>">Ikan</a></div>
  </div>
</section>

<section class="container explore-page">
 <div class="region-pills">
  <a class="<?= ($selectedRegion == '' ? 'selected' : '') ?>" href="<?= $this->url->get('kuliner') ?>">Semua</a>
  <?php foreach ($regions as $region) { ?><a class="<?= ($selectedRegion == $region->daerah ? 'selected' : '') ?>" href="<?= $regionLinks[$region->daerah] ?>"><?= $region->daerah ?></a><?php } ?>
 </div>
 <div class="filter-row">
  <b>Saring kuliner</b>
  <span>Menampilkan <?= $this->length($kuliner) ?> dari <?= $total ?> hasil<?php if ($search != '') { ?> untuk “<?= $this->escaper->escapeHtml($search) ?>”<?php } ?></span>
  <?php if ($selectedRegion != '' || $search != '') { ?><a href="<?= $this->url->get('kuliner') ?>">Atur ulang filter</a><?php } ?>
 </div>

 <div class="food-grid three">
 <?php $v24663365701iterated = false; ?><?php foreach ($kuliner as $item) { ?><?php $v24663365701iterated = true; ?>
  <a class="food-card" href="<?= $this->url->get('kuliner/detail/' . $item->id) ?>"><div class="food-image"><img src="<?= $item->gambar ?>" alt="<?= $item->nama ?>" loading="lazy" onerror="this.parentNode.classList.add('no-img');this.remove()"><span class="save">♧</span></div><div class="food-info"><small>⌖ <?= $item->daerah ?></small><h3><?= $item->nama ?></h3><p><?= $item->deskripsi ?></p><span class="tag"><?= $item->kategori ?></span></div></a>
 <?php } if (!$v24663365701iterated) { ?>
  <div class="empty-state"><h3>Kuliner belum ditemukan</h3><p>Coba kata kunci atau daerah yang berbeda.</p><a class="button" href="<?= $this->url->get('kuliner') ?>">Lihat semua kuliner</a></div>
 <?php } ?>
 </div>

 <?php if ($pages > 1) { ?>
 <nav class="pagination" aria-label="Halaman">
  <span>Halaman <?= $page ?> dari <?= $pages ?></span>
  <?php if ($prevUrl != '') { ?><a href="<?= $prevUrl ?>">← Sebelumnya</a><?php } else { ?><a class="disabled">← Sebelumnya</a><?php } ?>
  <?php foreach ($pageLinks as $p) { ?><a class="<?= ($p['current'] ? 'current' : '') ?>" href="<?= $p['url'] ?>"><?= $p['n'] ?></a><?php } ?>
  <?php if ($nextUrl != '') { ?><a href="<?= $nextUrl ?>">Selanjutnya →</a><?php } else { ?><a class="disabled">Selanjutnya →</a><?php } ?>
 </nav>
 <?php } ?>
</section>

<section class="container contribution seller-contribution" id="kontribusi"><img src="https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=500&q=85" alt="" onerror="this.remove()"><div><span class="eyebrow">Jadilah mitra RasaNusantara</span><h2>Punya usaha makanan atau minuman khas daerah?</h2><p>Promosikan kuliner khas usahamu kepada lebih banyak orang. Daftar sebagai seller, lengkapi profil usaha, tambahkan makanan atau minuman yang ingin kamu kenalkan, lalu kirim untuk ditinjau admin. Setelah disetujui, kulinermu akan tampil di website.</p><ul><li>Buat akun seller dan isi informasi usaha.</li><li>Tambahkan foto, nama, daerah asal, kategori, dan cerita kuliner.</li><li>Kelola dan perbarui data kulinermu melalui dashboard.</li><li>Pantau jumlah ulasan serta rating dari pengunjung.</li></ul><div class="contribution-actions"><a class="button" href="<?= $this->url->get('daftar-seller') ?>">Daftar Menjadi Seller →</a><a class="outline-button" href="<?= $this->url->get('login-seller') ?>">Login Seller</a></div></div></section>
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
