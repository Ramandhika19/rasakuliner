<!doctype html>
<html lang="id">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{{ title|default('RasaNusantara') }}</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Bricolage+Grotesque:opsz,wght@12..96,600..800&family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="{{ url('assets/css/style.css') }}?v={{ assetVer }}" rel="stylesheet">
</head>
<body>
<header class="site-header">
  <a class="brand" href="{{ url('') }}"><span class="brand-mark">✿</span><span>RasaNusantara</span></a>
  <nav class="main-nav">
    <a href="{{ url('') }}" class="{{ active is defined and active == 'home' ? 'active' : '' }}">Beranda</a>
    <a href="{{ url('kuliner') }}" class="{{ active is defined and active == 'kuliner' ? 'active' : '' }}">Jelajahi Kuliner</a>
    <a href="{{ url('peta') }}" class="{{ active is defined and active == 'peta' ? 'active' : '' }}">Peta Kuliner</a>
    <a href="{{ url('#cerita') }}">Cerita & Blog</a>
    <a href="{{ url('kuliner#kontribusi') }}">Kontribusi</a>
  </nav>
  <a class="login-link" href="{{ url('kuliner') }}">Jelajahi Sekarang <span>↗</span></a>
  <button class="menu-toggle" aria-label="Buka menu">☰</button>
</header>
{% block content %}{% endblock %}
<footer class="footer">
  <div class="footer-grid">
    <div><a class="brand brand-light" href="{{ url('') }}"><span class="brand-mark">✿</span>RasaNusantara</a><p>Ruang untuk mengenal, merawat, dan meneruskan kekayaan rasa Nusantara. Satu hidangan, banyak cerita.</p></div>
    <div><b>Jelajahi</b><a href="{{ url('kuliner') }}">Jelajahi Kuliner</a><a href="{{ url('peta') }}">Peta Kuliner</a><a href="{{ url('') }}">Koleksi Pilihan</a></div>
    <div><b>Ruang cerita</b><a href="{{ url('#cerita') }}">Cerita & Blog</a><a href="#">Tentang Kami</a><a href="#">Kontribusi</a></div>
    <div><b>Tetap terhubung</b><a href="#">Instagram</a><a href="#">Hubungi Kami</a><a href="#">Panduan Kontribusi</a></div>
  </div>
  <div class="copyright"><span>© 2026 RasaNusantara. Merawat rasa, menjaga cerita.</span><span>Kebijakan Privasi　·　Syarat Penggunaan</span></div>
</footer>
<script src="{{ url('assets/js/app.js') }}?v={{ assetVer }}"></script>
</body>
</html>
