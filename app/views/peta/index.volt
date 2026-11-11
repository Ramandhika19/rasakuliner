{% extends 'layouts/main.volt' %}
{% block content %}
<link rel="stylesheet" href="{{ url('assets/vendor/leaflet/leaflet.css') }}">
<main class="peta-page" id="peta-app" data-items="{{ itemsJson|e }}" data-base="{{ url('') }}">
 <aside class="peta-panel">
  <div class="peta-head">
   <span class="eyebrow">Peta kuliner</span>
   <h1>Temukan rasa terdekat</h1>
   <p>Temukan tempat makan dari database RasaKuliner dan Mitra Seller di seluruh Indonesia. Google Maps tersedia sebagai tautan referensi.</p>
  </div>
  {% if dbError != '' %}<div class="peta-alert">{{ dbError|e }}</div>{% endif %}
  <form class="peta-search" onsubmit="return false">
   <span>⌕</span><input id="peta-q" type="search" placeholder="Cari makanan, tempat, atau kota..." autocomplete="off">
  </form>
  <div class="peta-filters">
   <label>Radius
    <select id="peta-radius">
     <option value="1">1 km</option><option value="3">3 km</option><option value="5">5 km</option>
     <option value="10">10 km</option><option value="25" selected>25 km</option><option value="50">50 km</option>
     <option value="100">100 km</option><option value="0">Semua</option>
    </select>
   </label>
   <label>Jenis
    <select id="peta-kat">
     <option value="">Semua</option>
     {% for k in kategori %}<option value="{{ k|e }}">{{ k|e }}</option>{% endfor %}
    </select>
   </label>
   <label>Sumber data
    <select id="peta-source">
     <option value="">Semua sumber</option>
     <option value="database">Database RasaKuliner</option>
     <option value="seller">Mitra Seller</option>
    </select>
   </label>
   <button type="button" id="peta-locate" class="button">◎ Lokasi saya</button>
  </div>
  <div class="peta-meta"><b id="peta-count">{{ total }} tempat</b><span id="peta-status"></span></div>
  <div class="peta-list" id="peta-list"></div>
 </aside>
 <section class="peta-map-wrap"><div id="map" class="peta-map"></div></section>
</main>
<script src="{{ url('assets/vendor/leaflet/leaflet.js') }}"></script>
<script src="{{ url('assets/js/maputil.js') }}?v={{ assetVer }}"></script>
<script src="{{ url('assets/js/peta.js') }}?v={{ assetVer }}"></script>
{% endblock %}
