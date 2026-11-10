/* Helper bersama untuk halaman peta & detail (Leaflet + OpenStreetMap, gratis tanpa API key) */
window.RasaMap = (function () {
  function esc(s) {
    return String(s == null ? '' : s).replace(/[&<>"']/g, function (c) {
      return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
    });
  }
  function km(a, b) { // jarak haversine (km)
    var R = 6371, r = Math.PI / 180;
    var dLat = (b.lat - a.lat) * r, dLng = (b.lng - a.lng) * r;
    var x = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
            Math.cos(a.lat * r) * Math.cos(b.lat * r) * Math.sin(dLng / 2) * Math.sin(dLng / 2);
    return 2 * R * Math.atan2(Math.sqrt(x), Math.sqrt(1 - x));
  }
  function fmtKm(d) {
    if (d == null) return '';
    return d < 1 ? Math.round(d * 1000) + ' m' : (d < 10 ? d.toFixed(1) : Math.round(d)) + ' km';
  }
  function stars(r) { return r == null ? '' : '★ ' + Number(r).toFixed(1); }
  function gmaps(p) { return 'https://www.google.com/maps/dir/?api=1&destination=' + p.lat + ',' + p.lng; }
  function osm(p) { return 'https://www.openstreetmap.org/?mlat=' + p.lat + '&mlon=' + p.lng + '#map=17/' + p.lat + '/' + p.lng; }
  function createMap(el) {
    var map = L.map(el, { zoomControl: true }).setView([-2.5, 118], 5);
    var tiles = L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
      maxZoom: 19,
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright" target="_blank" rel="noopener">OpenStreetMap</a>'
    });
    var ok = 0, bad = 0, note = null;
    tiles.on('tileload', function () { ok++; if (note && ok > 2) { note.remove(); note = null; } });
    tiles.on('tileerror', function () {
      bad++;
      if (!ok && bad >= 4 && !note) {
        note = document.createElement('div');
        note.className = 'map-note';
        note.innerHTML = '<b>Gambar peta belum bisa dimuat</b><span>Periksa koneksi internet. Jika memakai VPN atau pemblokir iklan, izinkan tile.openstreetmap.org. Titik lokasi tetap tampil.</span>';
        el.appendChild(note);
      }
    });
    tiles.addTo(map);
    return map;
  }
  function pin(active) {
    var logo = window.RASA_LOGO_URL || 'img/rasakuliner-mark.png';
    return L.divIcon({
      className: 'rn-pin' + (active ? ' is-active' : ''),
      html: '<span><img src="' + esc(logo) + '" alt=""></span>',
      iconSize: [42, 42], iconAnchor: [21, 21], popupAnchor: [0, -20]
    });
  }
  function youIcon() {
    return L.divIcon({ className: 'rn-you', html: '<span></span>', iconSize: [20, 20], iconAnchor: [10, 10] });
  }
  function popup(p, base, dist) {
    return '<div class="rn-popup"><small>' + esc(p.kuliner) + '</small><b>' + esc(p.tempat) + '</b>' +
      '<span>' + esc([p.alamat, p.kota].filter(Boolean).join(', ')) + '</span>' +
      '<span>' + [stars(p.rating), dist != null ? fmtKm(dist) : '', p.jam].filter(Boolean).map(esc).join(' · ') + '</span>' +
      '<div><a href="' + base + 'kuliner/detail/' + p.kuliner_id + '?lokasi=' + p.id + '">Lihat detail</a>' +
      '<a href="' + gmaps(p) + '" target="_blank" rel="noopener">Rute ↗</a></div></div>';
  }
  return { esc: esc, km: km, fmtKm: fmtKm, stars: stars, gmaps: gmaps, osm: osm,
           createMap: createMap, pin: pin, youIcon: youIcon, popup: popup };
})();
