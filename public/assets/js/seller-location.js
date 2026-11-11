document.addEventListener('DOMContentLoaded', function () {
  var el = document.getElementById('seller-location-map');
  if (!el) return;
  var status = document.getElementById('seller-map-status');
  var address = document.getElementById('seller-address');
  var latInput = document.getElementById('seller-latitude');
  var lngInput = document.getElementById('seller-longitude');
  var searchBtn = document.getElementById('seller-map-search');
  var currentBtn = document.getElementById('seller-map-current');
  if (!window.L) { status.textContent = 'Peta gagal dimuat. Periksa koneksi internet atau file Leaflet.'; return; }

  var lat = parseFloat(el.getAttribute('data-lat'));
  var lng = parseFloat(el.getAttribute('data-lng'));
  var hasPoint = isFinite(lat) && isFinite(lng);
  var map = L.map(el).setView(hasPoint ? [lat, lng] : [-2.5, 118], hasPoint ? 15 : 5);
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19,
    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright" target="_blank">OpenStreetMap</a>'
  }).addTo(map);
  var marker = null;

  function setPoint(lat, lng, doReverse) {
    lat = Number(lat); lng = Number(lng);
    if (!isFinite(lat) || !isFinite(lng)) return;
    latInput.value = lat.toFixed(7); lngInput.value = lng.toFixed(7);
    if (!marker) {
      marker = L.marker([lat, lng], { draggable: true }).addTo(map);
      marker.on('dragend', function () {
        var p = marker.getLatLng(); setPoint(p.lat, p.lng, true);
      });
    } else marker.setLatLng([lat, lng]);
    status.textContent = 'Titik dipilih: ' + lat.toFixed(5) + ', ' + lng.toFixed(5);
    if (doReverse) {
      fetch('https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=' + encodeURIComponent(lat) + '&lon=' + encodeURIComponent(lng), { headers: { 'Accept-Language': 'id' } })
        .then(function (r) { return r.json(); })
        .then(function (data) {
          if (data && data.display_name && address) address.value = data.display_name;
        }).catch(function () {});
    }
  }
  if (hasPoint) {
    setPoint(lat, lng, false);
    status.textContent = 'Lokasi tersimpan. Klik peta atau geser pin untuk mengubahnya.';
  }
  map.on('click', function (e) { setPoint(e.latlng.lat, e.latlng.lng, true); });
  function searchAddress() {
    var q = address.value.trim();
    if (!q) { status.textContent = 'Isi alamat terlebih dahulu untuk mencari.'; return; }
    status.textContent = 'Mencari alamat...';
    fetch('https://nominatim.openstreetmap.org/search?format=jsonv2&limit=1&countrycodes=id&q=' + encodeURIComponent(q), { headers: { 'Accept-Language': 'id' } })
      .then(function (r) { return r.json(); })
      .then(function (items) {
        if (!items || !items.length) { status.textContent = 'Alamat tidak ditemukan. Coba nama jalan atau tempat yang lebih lengkap.'; return; }
        var p = items[0], pLat = parseFloat(p.lat), pLng = parseFloat(p.lon);
        map.setView([pLat, pLng], 16); setPoint(pLat, pLng, false);
        if (p.display_name) address.value = p.display_name;
        status.textContent = 'Alamat ditemukan. Periksa posisi pin sebelum menyimpan.';
      }).catch(function () { status.textContent = 'Pencarian gagal. Periksa koneksi internet lalu coba lagi.'; });
  }
  searchBtn.addEventListener('click', searchAddress);
  address.addEventListener('keydown', function (e) { if (e.key === 'Enter') { e.preventDefault(); searchAddress(); } });
  currentBtn.addEventListener('click', function () {
    if (!navigator.geolocation) { status.textContent = 'Browser tidak mendukung lokasi perangkat.'; return; }
    status.textContent = 'Meminta izin lokasi perangkat...';
    navigator.geolocation.getCurrentPosition(function (pos) {
      var pLat = pos.coords.latitude, pLng = pos.coords.longitude;
      map.setView([pLat, pLng], 16); setPoint(pLat, pLng, true);
    }, function () { status.textContent = 'Lokasi tidak tersedia atau izin lokasi ditolak.'; }, { enableHighAccuracy: true, timeout: 12000 });
  });
  setTimeout(function () { map.invalidateSize(); }, 250);
});
