(function () {
  var root = document.getElementById('detail-app');
  if (!root) return;
  var U = window.RasaMap, mapEl = document.getElementById('map');
  if (!mapEl || !window.L || !U) return;
  var items = [];
  try { items = JSON.parse(root.getAttribute('data-items') || '[]'); } catch (e) {}
  var btn = document.getElementById('detail-locate'), distanceEl = document.getElementById('detail-distance');
  var map = U.createMap(mapEl), marker = null, originMarker = null;
  function valid(p) {
    return p && p.lat != null && p.lng != null && isFinite(Number(p.lat)) && isFinite(Number(p.lng)) &&
      Math.abs(Number(p.lat)) <= 90 && Math.abs(Number(p.lng)) <= 180 &&
      !(Number(p.lat) === 0 && Number(p.lng) === 0);
  }
  if (!items.length || !valid(items[0])) {
    mapEl.innerHTML = '<div class="empty-state" style="height:100%;min-height:260px;display:flex;flex-direction:column;justify-content:center;align-items:center;text-align:center;padding:24px"><h3>Koordinat belum tersedia</h3><p>Lengkapi latitude dan longitude pada data kuliner ini agar titik peta dapat ditampilkan.</p></div>';
  } else {
    var item = items[0];
    marker = L.marker([Number(item.lat), Number(item.lng)], { icon: U.pin(true) })
      .bindPopup(U.popup(item, root.getAttribute('data-base') || '/', null)).addTo(map);
    map.setView([Number(item.lat), Number(item.lng)], 16);
  }
  if (btn) btn.addEventListener('click', function () {
    if (!navigator.geolocation) { btn.textContent = 'Browser tidak mendukung lokasi'; return; }
    btn.textContent = 'Mencari lokasi…';
    navigator.geolocation.getCurrentPosition(function (pos) {
      var origin = { lat: pos.coords.latitude, lng: pos.coords.longitude };
      if (originMarker) originMarker.setLatLng(origin);
      else originMarker = L.marker(origin, { icon: U.youIcon(), interactive: false }).addTo(map);
      if (marker && distanceEl) {
        var target = marker.getLatLng();
        distanceEl.textContent = 'Jarak dari lokasi kamu: ' + U.fmtKm(U.km(origin, { lat: target.lat, lng: target.lng }));
      }
      btn.textContent = '◎ Jarak diperbarui';
    }, function () { btn.textContent = '◎ Izin lokasi ditolak'; }, { enableHighAccuracy: true, timeout: 10000 });
  });
  setTimeout(function () { map.invalidateSize(); }, 200);
})();