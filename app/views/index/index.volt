{% extends 'layouts/main.volt' %}
{% block content %}
<main>
<section class="hero">
  <div class="hero-shade"></div>
  <div class="hero-content">
    <span class="eyebrow light">Arsip rasa & cerita Indonesia</span>
    <h1>Sistem Informasi Kuliner<br>Tradisional Indonesia</h1>
    <p>Dari dapur keluarga hingga warisan lintas generasi. Temukan hidangan, kenali asal-usulnya, dan selami cerita di balik setiap rasa.</p>
    <form class="hero-search" action="{{ url('kuliner') }}" method="get"><span>⌕</span><input name="q" placeholder="Cari kuliner, bahan, atau daerah asal..." /><button>Cari Rasa</button></form>
    <div class="quick-tags"><span>Coba kata kunci:</span><a href="{{ url('kuliner?q=Rendang') }}">Rendang</a><a href="{{ url('kuliner?q=Gudeg') }}">Gudeg</a><a href="{{ url('kuliner?q=Ayam') }}">Ayam Betutu</a><a href="{{ url('kuliner?q=Papeda') }}">Papeda</a></div>
  </div>
</section>
<section class="section container">
  <div class="section-head"><div><span class="eyebrow">Pilihan untuk penjelajah rasa</span><h2>Kenali rasa, temukan ceritanya</h2></div><a class="text-link" href="{{ url('kuliner') }}">Jelajahi semua kuliner ↗</a></div>
  <div class="food-grid four">
  {% for item in featured %}
    <a class="food-card" data-gallery="{{ item.gambar_gallery|e }}" href="{{ url('kuliner/detail/' ~ item.id) }}"><div class="food-image"><img src="{{ item.gambar_url }}" alt="{{ item.nama }}"><span class="save">♧</span></div><div class="food-info"><small>⌖ {{ item.daerah }}</small><h3>{{ item.nama }}</h3><p>{{ item.deskripsi }}</p><span class="tag">{{ item.kategori }}</span></div></a>
  {% endfor %}
  </div>
</section>
<section class="section soft">
 <div class="container">
  <div class="section-head"><div><span class="eyebrow">Koleksi pilihan</span><h2>Ikuti rasa ingin tahu Anda</h2></div></div>
  <div class="feature-strip">
   <a href="{{ url('kuliner') }}"><img src="https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=500&q=85"><span><b>Hangat dalam semangkuk</b><small>Sup, soto, dan sajian kaya rempah</small><em>Lihat koleksi ↗</em></span></a>
   <a href="{{ url('kuliner') }}"><img src="https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=500&q=85"><span><b>Manis dari dapur tradisi</b><small>Jejak manis dari berbagai daerah</small><em>Lihat koleksi ↗</em></span></a>
   <a href="{{ url('kuliner') }}"><img src="https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=500&q=85"><span><b>Dibungkus daun, dirawat waktu</b><small>Aroma khas dalam setiap sajian</small><em>Lihat koleksi ↗</em></span></a>
  </div>
 </div>
</section>
<section class="section container" id="daerah">
 <div class="section-head"><div><span class="eyebrow">Dari barat hingga timur</span><h2>Setiap daerah, berbeda rasa</h2></div><a class="text-link" href="{{ url('peta') }}">Buka peta kuliner ↗</a></div>
 <div class="region-grid">
  <a class="region" style="--region-img:url('https://images.squarespace-cdn.com/content/v1/568297fb1115e07a05646b0d/1533455926976-EKXT0AWFFOP0KK72MPHI/Northern%2BSumatra%2B40%2Bheejennwei%28C%29.JPG')" href="{{ url('kuliner?daerah=Sumatera%20Barat') }}"><b>Sumatra</b><small>Rempah dan tradisi yang kaya</small></a>
  <a class="region" style="--region-img:url('https://cdn.getyourguide.com/image/format%3Dauto%2Cfit%3Dcrop%2Cgravity%3Dauto%2Cquality%3D60%2Cwidth%3D900%2Cheight%3D700%2Cdpr%3D2/tour_img/07bf78a13c07fdff441c3ea0f97b35eb276d3f90f6b581d455496bf9980aef8c.jpg')" href="{{ url('kuliner?daerah=Jawa') }}"><b>Jawa</b><small>Kelezatan di setiap sajian</small></a>
  <a class="region" style="--region-img:url('https://www.i-travel.bg/static/185/images/travel_offer_images/bali-guide.jpg.jpg?h=525&w=900')" href="{{ url('kuliner?daerah=Bali') }}"><b>Bali & Nusa Tenggara</b><small>Tradisi dan bumbu berani</small></a>
  <a class="region" style="--region-img:url('https://cdn-jpr.jawapos.com/images/7/2025/06/09/Raja-Ampat-Papua-3728573667.jpg')" href="{{ url('kuliner?daerah=Maluku%20%26%20Papua') }}"><b>Indonesia Timur</b><small>Segar, unik, dan beragam</small></a>
 </div>
</section>
<section class="section container" id="cerita">
 <div class="section-head"><div><span class="eyebrow">Lebih dari sekadar hidangan</span><h2>Ada cerita di setiap rasa</h2></div><a class="text-link" href="{{ url('cerita') }}">Semua cerita ↗</a></div>
 <div class="story-grid">
 {% for story in stories %}
  <article class="story-card"><a class="story-card-image" href="{{ url('cerita/' ~ story.slug) }}"><img src="{{ url(story.gambar) }}" alt="{{ story.judul|e }}" loading="lazy"></a><small>{{ story.kategori|e }} · {{ story.daerah|e }}</small><h3><a href="{{ url('cerita/' ~ story.slug) }}">{{ story.judul|e }}</a></h3><p>{{ story.ringkasan|e }}</p><a href="{{ url('cerita/' ~ story.slug) }}">Baca cerita ↗</a></article>
 {% endfor %}
 </div>
</section>
<section class="container contribution"><img src="{{ url('img/kuliner/rendang.jpg') }}" alt="Rendang khas Sumatera Barat"><div><span class="eyebrow">Jurnal rasa Nusantara</span><h2>Setiap rasa punya cerita.</h2><p>Temukan kisah di balik makanan khas, resep keluarga, bahan lokal, dan tradisi dari berbagai penjuru Indonesia.</p></div><a class="button" href="{{ url('cerita') }}">Jelajahi Artikel →</a></section>
</main>
{% endblock %}
