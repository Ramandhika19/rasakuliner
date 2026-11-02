{% extends 'layouts/main.volt' %}
{% block content %}
<main>
<section class="hero hero-page">
  <div class="hero-content">
    <span class="eyebrow light">Ragam rasa, satu Nusantara</span>
    <h1>Jelajahi warisan<br>kuliner kita</h1>
    <p>Telusuri hidangan dari berbagai penjuru Indonesia. Temukan asal-usul, bahan, dan cerita yang membuat setiap rasa istimewa.</p>
    <form class="hero-search" method="get" action="{{ url('kuliner') }}">
      <span>⌕</span>
      <input name="q" value="{{ search|e }}" placeholder="Cari kuliner, bahan, atau daerah asal..." />
      {% if selectedRegion != '' %}<input type="hidden" name="daerah" value="{{ selectedRegion|e }}">{% endif %}
      <button>Cari Rasa</button>
    </form>
    <div class="quick-tags"><span>Coba kata kunci:</span><a href="{{ url('kuliner?q=Rendang') }}">Rendang</a><a href="{{ url('kuliner?q=Soto') }}">Soto</a><a href="{{ url('kuliner?q=Sate') }}">Sate</a><a href="{{ url('kuliner?q=Ikan') }}">Ikan</a></div>
  </div>
</section>

<section class="container explore-page">
 <div class="region-pills">
  <a class="{{ selectedRegion == '' ? 'selected' : '' }}" href="{{ url('kuliner') }}">Semua</a>
  {% for region in regions %}<a class="{{ selectedRegion == region.daerah ? 'selected' : '' }}" href="{{ regionLinks[region.daerah] }}">{{ region.daerah }}</a>{% endfor %}
 </div>
 <div class="filter-row">
  <b>Saring kuliner</b>
  <span>Menampilkan {{ kuliner|length }} dari {{ total }} hasil{% if search != '' %} untuk “{{ search|e }}”{% endif %}</span>
  {% if selectedRegion != '' or search != '' %}<a href="{{ url('kuliner') }}">Atur ulang filter</a>{% endif %}
 </div>

 <div class="food-grid three">
 {% for item in kuliner %}
  <a class="food-card" href="{{ url('kuliner/detail/' ~ item.id) }}"><div class="food-image"><img src="{{ item.gambar }}" alt="{{ item.nama }}" loading="lazy" onerror="this.parentNode.classList.add('no-img');this.remove()"><span class="save">♧</span></div><div class="food-info"><small>⌖ {{ item.daerah }}</small><h3>{{ item.nama }}</h3><p>{{ item.deskripsi }}</p><span class="tag">{{ item.kategori }}</span></div></a>
 {% else %}
  <div class="empty-state"><h3>Kuliner belum ditemukan</h3><p>Coba kata kunci atau daerah yang berbeda.</p><a class="button" href="{{ url('kuliner') }}">Lihat semua kuliner</a></div>
 {% endfor %}
 </div>

 {% if pages > 1 %}
 <nav class="pagination" aria-label="Halaman">
  <span>Halaman {{ page }} dari {{ pages }}</span>
  {% if prevUrl != '' %}<a href="{{ prevUrl }}">← Sebelumnya</a>{% else %}<a class="disabled">← Sebelumnya</a>{% endif %}
  {% for p in pageLinks %}<a class="{{ p['current'] ? 'current' : '' }}" href="{{ p['url'] }}">{{ p['n'] }}</a>{% endfor %}
  {% if nextUrl != '' %}<a href="{{ nextUrl }}">Selanjutnya →</a>{% else %}<a class="disabled">Selanjutnya →</a>{% endif %}
 </nav>
 {% endif %}
</section>

<section class="container contribution" id="kontribusi"><img src="https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=500&q=85" alt="" onerror="this.remove()"><div><span class="eyebrow">Arsip yang tumbuh bersama</span><h2>Belum menemukan kuliner dari daerah Anda?</h2><p>Mari lengkapi arsip ini bersama lewat cerita dan pengetahuan Anda.</p></div><a class="button" href="mailto:halo@rasanusantara.id">Kontribusikan Kuliner →</a></section>
</main>
{% endblock %}
