(function () {
  var root = document.getElementById('peta-app');
  if (!root) return;
  var U = window.RasaMap, mapEl = document.getElementById('map');
  if (!window.L || !U) return;
  var items = [];
  try { items = JSON.parse(root.getAttribute('data-items') || '[]'); } catch (e) {}
  var base = root.getAttribute('data-base') || '/', qEl = document.getElementById('peta-q');
  var radiusEl = document.getElementById('peta-radius'), katEl = document.getElementById('peta-kat');
  var listEl = document.getElementById('peta-list'), countEl = document.getElementById('peta-count');
  var statusEl = document.getElementById('peta-status'), locateBtn = document.getElementById('peta-locate');
  var map = U.createMap(mapEl), layer = L.layerGroup().addTo(map);
  var markers = {}, origin = null, originMarker = null, circle = null, activeId = null;
  function validPoint(p) {
    return p.lat != null && p.lng != null && isFinite(Number(p.lat)) && isFinite(Number(p.lng)) &&
      Math.abs(Number(p.lat)) <= 90 && Math.abs(Number(p.lng)) <= 180 &&
      !(Number(p.lat) === 0 && Number(p.lng) === 0);
  }
  function setOrigin(lat,lng) {
    origin={lat:lat,lng:lng};
    if(originMarker)originMarker.setLatLng(origin);
    else originMarker=L.marker(origin,{icon:U.youIcon(),zIndexOffset:1000,interactive:false}).addTo(map);
  }
  function current() {
    var q=qEl.value.trim().toLowerCase(),kat=katEl.value,radius=parseFloat(radiusEl.value)||0;
    return items.filter(function(p){
      if(!validPoint(p)||(kat&&p.kategori!==kat))return false;
      var haystack=[p.tempat,p.kuliner,p.nama_usaha,p.nama_pemilik,p.kota,p.alamat,p.daerah,p.kategori].join(' ').toLowerCase();
      return !q||haystack.indexOf(q)!==-1;
    }).map(function(p){
      var copy={};for(var key in p)copy[key]=p[key];copy.dist=origin?U.km(origin,p):null;return copy;
    }).filter(function(p){return !(origin&&radius>0&&p.dist>radius);})
      .sort(function(a,b){return origin?a.dist-b.dist:String(a.kuliner).localeCompare(String(b.kuliner));});
  }
  function fitView(list){
    var points=list.map(function(p){return [p.lat,p.lng];});
    if(origin)points.push([origin.lat,origin.lng]);
    if(!points.length)return;
    if(points.length===1)map.setView(points[0],15);
    else map.fitBounds(L.latLngBounds(points),{padding:[50,50],maxZoom:15});
  }
  function render(fit){
    var list=current(),radius=parseFloat(radiusEl.value)||0;
    layer.clearLayers();markers={};
    if(circle){map.removeLayer(circle);circle=null;}
    if(origin&&radius>0)circle=L.circle(origin,{radius:radius*1000,color:'#94501d',weight:1.5,fillColor:'#94501d',fillOpacity:.06,interactive:false}).addTo(map);
    list.forEach(function(p){
      var marker=L.marker([Number(p.lat),Number(p.lng)],{icon:U.pin(false)});
      marker.bindPopup(U.popup(p,base,p.dist));marker.on('click',function(){highlight(p.id,false);});
      marker.addTo(layer);markers[p.id]=marker;
    });
    countEl.textContent=list.length+' titik kuliner';
    statusEl.textContent=origin?(radius?'dalam radius '+radius+' km':'semua jarak dari lokasi Anda'):'titik koordinat produk kuliner';
    if(!list.length)listEl.innerHTML='<div class="empty-state small"><h3>Belum ada kuliner di area ini</h3><p>Perbesar radius atau pilih semua jarak. Kuliner tanpa koordinat valid tidak ditampilkan.</p></div>';
    else listEl.innerHTML=list.map(function(p){
      var address=[p.alamat,p.kota||p.daerah].filter(Boolean).join(', ');
      return '<article class="peta-item" data-id="'+U.esc(p.id)+'">'+
        '<img src="'+U.esc(p.gambar)+'" alt="'+U.esc(p.kuliner)+'" loading="lazy">'+
        '<div><small>'+U.esc(p.kategori||'Kuliner')+' · Database RasaKuliner</small><h3>'+U.esc(p.kuliner)+'</h3>'+
        '<p>Usaha: '+U.esc(p.nama_usaha||'Belum diisi')+'</p><p>Pemilik: '+U.esc(p.nama_pemilik||'Belum dicantumkan')+'</p>'+
        '<p>⌖ '+U.esc(address)+'</p>'+(p.telepon?'<p>☎ '+U.esc(p.telepon)+'</p>':'')+
        '<a class="peta-osm-link" href="https://www.openstreetmap.org/?mlat='+p.lat+'&mlon='+p.lng+'#map=16/'+p.lat+'/'+p.lng+'" target="_blank" rel="noopener">Lihat di OpenStreetMap ↗</a></div>'+
        '<div class="side">'+(p.dist!=null?'<b>'+U.fmtKm(p.dist)+'</b>':'')+'<a href="'+U.esc(base+'kuliner/detail/'+p.kuliner_id)+'">Detail ↗</a></div></article>';
    }).join('');
    if(fit)fitView(list);activeId=null;
  }
  function highlight(id,fly){
    if(activeId&&markers[activeId])markers[activeId].setIcon(U.pin(false));
    activeId=id;var marker=markers[id];if(!marker)return;marker.setIcon(U.pin(true));
    Array.prototype.forEach.call(listEl.querySelectorAll('.peta-item'),function(card){
      var selected=card.getAttribute('data-id')===String(id);card.classList.toggle('is-active',selected);
      if(selected&&!fly)card.scrollIntoView({block:'nearest',behavior:'smooth'});
    });
    if(fly){map.flyTo(marker.getLatLng(),Math.max(map.getZoom(),15),{duration:.6});marker.openPopup();}
  }
  function autoRadius(){
    var steps=['10','25','50','100','0'];
    for(var i=0;i<steps.length;i++){radiusEl.value=steps[i];if(current().length)return;}
    radiusEl.value='0';
  }
  function locate(){
    if(!navigator.geolocation){statusEl.textContent='Browser tidak mendukung lokasi.';return;}
    statusEl.textContent='Mencari lokasi Anda…';
    navigator.geolocation.getCurrentPosition(function(pos){
      setOrigin(pos.coords.latitude,pos.coords.longitude);autoRadius();render(true);
    },function(){statusEl.textContent='Izin lokasi tidak diberikan. Klik peta untuk menentukan titik.';render(true);},
    {enableHighAccuracy:true,timeout:10000,maximumAge:60000});
  }
  listEl.addEventListener('click',function(event){
    if(event.target.closest('a'))return;var card=event.target.closest('.peta-item');
    if(card)highlight(card.getAttribute('data-id'),true);
  });
  map.on('click',function(event){
    setOrigin(event.latlng.lat,event.latlng.lng);if(radiusEl.value==='0')radiusEl.value='25';render(false);
  });
  var timer;qEl.addEventListener('input',function(){clearTimeout(timer);timer=setTimeout(function(){render(true);},200);});
  radiusEl.addEventListener('change',function(){render(true);});katEl.addEventListener('change',function(){render(true);});
  locateBtn.addEventListener('click',locate);render(true);locate();
  setTimeout(function(){map.invalidateSize();},200);
})();