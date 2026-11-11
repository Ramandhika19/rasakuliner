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
      katEl = document.getElementById('peta-kat'), sourceEl = document.getElementById('peta-source'), listEl = document.getElementById('peta-list'),
      countEl = document.getElementById('peta-count'), statusEl = document.getElementById('peta-status'),
      locateBtn = document.getElementById('peta-locate');

  var map = U.createMap(mapEl);
  var layer = L.layerGroup().addTo(map);
  var markers = {}, origin = null, originMarker = null, circle = null, activeId = null;

  function setStatus(t) { statusEl.textContent = t || ''; }

  function setOrigin(lat, lng) {
    origin = { lat: lat, lng: lng };
    if (originMarker) originMarker.setLatLng(origin);
    else originMarker = L.marker(origin, { icon: U.youIcon(), zIndexOffset: 1000, interactive: false }).addTo(map);
  }

  function current() {
    var q = qEl.value.trim().toLowerCase(), kat = katEl.value, source = sourceEl ? sourceEl.value : '', r = parseFloat(radiusEl.value) || 0;
    var out = items.map(function (p) {
      var c = {}; for (var k in p) c[k] = p[k];
      c.dist = origin && p.lat != null && p.lng != null && isFinite(Number(p.lat)) && isFinite(Number(p.lng)) ? U.km(origin, p) : null;
      return c;
    }).filter(function (p) {
      if (kat && p.kategori !== kat) return false;
      if (source && (p.sumber_data || 'database') !== source) return false;
      if (q && [p.tempat, p.kuliner, p.kota, p.alamat, p.daerah, p.kategori].join(' ').toLowerCase().indexOf(q) < 0) return false;
      if (origin && r > 0 && p.dist !== null && p.dist > r) return false;
      return true;
    });
    out.sort(function (a, b) {
      if (origin) {
        if (a.dist === null) return 1;
        if (b.dist === null) return -1;
        return a.dist - b.dist;
      }
      return (b.rating || 0) - (a.rating || 0);
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
      if (p.lat == null || p.lng == null || !isFinite(Number(p.lat)) || !isFinite(Number(p.lng))) return;
      var m = L.marker([p.lat, p.lng], { icon: U.pin(false) }).bindPopup(U.popup(p, base, p.dist));
      m.on('click', function () { highlight(p.id, false); });
      m.addTo(layer); markers[p.id] = m;
    });

    countEl.textContent = list.length + ' tempat';
    setStatus(origin ? (r > 0 ? 'dalam radius ' + r + ' km · lokasi tanpa koordinat tetap di daftar' : 'semua jarak') : 'tanpa titik lokasi');

    if (!list.length) {
      listEl.innerHTML = '<div class="empty-state small"><h3>Belum ada tempat</h3><p>Perbesar radius, ubah kata kunci, atau pindahkan titik pencarian di peta.</p></div>';
    } else {
      listEl.innerHTML = list.map(function (p) {
        return '<article class="peta-item" data-id="' + p.id + '">' +
          '<img src="' + U.esc(p.gambar) + '" alt="" loading="lazy">' +
          '<div><small>' + U.esc(p.kuliner) + ' · ' + U.esc(p.kategori) + '</small>' +
          '<span class="source-chip source-' + U.esc(p.sumber_data || 'database') + '">' + ((p.sumber_data || 'database') === 'seller' ? 'Mitra Seller' : 'Database RasaKuliner') + '</span>' +
          '<h3>' + U.esc(p.tempat) + '</h3>' +
          '<p>⌖ ' + U.esc([p.kota, p.daerah].filter(Boolean).join(', ')) + '</p>' +
          '<p class="meta">' + [U.stars(p.rating), p.harga].filter(Boolean).map(U.esc).join(' · ') + '</p>' +
          '<a class="peta-google-link" href="' + U.esc(U.gmaps(p)) + '" target="_blank" rel="noopener">Referensi Google Maps ↗</a></div>' +
          '<div class="side">' + (p.dist != null ? '<b>' + U.fmtKm(p.dist) + '</b>' : '') +
          '<a href="' + base + 'kuliner/detail/' + p.kuliner_id + '?lokasi=' + p.id + '">Detail ↗</a></div></article>';
      }).join('');
    }

    if (fit) fitView(list);
    activeId = null;
  }

  function fitView(list) {
    var pts = list.filter(function (p) { return p.lat != null && p.lng != null && isFinite(Number(p.lat)) && isFinite(Number(p.lng)); }).map(function (p) { return [p.lat, p.lng]; });
    if (origin) pts.push([origin.lat, origin.lng]);
    if (!pts.length) return;
    if (pts.length === 1) { map.setView(pts[0], 15); return; }
    map.fitBounds(L.latLngBounds(pts), { padding: [50, 50], maxZoom: 15 });
  }

  function highlight(id, fly) {
    if (activeId && markers[activeId]) markers[activeId].setIcon(U.pin(false));
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

  // pilih radius terkecil (mulai 10 km) yang punya hasil, agar tidak kosong
  function autoRadius() {
    var steps = ['10', '25', '50', '100', '0'];
    for (var i = 0; i < steps.length; i++) {
      radiusEl.value = steps[i];
      if (current().some(function (p) { return p.dist !== null; })) return;
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
    highlight(parseInt(card.getAttribute('data-id'), 10), true);
  });
  map.on('click', function (e) { setOrigin(e.latlng.lat, e.latlng.lng); if (radiusEl.value === '0') radiusEl.value = '25'; render(false); });
  var t; qEl.addEventListener('input', function () { clearTimeout(t); t = setTimeout(function () { render(true); }, 200); });
  radiusEl.addEventListener('change', function () { render(true); });
  katEl.addEventListener('change', function () { render(true); });
  if (sourceEl) sourceEl.addEventListener('change', function () { render(true); });
  locateBtn.addEventListener('click', locate);

  render(true);
  locate();
  setTimeout(function () { map.invalidateSize(); }, 200);
})();
