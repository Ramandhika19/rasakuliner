{% extends 'layouts/main.volt' %}
{% block content %}
<main class="article-detail-page">
  <div class="container article-breadcrumb"><a href="{{ url('') }}">Beranda</a><span> / </span><a href="{{ url('cerita') }}">Cerita & Blog</a><span> / </span><span>{{ article.kategori|e }}</span></div>
  <article class="article-detail container">
    <header class="article-detail-header">
      <span class="article-category">{{ article.kategori|e }} · {{ article.daerah|e }}</span>
      <h1>{{ article.judul|e }}</h1>
      <p>{{ article.ringkasan|e }}</p>
      <div class="article-byline"><span>Oleh <strong>{{ article.penulis|e }}</strong></span><span>{{ date('d F Y', strtotime(article.published_at)) }}</span><span>{{ article.views }} kali dibaca</span></div>
    </header>
    <figure class="article-cover"><img src="{{ url(article.gambar) }}" alt="{{ article.judul|e }}"><figcaption>Hidangan khas Nusantara · Dokumentasi RasaKuliner</figcaption></figure>
    <div class="article-body"><div class="article-body-copy">{{ article.isi|e|nl2br }}</div><aside class="article-note"><strong>Jelajahi lebih jauh</strong><p>Kenali hidangan khas dari berbagai daerah dan temukan tempat untuk menikmatinya.</p><a href="{{ url('kuliner') }}">Jelajahi kuliner ↗</a></aside></div>
  </article>
  {% if related|length > 0 %}
  <section class="section container related-articles">
    <div class="section-head"><div><span class="eyebrow">Lanjutkan perjalanan rasa</span><h2>Cerita lainnya</h2></div><a class="text-link" href="{{ url('cerita') }}">Semua artikel ↗</a></div>
    <div class="article-grid related-grid">
      {% for item in related %}
      <article class="article-card"><a class="article-card-image" href="{{ url('cerita/' ~ item.slug) }}"><img src="{{ url(item.gambar) }}" alt="{{ item.judul|e }}" loading="lazy"></a><div class="article-card-body"><div class="article-meta"><span>{{ item.kategori|e }}</span><span>{{ item.daerah|e }}</span></div><h2><a href="{{ url('cerita/' ~ item.slug) }}">{{ item.judul|e }}</a></h2><p>{{ item.ringkasan|e }}</p><div class="article-card-foot"><a href="{{ url('cerita/' ~ item.slug) }}">Baca cerita ↗</a></div></div></article>
      {% endfor %}
    </div>
  </section>
  {% endif %}
</main>
{% endblock %}
