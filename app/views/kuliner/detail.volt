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
  <div class="section-head"><div><span class="eyebrow">Cerita pengunjung</span><h2>Ulasan &amp; rating</h2><p class="review-intro">Semua rating dan ulasan berasal dari pengalaman pengguna RasaKuliner dan tersimpan di database kami.</p></div></div>
  <div class="review-overview">
   <div class="review-score">{% if reviewTotal > 0 %}<strong>{{ reviewAverageDisplay }}</strong><span class="review-stars">★★★★★</span>{% else %}<strong>—</strong><small>Belum ada rating</small>{% endif %}<small>{{ reviewTotal }} ulasan RasaKuliner</small></div>
   <div class="review-overview-copy"><b>Suara para penikmat kuliner</b><p>Rating dihitung dari ulasan yang ditulis langsung oleh pengguna RasaKuliner.</p></div>
  </div>
  <div class="community-review-heading"><h3>Review komunitas RasaKuliner</h3><span>{{ reviewTotal }} ulasan</span></div>
  {% if reviewError %}<div class="peta-alert">{{ reviewError|e }}</div>{% endif %}
  {% if reviewSuccess %}<div class="review-success">{{ reviewSuccess|e }}</div>{% endif %}
  {% if isUser %}
  <div class="review-composer">
   <div class="review-composer-heading"><span class="eyebrow">Bagikan pengalamanmu</span><h3>Bagaimana rasa kuliner ini?</h3><p>Ceritakan rasa, aroma, tekstur, dan kesan setelah mencobanya. Ulasanmu membantu penikmat kuliner lain.</p></div>
   <form class="review-form" method="post" action="{{ url('review/' ~ kuliner.id) }}">
    {% if lokasi|length > 0 %}
    <label class="review-location-field">Tempat kamu mencobanya <small>Opsional</small><select name="lokasi_id"><option value="">Tidak memilih tempat tertentu</option>{% for place in lokasi %}{% if place.id > 0 %}<option value="{{ place.id }}">{{ place.tempat|e }} — {{ place.alamat|e }}</option>{% endif %}{% endfor %}</select></label>
    {% endif %}
    <fieldset class="review-rating-field"><legend>Berikan rating <span>Wajib</span></legend><div class="rating-choice-list">
     <label class="rating-choice"><input type="radio" name="rating" value="1" required><span class="rating-choice-stars">★</span><span class="rating-choice-copy"><b>Kurang</b><small>1 dari 5</small></span></label>
     <label class="rating-choice"><input type="radio" name="rating" value="2"><span class="rating-choice-stars">★★</span><span class="rating-choice-copy"><b>Biasa saja</b><small>2 dari 5</small></span></label>
     <label class="rating-choice"><input type="radio" name="rating" value="3"><span class="rating-choice-stars">★★★</span><span class="rating-choice-copy"><b>Cukup enak</b><small>3 dari 5</small></span></label>
     <label class="rating-choice"><input type="radio" name="rating" value="4"><span class="rating-choice-stars">★★★★</span><span class="rating-choice-copy"><b>Enak</b><small>4 dari 5</small></span></label>
     <label class="rating-choice"><input type="radio" name="rating" value="5"><span class="rating-choice-stars">★★★★★</span><span class="rating-choice-copy"><b>Istimewa</b><small>5 dari 5</small></span></label>
    </div></fieldset>
    <label class="review-comment-field">Ceritakan pengalamanmu<textarea name="komentar" rows="5" maxlength="1500" required placeholder="Apa yang paling kamu suka dari kuliner ini? Tulis ulasan yang jujur dan bermanfaat..."></textarea><small>Maksimal 1.500 karakter</small></label>
    <div class="review-submit-row"><span>Ulasan akan tampil pada halaman kuliner ini.</span><button class="button" type="submit">Kirim ulasan →</button></div>
   </form>
  </div>
  {% elseif isSeller or isAdmin %}<div class="map-login-prompt"><p>Akun Seller dapat membaca semua ulasan. Fitur menulis review tersedia khusus untuk akun User.</p></div>{% else %}<div class="map-login-prompt"><p>Login sebagai User untuk memberikan rating dan review.</p><a class="button" href="{{ url('login-user') }}">Login User</a> <a class="outline-button" href="{{ url('daftar-user') }}">Daftar User</a></div>{% endif %}
  <div class="review-list">{% for review in reviews %}<article class="review-card"><div><strong>{{ review.nama_pengunjung|default('Pengunjung')|e }}</strong><span class="review-stars">{{ review.rating }} / 5 ★</span></div><small class="review-place-name">{{ review.nama_tempat|default("Lokasi belum ditentukan")|e }}</small><p>{{ review.komentar|e }}</p><small>{{ review.created_at }}</small></article>{% else %}<p class="muted">Belum ada ulasan. Jadilah yang pertama berbagi pengalaman.</p>{% endfor %}</div>
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
