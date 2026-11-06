{% extends 'layouts/main.volt' %}
{% block content %}
<link rel="stylesheet" href="{{ url('assets/vendor/leaflet/leaflet.css') }}">
<main class="seller-shell">
<aside class="seller-sidebar">
  <div class="seller-avatar">{% if sellerProfile.foto_profil %}<img src="{{ url(sellerProfile.foto_profil) }}" alt="Foto profil">{% else %}{{ sellerName|slice(0,1)|upper }}{% endif %}</div>
  <b>{{ sellerProfile.nama_usaha|e }}</b><small>Area Seller</small>
  <nav><a href="{{ url('seller') }}">▦　Dashboard</a><a class="selected" href="{{ url('seller/tambah') }}">＋　Tambah Kuliner</a><a href="{{ url('seller/profil') }}">♙　Profil Usaha</a><a href="{{ url('logout') }}">↪　Keluar</a></nav>
</aside>
<section class="seller-content">
  <a class="text-link" href="{{ url('seller') }}">← Kembali ke dashboard</a>
  <div class="seller-top"><div><span class="eyebrow">Katalog usaha</span><h1>{{ isEdit ? 'Edit data kuliner' : 'Tambah kuliner baru' }}</h1><p>Lengkapi informasi makanan khas daerah yang ingin kamu promosikan.</p></div></div>
  {% if error %}<div class="form-alert">{{ error|e }}</div>{% endif %}
  <form method="post" enctype="multipart/form-data" class="seller-form seller-form-card">
    <label>Nama makanan / minuman<input name="nama" required value="{{ food.nama|default('')|e }}" placeholder="Contoh: Ayam Betutu"></label>
    <label>Daerah asal<input name="daerah" required value="{{ food.daerah|default('')|e }}" placeholder="Contoh: Bali"></label>
    <label>Kategori<input name="kategori" required value="{{ food.kategori|default('')|e }}" placeholder="Makanan berat, minuman, camilan..."></label>
    <label class="full">Foto makanan</label>
    <div class="upload-dropzone full" data-dropzone>
      <input type="file" name="gambar[]" accept="image/jpeg,image/png,image/webp" multiple {% if not isEdit %}required{% endif %}>
      <div class="dropzone-prompt"><span class="dropzone-icon">＋</span><b>Tarik 1–3 gambar di sini</b><small>Pilih maksimal 3 foto · JPG, PNG, WEBP · maks. 4 MB per foto</small></div>
      <div class="multi-preview-grid" data-multi-preview></div>
      {% if isEdit %}<small class="current-image-note">Foto saat ini tetap digunakan jika kamu tidak memilih foto baru. Pilih 1–3 foto untuk mengganti seluruh galeri.</small>{% endif %}
    </div>
    <label class="full">Alamat / nama tempat<input id="seller-address" name="lokasi_alamat" value="{{ food.lokasi_alamat|default('')|e }}" placeholder="Cari alamat, nama jalan, atau tempat..."></label>
    <div class="map-picker-wrap full">
      <div class="map-picker-toolbar"><button type="button" class="button button-secondary" id="seller-map-search">Cari alamat</button><button type="button" class="button button-secondary" id="seller-map-current">Gunakan lokasi saya</button><a id="seller-google-maps" class="map-google-link" href="https://www.google.com/maps" target="_blank" rel="noopener">Buka Google Maps ↗</a></div>
      <div id="seller-location-map" class="seller-location-map" data-lat="{{ food.latitude|default('') }}" data-lng="{{ food.longitude|default('') }}"></div>
      <div class="map-coordinates"><span id="seller-map-status">Klik peta untuk menentukan lokasi atau cari alamat di atas.</span><span>OpenStreetMap</span></div>
      <input type="hidden" id="seller-latitude" name="latitude" value="{{ food.latitude|default('') }}">
      <input type="hidden" id="seller-longitude" name="longitude" value="{{ food.longitude|default('') }}">
      <small class="form-hint">Pilih titik lokasi pada peta. Pin bisa digeser untuk memperbaiki posisi. Google Maps dapat dibuka untuk navigasi.</small>
    </div>
    <label class="full">Deskripsi<textarea name="deskripsi" rows="5" required placeholder="Ceritakan keunikan, bahan, dan cita rasa kuliner ini...">{{ food.deskripsi|default('')|e }}</textarea></label>
    <div class="form-hint full">Setelah disimpan, data berstatus <b>Menunggu</b> dan akan ditinjau admin sebelum tampil di website.</div>
    <button class="button" type="submit">Simpan pengajuan →</button>
  </form>
</section>
</main>
<script src="{{ url('assets/vendor/leaflet/leaflet.js') }}"></script>
<script src="{{ url('assets/js/seller-location.js') }}?v={{ assetVer }}"></script>
{% endblock %}
