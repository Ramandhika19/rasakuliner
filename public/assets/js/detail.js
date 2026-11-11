(function () {
  var root = document.getElementById('detail-app');
  if (!root) return;
  var U = window.RasaMap;
  var mapEl = document.getElementById('map');
  if (!window.L) { mapEl.innerHTML = '<p style="padding:20px">Peta gagal dimuat. Periksa koneksi internet.</p>'; return; }

  var items = [];
  try { items = JSON.parse(root.getAttribute('data-items') || '[]'); } catch (e) {}
  if (!items.length) {
    mapEl.innerHTML = '<div class="empty-state" style="height:100%;min-height:260px;display:flex;flex-direction:column;justify-content:center;align-items:center;text-align:center;padding:24px"><h3>Pin peta belum tersedia</h3><p>Alamat tetap ditampilkan dari database. Gunakan tautan pencarian peta di samping untuk menemukan alamatnya.</p></div>';
    return;
  }

  var base = root.getAttribute('data-base') || '/';
  var focus = parseInt(root.getAttribute('data-focus'), 10) || 0;
  var listEl = document.getElementById('detail-list');
  var btn = document.getElementById('detail-locate');

  var map = U.createMap(mapEl);
  var markers = {}, origin = null, originMarker = null, activeId = null;
  function hasCoords(p) { return p.lat !== null && p.lng !== null && isFinite(Number(p.lat)) && isFinite(Number(p.lng)) && (Number(p.lat) !== 0 || Number(p.lng) !== 0); }

  items.forEach(function (p) {
    if (!hasCoords(p)) return;
    markers[p.id] = L.marker([p.lat, p.lng], { icon: U.pin(false) }).bindPopup(U.popup(p, base, null)).addTo(map);
    markers[p.id].on('click', function () { select(p.id, false); });
  });

  function renderList() {
    if (!items.length) return;
    var arr = items.slice();
    if (origin) arr.sort(function (a, b) { return a.dist - b.dist; });
    listEl.innerHTML = arr.map(function (p) {
      return '<article class="place-card" data-id="' + p.id + '">' +
        '<div class="place-top"><h3>' + U.esc(p.tempat) + '</h3>' + (p.dist != null ? '<b>' + U.fmtKm(p.dist) + '</b>' : '') + '</div>' +
        '<p>⌖ ' + U.esc([p.alamat, p.kota].filter(Boolean).join(', ')) + '</p>' +
        '<p class="meta">' + [U.stars(p.rating), p.harga, p.jam ? '🕘 ' + p.jam : ''].filter(Boolean).map(U.esc).join(' · ') + '</p>' +
        (p.telepon ? '<p class="meta">☎ ' + U.esc(p.telepon) + '</p>' : '') +
        '<p class="coord">' + (hasCoords(p) ? Number(p.lat).toFixed(5) + ', ' + Number(p.lng).toFixed(5) : 'Koordinat belum tersedia') + '</p>' +
        '<div class="place-links"><a href="' + U.gmaps(p) + '" target="_blank" rel="noopener">' + (hasCoords(p) ? 'Rute Google Maps ↗' : 'Cari di Google Maps ↗') + '</a>' +
        (hasCoords(p) ? '<a href="' + U.osm(p) + '" target="_blank" rel="noopener">OpenStreetMap ↗</a>' : '') + '</div></article>';
    }).join('');
    if (activeId) mark(activeId);
  }

  function mark(id) {
    Array.prototype.forEach.call(listEl.querySelectorAll('.place-card'), function (c) {
      c.classList.toggle('is-active', c.getAttribute('data-id') === String(id));
    });
  }

  function select(id, fly) {
    if (activeId && markers[activeId]) markers[activeId].setIcon(U.pin(false));
    activeId = id;
    var m = markers[id]; if (!m) return;
    m.setIcon(U.pin(true)); mark(id);
    if (fly) { map.flyTo(m.getLatLng(), 16, { duration: .6 }); m.openPopup(); }
  }

  function fit() {
    var pts = items.filter(hasCoords).map(function (p) { return [Number(p.lat), Number(p.lng)]; });
    if (origin) pts.push([origin.lat, origin.lng]);
    if (!pts.length) return;
    if (pts.length === 1) map.setView(pts[0], 16);
    else map.fitBounds(L.latLngBounds(pts), { padding: [50, 50], maxZoom: 16 });
  }

  listEl.addEventListener('click', function (e) {
    if (e.target.closest('a')) return;
    var c = e.target.closest('.place-card'); if (!c) return;
    select(parseInt(c.getAttribute('data-id'), 10), true);
  });

  btn.addEventListener('click', function () {
    if (!navigator.geolocation) { btn.textContent = 'Browser tidak mendukung lokasi'; return; }
    btn.textContent = 'Mencari lokasi…';
    navigator.geolocation.getCurrentPosition(function (pos) {
      origin = { lat: pos.coords.latitude, lng: pos.coords.longitude };
      if (originMarker) originMarker.setLatLng(origin);
      else originMarker = L.marker(origin, { icon: U.youIcon(), interactive: false }).addTo(map);
      items.forEach(function (p) { if (hasCoords(p)) { p.dist = U.km(origin, p); if (markers[p.id]) markers[p.id].setPopupContent(U.popup(p, base, p.dist)); } });
      btn.textContent = '◎ Jarak diperbarui';
      renderList(); fit();
    }, function () { btn.textContent = '◎ Izin lokasi ditolak'; }, { enableHighAccuracy: true, timeout: 10000 });
  });

  renderList(); fit();
  if (focus && markers[focus]) select(focus, true);
  else if (items.length === 1) select(items[0].id, false);
  setTimeout(function () { map.invalidateSize(); }, 200);
})();
