{% extends 'layouts/main.volt' %}
{% block content %}
<main class="container explore-page">
 <div class="breadcrumb">Beranda　›　<span>Jelajahi Kuliner</span></div>
 <section class="explore-intro">
  <div><span class="eyebrow">RAGAM RASA, SATU NUSANTARA</span><h1>Jelajahi warisan kuliner kita</h1><p>Telusuri hidangan dari berbagai penjuru Indonesia. Temukan asal-usul, bahan, dan cerita yang membuat setiap rasa istimewa.</p>
   <form class="hero-search explore-search" method="get" action="{{ url('kuliner') }}"><span>⌕</span><input name="q" value="{{ search }}" placeholder="Cari kuliner, bahan, atau daerah asal..."><button>Cari Rasa</button></form>
  </div>
  <div class="intro-art">❧</div>
 </section>
 <div class="region-pills"><a class="{{ selectedRegion == '' ? 'selected' : '' }}" href="{{ url('kuliner') }}">Semua</a>{% for region in regions %}<a class="{{ selectedRegion == region['daerah'] ? 'selected' : '' }}" href="{{ url('kuliner') }}?daerah={{ region['daerah']|url_encode }}">{{ region['daerah'] }}</a>{% endfor %}</div>
 <div class="filter-row"><b>☷　Saring kuliner</b><span>Menampilkan {{ kuliner|length }} hasil</span><a href="{{ url('kuliner') }}">Atur ulang filter</a></div>
 <div class="food-grid three">
 {% for item in kuliner %}
 <a class="food-card" href="#"><div class="food-image"><img src="{{ item['gambar'] }}" alt="{{ item['nama'] }}"><span class="save">♧</span></div><div class="food-info"><small>⌖ {{ item['daerah'] }}</small><h3>{{ item['nama'] }}</h3><p>{{ item['deskripsi'] }}</p><span class="tag">{{ item['kategori'] }}</span></div></a>
 {% else %}
 <div class="empty-state"><h3>Kuliner belum ditemukan</h3><p>Coba kata kunci atau daerah yang berbeda.</p><a class="button" href="{{ url('kuliner') }}">Lihat semua kuliner</a></div>
 {% endfor %}
 </div>
 <div class="pagination"><span>Halaman 1 dari 1</span><button disabled>Sebelumnya</button><button class="current">1</button><button disabled>Selanjutnya →</button></div>
 <section class="contribution slim" id="kontribusi"><div><b>Belum menemukan kuliner dari daerah Anda?</b><p>Mari lengkapi arsip ini bersama lewat cerita dan pengetahuan Anda.</p></div><a class="outline-button" href="mailto:halo@rasanusantara.id">Kontribusikan Kuliner →</a></section>
</main>
{% endblock %}
