(function () {
  var root = document.getElementById('peta-app');
  if (!root) return;
  var U = window.RasaMap, mapEl = document.getElementById('map');
  if (!window.L) { mapEl.innerHTML = '<p style="padding:20px">Peta gagal dimuat. Periksa koneksi internet.</p>'; return; }

  var items = [];
  try { items = JSON.parse(root.getAttribute('data-items') || '[]'); } catch (e) {}
  var base = root.getAttribute('data-base') || '/';
  var qEl = document.getElementById('peta-q');
  var radiusEl = document.getElementById('peta-radius');
  var katEl = document.getElementById('peta-kat');
  var typeEl = document.getElementById('peta-type');
  var listEl = document.getElementById('peta-list');
  var countEl = document.getElementById('peta-count');
  var statusEl = document.getElementById('peta-status');
  var locateBtn = document.getElementById('peta-locate');

  var map = U.createMap(mapEl), layer = L.layerGroup().addTo(map);
  var markers = {}, origin = null, originMarker = null, circle = null, activeId = null;

  function validPoint(p) {
    return p.lat != null && p.lng != null &&
      isFinite(Number(p.lat)) && isFinite(Number(p.lng)) &&
      Number(p.lat) >= -90 && Number(p.lat) <= 90 &&
      Number(p.lng) >= -180 && Number(p.lng) <= 180 &&
      !(Number(p.lat) === 0 && Number(p.lng) === 0);
  }
  function setStatus(s) { statusEl.textContent = s || ''; }
  function setOrigin(lat, lng) {
    origin = { lat: lat, lng: lng };
    if (originMarker) originMarker.setLatLng(origin);
    else originMarker = L.marker(origin, { icon: U.youIcon(), zIndexOffset: 1000, interactive: false }).addTo(map);
  }

  function current() {
    var q = qEl.value.trim().toLowerCase();
    var kat = katEl.value, type = typeEl ? typeEl.value : '';
    var radius = parseFloat(radiusEl.value) || 0;
    return items.filter(function (p) {
      if (!validPoint(p)) return false;
      if (type && p.jenis_titik !== type) return false;
      if (kat && p.kategori !== kat) return false;
      var haystack = [p.tempat, p.kuliner, p.kota, p.alamat, p.daerah, p.kategori].join(' ').toLowerCase();
      return !q || haystack.indexOf(q) !== -1;
    }).map(function (p) {
      var copy = {};
      for (var key in p) copy[key] = p[key];
      copy.dist = origin ? U.km(origin, p) : null;
      return copy;
    }).filter(function (p) {
      return !(origin && radius > 0 && p.dist > radius);
    }).sort(function (a, b) {
      return origin ? a.dist - b.dist : String(a.kuliner).localeCompare(String(b.kuliner));
    });
  }

  function fitView(list) {
    var points = list.map(function (p) { return [p.lat, p.lng]; });
    if (origin) points.push([origin.lat, origin.lng]);
    if (!points.length) return;
    if (points.length === 1) map.setView(points[0], 15);
    else map.fitBounds(L.latLngBounds(points), { padding: [50, 50], maxZoom: 15 });
  }

  function render(fit) {
    var list = current(), radius = parseFloat(radiusEl.value) || 0;
    layer.clearLayers(); markers = {};
    if (circle) { map.removeLayer(circle); circle = null; }
    if (origin && radius > 0) {
      circle = L.circle(origin, { radius: radius * 1000, color: '#94501d', weight: 1.5, fillColor: '#94501d', fillOpacity: .06, interactive: false }).addTo(map);
    }

    list.forEach(function (p) {
      var marker;
      if (p.jenis_titik === 'lokasi') {
        marker = L.marker([p.lat, p.lng], { icon: U.pin(false) });
      } else {
        marker = L.circleMarker([p.lat, p.lng], { radius: 7, color: '#fff', weight: 2, fillColor: '#d97706', fillOpacity: 1 });
      }
      marker.bindPopup(U.popup(p, base, p.dist));
      marker.on('click', function () { highlight(p.id, false); });
      marker.addTo(layer);
      markers[p.id] = marker;
    });

    countEl.textContent = list.length + ' titik lokasi';
    statusEl.textContent = origin ? (radius ? 'dalam radius ' + radius + ' km' : 'semua jarak dari lokasi Anda') : 'kuliner & tempat usaha';
    if (!list.length) {
      listEl.innerHTML = '<div class="empty-state small"><h3>Belum ada lokasi di area ini</h3><p>Perbesar radius atau pilih semua jarak. Titik tanpa koordinat valid tidak ditampilkan.</p></div>';
    } else {
      listEl.innerHTML = list.map(function (p) {
        var isPlace = p.jenis_titik === 'lokasi';
        var title = isPlace ? p.tempat : p.kuliner;
        var kind = isPlace ? 'Warung / Restoran' : 'Wilayah Asal Kuliner';
        var source = p.sumber_data === 'seller' ? 'Mitra Seller' : 'Database RasaKuliner';
        var address = [p.alamat, p.kota || p.daerah].filter(Boolean).join(', ');
        var detail = base + 'kuliner/detail/' + p.kuliner_id + (isPlace ? '?lokasi=' + p.lokasi_id : '');
        return '<article class="peta-item" data-id="' + U.esc(p.id) + '">' +
          '<img src="' + U.esc(p.gambar) + '" alt="' + U.esc(p.kuliner) + '" loading="lazy">' +
          '<div><small>' + kind + ' · ' + source + '</small>' +
          '<h3>' + U.esc(title) + '</h3>' +
          (isPlace ? '<p>Menu: ' + U.esc(p.kuliner) + '</p>' : '') +
          '<p>⌖ ' + U.esc(address || p.daerah || '') + '</p>' +
          '<a class="peta-google-link" href="' + U.esc(U.gmaps(p)) + '" target="_blank" rel="noopener">Lihat di Google Maps ↗</a></div>' +
          '<div class="side">' + (p.dist != null ? '<b>' + U.fmtKm(p.dist) + '</b>' : '') +
          '<a href="' + U.esc(detail) + '">Detail ↗</a></div></article>';
      }).join('');
    }
    if (fit) fitView(list);
    activeId = null;
  }

  function highlight(id, fly) {
    if (activeId && markers[activeId] && markers[activeId].setStyle) {
      markers[activeId].setStyle({ radius: 7, fillColor: '#d97706' });
    } else if (activeId && markers[activeId] && markers[activeId].setIcon) {
      markers[activeId].setIcon(U.pin(false));
    }
    activeId = id;
    var marker = markers[id];
    if (!marker) return;
    if (marker.setStyle) marker.setStyle({ radius: 10, fillColor: '#174c38' });
    else if (marker.setIcon) marker.setIcon(U.pin(true));
    Array.prototype.forEach.call(listEl.querySelectorAll('.peta-item'), function (card) {
      var selected = card.getAttribute('data-id') === String(id);
      card.classList.toggle('is-active', selected);
      if (selected && !fly) card.scrollIntoView({ block: 'nearest', behavior: 'smooth' });
    });
    if (fly) { map.flyTo(marker.getLatLng(), Math.max(map.getZoom(), 15), { duration: .6 }); marker.openPopup(); }
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
    if (!navigator.geolocation) { setStatus('Browser tidak mendukung lokasi.'); return; }
    setStatus('Mencari lokasi Anda…');
    navigator.geolocation.getCurrentPosition(function (pos) {
      setOrigin(pos.coords.latitude, pos.coords.longitude);
      autoRadius(); render(true);
    }, function () {
      setStatus('Izin lokasi tidak diberikan. Klik peta untuk menentukan titik.');
      render(true);
    }, { enableHighAccuracy: true, timeout: 10000, maximumAge: 60000 });
  }

  listEl.addEventListener('click', function (event) {
    if (event.target.closest('a')) return;
    var card = event.target.closest('.peta-item');
    if (card) highlight(card.getAttribute('data-id'), true);
  });
  map.on('click', function (event) {
    setOrigin(event.latlng.lat, event.latlng.lng);
    if (radiusEl.value === '0') radiusEl.value = '25';
    render(false);
  });
  var timer;
  qEl.addEventListener('input', function () { clearTimeout(timer); timer = setTimeout(function () { render(true); }, 200); });
  radiusEl.addEventListener('change', function () { render(true); });
  katEl.addEventListener('change', function () { render(true); });
  if (typeEl) typeEl.addEventListener('change', function () { render(true); });
  locateBtn.addEventListener('click', locate);

  render(true);
  locate();
  setTimeout(function () { map.invalidateSize(); }, 200);
})();
