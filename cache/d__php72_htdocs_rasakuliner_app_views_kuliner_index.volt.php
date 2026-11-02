<!doctype html>
<html lang="id">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?= (empty($title) ? ('RasaNusantara') : ($title)) ?></title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&family=Playfair+Display:wght@500;600;700&display=swap" rel="stylesheet">
    <link href="<?= $this->url->get('assets/css/style.css') ?>" rel="stylesheet">
</head>
<body>
<header class="site-header">
  <a class="brand" href="<?= $this->url->get('') ?>"><span class="brand-mark">✿</span><span>RasaNusantara</span></a>
  <nav class="main-nav">
    <a href="<?= $this->url->get('') ?>" class="<?= ($active == 'home' ? 'active' : '') ?>">Beranda</a>
    <a href="<?= $this->url->get('kuliner') ?>" class="<?= ($active == 'kuliner' ? 'active' : '') ?>">Jelajahi Kuliner</a>
    <a href="<?= $this->url->get('kuliner#daerah') ?>">Peta Kuliner</a>
    <a href="<?= $this->url->get('kuliner#cerita') ?>">Cerita & Blog</a>
    <a href="<?= $this->url->get('kuliner#kontribusi') ?>">Kontribusi</a>
  </nav>
  <a class="login-link" href="<?= $this->url->get('kuliner') ?>">Jelajahi Sekarang <span>↗</span></a>
  <button class="menu-toggle" aria-label="Buka menu">☰</button>
</header>
<?= $this->getContent() ?>
<footer class="footer">
  <div class="footer-grid">
    <div><a class="brand brand-light" href="<?= $this->url->get('') ?>"><span class="brand-mark">✿</span>RasaNusantara</a><p>Ruang untuk mengenal, merawat, dan meneruskan kekayaan rasa Nusantara. Satu hidangan, banyak cerita.</p></div>
    <div><b>Jelajahi</b><a href="<?= $this->url->get('kuliner') ?>">Jelajahi Kuliner</a><a href="<?= $this->url->get('kuliner#daerah') ?>">Peta Kuliner</a><a href="<?= $this->url->get('') ?>">Koleksi Pilihan</a></div>
    <div><b>Ruang cerita</b><a href="<?= $this->url->get('kuliner#cerita') ?>">Cerita & Blog</a><a href="#">Tentang Kami</a><a href="#">Kontribusi</a></div>
    <div><b>Tetap terhubung</b><a href="#">Instagram</a><a href="#">Hubungi Kami</a><a href="#">Panduan Kontribusi</a></div>
  </div>
  <div class="copyright"><span>© 2026 RasaNusantara. Merawat rasa, menjaga cerita.</span><span>Kebijakan Privasi　·　Syarat Penggunaan</span></div>
</footer>
<script src="<?= $this->url->get('assets/js/app.js') ?>"></script>
</body>
</html>
