(function () {
  var root = document.getElementById('peta-app');
  if (!root) return;
  var U = window.RasaMap;
  var mapEl = document.getElementById('map');
  if (!window.L) { mapEl.innerHTML = '<p style="padding:20px">Peta gagal dimuat (Leaflet tidak bisa diakses). Periksa koneksi internet.</p>'; return; }

  var items = [];
  try { items = JSON.parse(root.getAttribute('data-items') || '[]'); } catch (e) {}
  var base = root.getAttribute('data-base') || '/';

  var qEl = document.getElementById('peta-q'), radiusEl = document.getElementById('peta-radius'),
      katEl = document.getElementById('peta-kat'), typeEl = document.getElementById('peta-type'), listEl = document.getElementById('peta-list'),
      countEl = document.getElementById('peta-count'), statusEl = document.getElementById('peta-status'),
      locateBtn = document.getElementById('peta-locate');

  var map = U.createMap(mapEl);
  var layer = L.layerGroup().addTo(map);
  var markers = {}, origin = null, originMarker = null, circle = null, activeId = null;

  function validPoint(p) {
    return p.lat != null && p.lng != null &&
      isFinite(Number(p.lat)) && isFinite(Number(p.lng)) &&
      Number(p.lat) >= -90 && Number(p.lat) <= 90 &&
      Number(p.lng) >= -180 && Number(p.lng) <= 180 &&
      !(Number(p.lat) === 0 && Number(p.lng) === 0);
  }
  function setStatus(t) { statusEl.textContent = t || ''; }

  function setOrigin(lat, lng) {
    origin = { lat: lat, lng: lng };
    if (originMarker) originMarker.setLatLng(origin);
    else originMarker = L.marker(origin, { icon: U.youIcon(), zIndexOffset: 1000, interactive: false }).addTo(map);
  }

  function current() {
    var q = qEl.value.trim().toLowerCase(), kat = katEl.value, r = parseFloat(radiusEl.value) || 0;
    var out = items.filter(function (p) {
      // Peta ini khusus tabel kuliner: data seller/lokasi_kuliner tidak ikut.
      if (!validPoint(p)) return false;\n      if (typeEl && typeEl.value && p.jenis_titik !== typeEl.value) return false;
      if (kat && p.kategori !== kat) return false;
      if (q && [p.tempat, p.kuliner, p.kota, p.alamat, p.daerah, p.kategori].join(' ').toLowerCase().indexOf(q) < 0) return false;
      return true;
    }).map(function (p) {
      var c = {}; for (var k in p) c[k] = p[k];
      c.dist = origin ? U.km(origin, p) : null;
      return c;
    }).filter(function (p) {
      // Saat lokasi pengguna dipilih, semua makanan di luar radius disembunyikan.
      return !(origin && r > 0 && p.dist > r);
    });

    out.sort(function (a, b) {
      if (origin) return a.dist - b.dist;
      return String(a.kuliner).localeCompare(String(b.kuliner));
    });
    return out;
  }

  function render(fit) {
    var list = current();
    var r = parseFloat(radiusEl.value) || 0;
    layer.clearLayers(); markers = {};
    if (circle) { map.removeLayer(circle); circle = null; }
    if (origin && r > 0) {
      circle = L.circle(origin, { radius: r * 1000, color: '#94501d', weight: 1.5, fillColor: '#94501d', fillOpacity: .06, interactive: false }).addTo(map);
    }

    list.forEach(function (p) {
      var m = L.marker([p.lat, p.lng], { icon: U.pin(false) }).bindPopup(U.popup(p, base, p.dist));
      m.on('click', function () { highlight(p.id, false); });
      m.addTo(layer); markers[p.id] = m;
    });

    countEl.textContent = list.length + ' titik lokasi';
    setStatus(origin ? (r > 0 ? 'dalam radius ' + r + ' km' : 'semua jarak dari lokasi Anda') : 'kuliner & lokasi usaha · seluruh Indonesia');

    if (!list.length) {
      listEl.innerHTML = '<div class="empty-state small"><h3>Belum ada makanan di area ini</h3><p>Perbesar radius atau pilih semua jarak. Hanya titik dengan koordinat valid dari tabel kuliner dan lokasi_kuliner yang ditampilkan.</p></div>';
    } else {
      listEl.innerHTML = list.map(function (p) {
        return '<article class="peta-item" data-id="' + U.esc(p.id) + '">' +
          '<img src="' + U.esc(p.gambar) + '" alt="' + U.esc(p.kuliner) + '" loading="lazy">' +
          '<div><small>Database RasaKuliner · ' + U.esc(p.kategori) + '</small>' +
          '<h3>' + U.esc(p.kuliner) + '</h3>' +
          '<p>⌖ ' + U.esc([p.alamat, p.daerah].filter(Boolean).join(', ')) + '</p>' +
          '<a class="peta-google-link" href="' + U.esc(U.gmaps(p)) + '" target="_blank" rel="noopener">Lihat lokasi di Google Maps ↗</a></div>' +
          '<div class="side">' + (p.dist != null ? '<b>' + U.fmtKm(p.dist) + '</b>' : '') +
          '<a href="' + base + 'kuliner/detail/' + p.kuliner_id + (p.jenis_titik === 'lokasi' ? '?lokasi=' + p.lokasi_id : '') + '">Detail ↗</a></div></article>';
      }).join('');
    }

    if (fit) fitView(list);
    activeId = null;
  }

  function fitView(list) {
    var pts = list.filter(validPoint).map(function (p) { return [p.lat, p.lng]; });
    if (origin) pts.push([origin.lat, origin.lng]);
    if (!pts.length) return;
    if (pts.length === 1) { map.setView(pts[0], 15); return; }
    map.fitBounds(L.latLngBounds(pts), { padding: [50, 50], maxZoom: 15 });
  }

  function highlight(id, fly) {
    if (activeId && markers[activeId] && markers[activeId].setIcon) markers[activeId].setIcon(U.pin(false));
    activeId = id;
    var m = markers[id]; if (!m) return;
    m.setIcon(U.pin(true));
    var cards = listEl.querySelectorAll('.peta-item');
    Array.prototype.forEach.call(cards, function (c) {
      var on = c.getAttribute('data-id') === String(id);
      c.classList.toggle('is-active', on);
      if (on && !fly) c.scrollIntoView({ block: 'nearest', behavior: 'smooth' });
    });
    if (fly) { map.flyTo(m.getLatLng(), Math.max(map.getZoom(), 15), { duration: .6 }); m.openPopup(); }
  }

  function autoRadius() {
    var steps = ['10', '25', '50', '100', '0'];
    for (var i = 0; i < steps.length; i++) {
      radiusEl.value = steps[i];
      if (current().length) return;
    }
    radiusEl.value = '0';
  }

  function locate() {
    if (!navigator.geolocation) { setStatus('Browser tidak mendukung lokasi. Klik peta untuk menentukan titik.'); return; }
    setStatus('Mencari lokasi Anda…');
    navigator.geolocation.getCurrentPosition(function (pos) {
      setOrigin(pos.coords.latitude, pos.coords.longitude);
      autoRadius(); render(true);
    }, function () {
      setStatus('Izin lokasi ditolak. Klik peta untuk menentukan titik Anda.');
      render(true);
    }, { enableHighAccuracy: true, timeout: 10000, maximumAge: 60000 });
  }

  listEl.addEventListener('click', function (e) {
    if (e.target.closest('a')) return;
    var card = e.target.closest('.peta-item'); if (!card) return;
    highlight(card.getAttribute('data-id'), true);
  });
  map.on('click', function (e) { setOrigin(e.latlng.lat, e.latlng.lng); if (radiusEl.value === '0') radiusEl.value = '25'; render(false); });
  var t; qEl.addEventListener('input', function () { clearTimeout(t); t = setTimeout(function () { render(true); }, 200); });
  radiusEl.addEventListener('change', function () { render(true); });
  katEl.addEventListener('change', function () { render(true); });\n  if (typeEl) typeEl.addEventListener('change', function () { render(true); });
  locateBtn.addEventListener('click', locate);

  render(true);
  locate();
  setTimeout(function () { map.invalidateSize(); }, 200);
})();
