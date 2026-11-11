{% extends 'layouts/main.volt' %}
{% block content %}
<link rel="stylesheet" href="{{ url('assets/vendor/leaflet/leaflet.css') }}">
<main class="container detail-page" id="detail-app" data-items="{% if isViewer %}{{ lokasiJson|e }}{% else %}[]{% endif %}" data-focus="{{ focus }}" data-base="{{ url('') }}">
 <div class="breadcrumb"><a href="{{ url('') }}">Beranda</a>　›　<a href="{{ url('kuliner') }}">Jelajahi Kuliner</a>　›　<span>{{ kuliner.nama|e }}</span></div>

 <section class="detail-hero">
  <div class="detail-media">
   <div class="detail-photo" data-gallery="{{ kuliner.gambar_gallery|e }}"><img src="{{ kuliner.gambar_url|e }}" alt="{{ kuliner.nama|e }}"></div>
   {% if kuliner.gambar_list|length > 1 %}
   <div class="detail-gallery-thumbs" aria-label="Galeri foto kuliner">
    {% for photo in kuliner.gambar_list %}
     <button type="button" class="detail-gallery-thumb" data-photo-index="{{ loop.index0 }}" aria-label="Lihat foto {{ loop.index }}"><img src="{{ photo|e }}" alt="Foto {{ kuliner.nama|e }}"></button>
    {% endfor %}
   </div>
   {% endif %}
  </div>
  <div class="detail-info">
   <span class="eyebrow">Kuliner khas {{ kuliner.daerah|e }}</span>
   <h1>{{ kuliner.nama|e }}</h1>
   <span class="tag">{{ kuliner.kategori|e }}</span>
   <p>{{ kuliner.deskripsi|e }}</p>
   <div class="detail-facts">
    <div><small>Asal daerah</small><strong>{{ kuliner.daerah|e }}</strong></div>
    <div><small>Kategori</small><strong>{{ kuliner.kategori|e }}</strong></div>
   </div>
   <div class="detail-actions">
    <a class="button" href="#lokasi">Lihat lokasi <span aria-hidden="true">↓</span></a>
    <a class="outline-button" href="{{ url('peta') }}">Jelajahi peta ↗</a>
   </div>
  </div>
 </section>

 <section class="detail-location" id="lokasi">
  <div class="section-head">
   <div><span class="eyebrow">Tempat menikmati</span><h2>Lokasi {{ kuliner.nama|e }}</h2></div>
   {% if isViewer %}<button type="button" id="detail-locate" class="outline-button as-button">◎ Hitung jarak dari lokasi saya</button>{% endif %}
  </div>
  {% if dbError != '' %}<div class="peta-alert">{{ dbError|e }}</div>{% endif %}
  {% if isViewer %}
  <div class="detail-grid">
   <div class="detail-map-wrap"><div id="map" class="detail-map"></div></div>
   <div class="detail-places" id="detail-list">
    {% if lokasi|length == 0 %}
     <div class="empty-state">
      <h3>{% if alamatDatabase != '' %}Alamat dari database{% else %}Lokasi belum tersedia{% endif %}</h3>
      {% if alamatDatabase != '' %}
       <p>{{ alamatDatabase|e }}{% if kuliner.daerah %}, {{ kuliner.daerah|e }}{% endif %}</p>
       <div class="place-links">
        <a href="{{ alamatMapsUrl|e }}" target="_blank" rel="noopener">Cari alamat di Google Maps ↗</a>
        <a href="{{ alamatOsmUrl|e }}" target="_blank" rel="noopener">Cari alamat di OpenStreetMap ↗</a>
       </div>
      {% else %}
       <p>Alamat belum diisi pada data kuliner. Seller dapat memperbarui alamat melalui halaman edit kuliner.</p>
      {% endif %}
     </div>
    {% endif %}
   </div>
  </div>
  <div class="map-credit">Peta © kontributor OpenStreetMap. Titik lokasi berasal dari latitude &amp; longitude di database.</div>
  {% else %}<div class="map-login-prompt"><h3>Masuk untuk membuka peta kuliner</h3><p>Login sebagai User atau Seller untuk melihat peta dan menghitung jarak lokasi kuliner.</p><a class="button" href="{{ url('login-user') }}">Login User</a> <a class="outline-button" href="{{ url('login') }}">Login Seller</a></div>{% endif %}
 </section>


 <section class="detail-reviews" id="ulasan">
  <div class="section-head"><div><span class="eyebrow">Cerita pengunjung</span><h2>Ulasan &amp; rating</h2><p class="review-intro">Pengalaman komunitas RasaKuliner dan referensi ulasan dari Google Maps.</p></div></div>
  <div class="review-overview">
   <div class="review-score">{% if reviewTotal > 0 %}<strong>{{ reviewAverageDisplay }}</strong><span class="review-stars">★★★★★</span>{% else %}<strong>—</strong><small>Belum ada rating</small>{% endif %}<small>{{ reviewTotal }} ulasan RasaKuliner</small></div>
   <div class="review-overview-copy"><b>Suara para penikmat kuliner</b><p>Rating dihitung dari ulasan yang ditulis langsung oleh pengguna RasaKuliner.</p></div>
  </div>
  <div class="google-review-section">
   <div class="google-review-heading"><div><span class="eyebrow">Sumber eksternal</span><h3>Ulasan asli Google Maps</h3><p>Review diambil dari tempat yang cocok dengan nama dan titik lokasi kuliner ini. Data rating dan ulasan berasal langsung dari Google Places.</p></div><span class="google-mark">Google Maps</span></div>
   {% if not googleReviewsEnabled %}
    <div class="google-review-empty"><b>Google Places API belum diaktifkan.</b><p>Tambahkan API key Google Places di konfigurasi lokal agar rating dan review asli bisa dimuat.</p></div>
   {% elseif googleReviewPlaces|length > 0 %}
    <div class="google-review-grid">
    {% for place in googleReviewPlaces %}
     <article class="google-review-card">
      <div class="google-review-place-head"><div><b>{{ place.name|e }}</b><small>{{ place.address|e }}</small></div><span class="review-stars">★ {{ place.rating|default('—') }}</span></div>
      <div class="google-review-count">{{ place.review_count }} rating di Google</div>
      {% if place.reviews|length > 0 %}
       <div class="google-review-list">
       {% for review in place.reviews %}
        <div class="google-review-item">
         <div class="google-review-author"><b>{% if review.author_url %}<a href="{{ review.author_url|e }}" target="_blank" rel="noopener">{{ review.author|e }}</a>{% else %}{{ review.author|e }}{% endif %}</b><span class="review-stars">{{ review.rating }} ★</span></div>
         {% if review.text %}<p>{{ review.text|e }}</p>{% else %}<p class="google-review-no-text">Pengunjung memberikan rating tanpa komentar tertulis.</p>{% endif %}
         {% if review.published %}<small>{{ review.published|e }}</small>{% endif %}
        </div>
       {% endfor %}
       </div>
      {% else %}
       <p class="google-review-no-text">Google belum menyediakan cuplikan ulasan tertulis untuk tempat ini.</p>
      {% endif %}
      <a class="google-review-source" href="{{ place.url|e }}" target="_blank" rel="noopener">Lihat tempat dan semua ulasan di Google Maps ↗</a>
      <small class="google-review-attribution">Ulasan oleh pengguna Google · Sumber: Google Maps</small>
     </article>
    {% endfor %}
    </div>
   {% else %}
    <div class="google-review-empty"><b>Belum ditemukan tempat Google Maps yang cocok.</b><p>Pastikan nama tempat, alamat, dan koordinat di database mengarah ke bisnis yang benar. Kami tidak menampilkan review dari tempat yang belum cocok.</p></div>
   {% endif %}
  </div>
  <div class="community-review-heading"><h3>Review komunitas RasaKuliner</h3><span>{{ reviewTotal }} ulasan</span></div>
  {% if reviewError %}<div class="peta-alert">{{ reviewError|e }}</div>{% endif %}
  {% if reviewSuccess %}<div class="review-success">{{ reviewSuccess|e }}</div>{% endif %}
  {% if isUser %}
  <form class="review-form" method="post" action="{{ url('review/' ~ kuliner.id) }}">
   <label>Rating<select name="rating" required><option value="">Pilih rating</option><option value="5">★★★★★ - Sangat suka</option><option value="4">★★★★ - Suka</option><option value="3">★★★ - Cukup</option><option value="2">★★ - Kurang</option><option value="1">★ - Tidak suka</option></select></label>
   <label>Ulasan<textarea name="komentar" rows="4" maxlength="1500" required placeholder="Bagikan pengalamanmu mencoba kuliner ini..."></textarea></label>
   <button class="button" type="submit">Kirim Review</button>
  </form>
  {% elseif isSeller or isAdmin %}<div class="map-login-prompt"><p>Akun Seller dapat membaca semua ulasan. Fitur menulis review tersedia khusus untuk akun User.</p></div>{% else %}<div class="map-login-prompt"><p>Login sebagai User untuk memberikan rating dan review.</p><a class="button" href="{{ url('login-user') }}">Login User</a> <a class="outline-button" href="{{ url('daftar-user') }}">Daftar User</a></div>{% endif %}
  <div class="review-list">{% for review in reviews %}<article class="review-card"><div><strong>{{ review.nama_pengunjung|default('Pengunjung')|e }}</strong><span class="review-stars">{{ review.rating }} ★</span></div><p>{{ review.komentar|e }}</p><small>{{ review.created_at }}</small></article>{% else %}<p class="muted">Belum ada ulasan. Jadilah yang pertama berbagi pengalaman.</p>{% endfor %}</div>
 </section>

 {% if lainnya|length > 0 %}
 <section class="section">
  <div class="section-head"><div><span class="eyebrow">Jelajahi lagi</span><h2>Kuliner lainnya</h2></div></div>
  <div class="food-grid three">
  {% for item in lainnya %}
   <a class="food-card" href="{{ url('kuliner/detail/' ~ item.id) }}"><div class="food-image"><img src="{{ item.gambar_url|e }}" alt="{{ item.nama|e }}"></div><div class="food-info"><small>⌖ {{ item.daerah|e }}</small><h3>{{ item.nama|e }}</h3><p>{{ item.deskripsi|e }}</p><span class="tag">{{ item.kategori|e }}</span></div></a>
  {% endfor %}
  </div>
 </section>
 {% endif %}
</main>
{% if isViewer %}<script src="{{ url('assets/vendor/leaflet/leaflet.js') }}"></script>
<script src="{{ url('assets/js/maputil.js') }}?v={{ assetVer }}"></script>
<script src="{{ url('assets/js/detail.js') }}?v={{ assetVer }}"></script>{% endif %}
{% endblock %}
