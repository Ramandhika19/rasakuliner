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

<main class="article-detail-page">
  <div class="container article-breadcrumb"><a href="<?= $this->url->get('') ?>">Beranda</a><span> / </span><a href="<?= $this->url->get('cerita') ?>">Cerita & Blog</a><span> / </span><span><?= $this->escaper->escapeHtml($article->kategori) ?></span></div>
  <article class="article-detail container">
    <header class="article-detail-header">
      <span class="article-category"><?= $this->escaper->escapeHtml($article->kategori) ?> · <?= $this->escaper->escapeHtml($article->daerah) ?></span>
      <h1><?= $this->escaper->escapeHtml($article->judul) ?></h1>
      <p><?= $this->escaper->escapeHtml($article->ringkasan) ?></p>
      <div class="article-byline"><span>Oleh <strong><?= $this->escaper->escapeHtml($article->penulis) ?></strong></span><span><?= $article->tanggal ?></span><span><?= $article->views ?> kali dibaca</span></div>
    </header>
    <figure class="article-cover"><img src="<?= $this->url->get($article->gambar) ?>" alt="<?= $this->escaper->escapeHtml($article->judul) ?>"><figcaption>Hidangan khas Nusantara · Dokumentasi RasaKuliner</figcaption></figure>
    <div class="article-body"><div class="article-body-copy"><?= nl2br($this->escaper->escapeHtml($article->isi)) ?></div><aside class="article-note"><strong>Jelajahi lebih jauh</strong><p>Kenali hidangan khas dari berbagai daerah dan temukan tempat untuk menikmatinya.</p><a href="<?= $this->url->get('kuliner') ?>">Jelajahi kuliner ↗</a></aside></div>
  </article>
  <?php if ($this->length($related) > 0) { ?>
  <section class="section container related-articles">
    <div class="section-head"><div><span class="eyebrow">Lanjutkan perjalanan rasa</span><h2>Cerita lainnya</h2></div><a class="text-link" href="<?= $this->url->get('cerita') ?>">Semua artikel ↗</a></div>
    <div class="article-grid related-grid">
      <?php foreach ($related as $item) { ?>
      <article class="article-card"><a class="article-card-image" href="<?= $this->url->get('cerita/' . $item->slug) ?>"><img src="<?= $this->url->get($item->gambar) ?>" alt="<?= $this->escaper->escapeHtml($item->judul) ?>" loading="lazy"></a><div class="article-card-body"><div class="article-meta"><span><?= $this->escaper->escapeHtml($item->kategori) ?></span><span><?= $this->escaper->escapeHtml($item->daerah) ?></span></div><h2><a href="<?= $this->url->get('cerita/' . $item->slug) ?>"><?= $this->escaper->escapeHtml($item->judul) ?></a></h2><p><?= $this->escaper->escapeHtml($item->ringkasan) ?></p><div class="article-card-foot"><a href="<?= $this->url->get('cerita/' . $item->slug) ?>">Baca cerita ↗</a></div></div></article>
      <?php } ?>
    </div>
  </section>
  <?php } ?>
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
