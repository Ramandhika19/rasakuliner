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
  <div class="section-head"><div><span class="eyebrow">Cerita pengunjung</span><h2>Ulasan &amp; rating</h2><p class="review-intro">Ulasan yang ditulis pengguna RasaKuliner. Referensi lokasi eksternal dapat dibuka melalui Google Maps.</p></div></div>
  <div class="review-overview">
   <div class="review-score">{% if reviewTotal > 0 %}<strong>{{ reviewAverageDisplay }}</strong><span class="review-stars">★★★★★</span>{% else %}<strong>—</strong><small>Belum ada rating</small>{% endif %}<small>{{ reviewTotal }} ulasan RasaKuliner</small></div>
   <div class="review-overview-copy"><b>Suara para penikmat kuliner</b><p>Rating dihitung dari ulasan yang ditulis langsung oleh pengguna RasaKuliner.</p></div>
  </div>
  <div class="google-review-section">
   <div class="google-review-heading"><div><span class="eyebrow">Referensi eksternal</span><h3>Google Maps</h3><p>Setiap lokasi menyediakan tautan untuk membuka tempat yang sama di Google Maps. Marker dan koordinat peta RasaKuliner tetap menggunakan OpenStreetMap atau titik yang dipilih Mitra.</p></div><span class="google-mark">Google Maps ↗</span></div>
   {% if googleReviewPlaces|length > 0 %}
   <div class="google-review-list">
    {% for place in googleReviewPlaces %}
     <article class="review-card google-place-card">
      <div><strong>{{ place.tempat|e }}</strong><span class="tag">Referensi Google</span></div>
      <small class="review-place-name">{{ place.alamat|e }}{% if place.kota %}, {{ place.kota|e }}{% endif %}</small>
      <a class="outline-button" href="{{ place.google_maps_url|e }}" target="_blank" rel="noopener noreferrer">Lihat tempat &amp; ulasan di Google Maps ↗</a>
     </article>
    {% endfor %}
   </div>
   {% else %}
   <div class="google-review-empty"><b>Belum ada tautan tempat Google Maps untuk kuliner ini.</b><p>Jika lokasi usaha sudah tersedia, tautan Google Maps akan ditampilkan di sini. RasaKuliner tidak menyalin rating atau ulasan Google ke rating komunitas.</p></div>
   {% endif %}
  </div>
  <div class="community-review-heading"><h3>Review komunitas RasaKuliner</h3><span>{{ reviewTotal }} ulasan</span></div>
  {% if reviewError %}<div class="peta-alert">{{ reviewError|e }}</div>{% endif %}
  {% if reviewSuccess %}<div class="review-success">{{ reviewSuccess|e }}</div>{% endif %}
  {% if isUser %}
  <form class="review-form" method="post" action="{{ url('review/' ~ kuliner.id) }}">
   <p class="review-form-hint">Review ini untuk <strong>{{ kuliner.nama|e }}</strong> sebagai makanan/minuman khas, bukan penilaian wajib untuk satu restoran tertentu.</p>
   {% if lokasi|length > 0 %}
   <label>Pernah mencoba di tempat mana? <small>(opsional)</small><select name="lokasi_id"><option value="">Tidak perlu memilih tempat</option>{% for place in lokasi %}{% if place.id > 0 %}<option value="{{ place.id }}">{{ place.tempat|e }} — {{ place.alamat|e }}</option>{% endif %}{% endfor %}</select></label>
   {% endif %}
   <label>Rating<select name="rating" required><option value="">Pilih rating</option><option value="5">★★★★★ - Sangat suka</option><option value="4">★★★★ - Suka</option><option value="3">★★★ - Cukup</option><option value="2">★★ - Kurang</option><option value="1">★ - Tidak suka</option></select></label>
   <label>Ulasan<textarea name="komentar" rows="4" maxlength="1500" required placeholder="Bagaimana rasa, tekstur, aroma, dan pengalamanmu mencoba kuliner ini?"></textarea></label>
   <button class="button" type="submit">Kirim Ulasan</button>
  </form>
  {% elseif isSeller or isAdmin %}<div class="map-login-prompt"><p>Akun Seller dapat membaca semua ulasan. Fitur menulis review tersedia khusus untuk akun User.</p></div>{% else %}<div class="map-login-prompt"><p>Login sebagai User untuk memberikan rating dan review.</p><a class="button" href="{{ url('login-user') }}">Login User</a> <a class="outline-button" href="{{ url('daftar-user') }}">Daftar User</a></div>{% endif %}
  <div class="review-list">{% for review in reviews %}<article class="review-card"><div><strong>{{ review.nama_pengunjung|default('Pengunjung')|e }}</strong><span class="review-stars">{{ review.rating }} ★</span></div><small class="review-place-name">{{ review.nama_tempat|default("Lokasi belum ditentukan")|e }}</small><p>{{ review.komentar|e }}</p><small>{{ review.created_at }}</small></article>{% else %}<p class="muted">Belum ada ulasan. Jadilah yang pertama berbagi pengalaman.</p>{% endfor %}</div>
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
