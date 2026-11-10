{% extends 'layouts/main.volt' %}
{% block content %}
<main class="article-page">
  <section class="article-hero">
    <div class="container article-hero-inner">
      <span class="eyebrow light">Jurnal rasa Nusantara</span>
      <h1>Cerita yang hidup<br>di setiap hidangan.</h1>
      <p>Kenali asal-usul makanan, tradisi keluarga, bahan lokal, dan kisah di balik kekayaan kuliner Indonesia.</p>
      <form class="article-search" action="{{ url('cerita') }}" method="get">
        <input type="search" name="q" value="{{ search|e }}" placeholder="Cari rendang, tradisi, daerah..." aria-label="Cari artikel">
        <button type="submit">Cari Artikel</button>
      </form>
    </div>
  </section>
  <section class="section container article-list-section">
    <div class="section-head">
      <div><span class="eyebrow">Dari dapur ke cerita</span><h2>Jelajahi artikel kuliner</h2><p class="article-result-count">{{ articles|length }} cerita ditemukan</p></div>
    </div>
    <div class="article-filters">
      <a class="{{ selectedCategory == '' ? 'selected' : '' }}" href="{{ url('cerita') }}">Semua cerita</a>
      {% for item in categories %}
        <a class="{{ selectedCategory == item.kategori ? 'selected' : '' }}" href="{{ url('cerita?kategori=' ~ item.kategori|url_encode) }}">{{ item.kategori }}</a>
      {% endfor %}
    </div>
    {% if articles|length > 0 %}
    <div class="article-grid">
      {% for item in articles %}
      <article class="article-card">
        <a class="article-card-image" href="{{ url('cerita/' ~ item.slug) }}"><img src="{{ url(item.gambar) }}" alt="{{ item.judul|e }}" loading="lazy">{% if item.unggulan %}<span>Pilihan redaksi</span>{% endif %}</a>
        <div class="article-card-body">
          <div class="article-meta"><span>{{ item.kategori|e }}</span><span>{{ item.daerah|e }}</span></div>
          <h2><a href="{{ url('cerita/' ~ item.slug) }}">{{ item.judul|e }}</a></h2>
          <p>{{ item.ringkasan|e }}</p>
          <div class="article-card-foot"><small>{{ item.tanggal }} · {{ item.views }} dibaca</small><a href="{{ url('cerita/' ~ item.slug) }}">Baca cerita ↗</a></div>
        </div>
      </article>
      {% endfor %}
    </div>
    {% else %}
      <div class="article-empty"><h2>Belum ada cerita yang cocok</h2><p>Coba kata kunci atau kategori lain untuk menemukan cerita kuliner.</p><a class="button" href="{{ url('cerita') }}">Lihat semua artikel</a></div>
    {% endif %}
  </section>
  <section class="container article-invite">
    <div><span class="eyebrow">Warisan rasa milik bersama</span><h2>Punya cerita dari dapur keluarga?</h2><p>Setiap resep punya perjalanan. Bagikan kisah kuliner daerahmu dan bantu menjaga cerita Nusantara tetap hidup.</p></div>
    <a class="button" href="{{ url('kuliner') }}">Jelajahi kuliner ↗</a>
  </section>
</main>
{% endblock %}
