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
    <a class="food-card" href="{{ url('kuliner/detail/' ~ item.id) }}"><div class="food-image"><img src="{{ item.gambar }}" alt="{{ item.nama }}"><span class="save">♧</span></div><div class="food-info"><small>⌖ {{ item.daerah }}</small><h3>{{ item.nama }}</h3><p>{{ item.deskripsi }}</p><span class="tag">{{ item.kategori }}</span></div></a>
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
  <a class="region" style="--region-img:url('https://images.unsplash.com/photo-1519681393784-d120267933ba?auto=format&fit=crop&w=700&q=85')" href="{{ url('kuliner?daerah=Sumatera%20Barat') }}"><b>Sumatra</b><small>Rempah dan tradisi yang kaya</small></a>
  <a class="region" style="--region-img:url('https://images.unsplash.com/photo-1518005020951-eccb494ad742?auto=format&fit=crop&w=700&q=85')" href="{{ url('kuliner?daerah=Jawa') }}"><b>Jawa</b><small>Kelezatan di setiap sajian</small></a>
  <a class="region" style="--region-img:url('https://images.unsplash.com/photo-1537996194471-e657df975ab4?auto=format&fit=crop&w=700&q=85')" href="{{ url('kuliner?daerah=Bali') }}"><b>Bali & Nusa Tenggara</b><small>Tradisi dan bumbu berani</small></a>
  <a class="region" style="--region-img:url('https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=700&q=85')" href="{{ url('kuliner?daerah=Maluku%20%26%20Papua') }}"><b>Indonesia Timur</b><small>Segar, unik, dan beragam</small></a>
 </div>
</section>
<section class="section container" id="cerita">
 <div class="section-head"><div><span class="eyebrow">Lebih dari sekadar hidangan</span><h2>Ada cerita di setiap rasa</h2></div><a class="text-link" href="{{ url('kuliner') }}">Semua cerita ↗</a></div>
 <div class="story-grid">
 {% for story in stories %}
  <article class="story-card"><img src="{{ story.gambar }}" alt="{{ story.judul }}"><small>{{ story.kategori }}</small><h3>{{ story.judul }}</h3><p>{{ story.ringkasan }}</p><a href="{{ url('kuliner') }}">Baca cerita ↗</a></article>
 {% endfor %}
 </div>
</section>
<section class="container contribution"><img src="https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=500&q=85"><div><span class="eyebrow">Arsip yang tumbuh bersama</span><h2>Punya cerita dari dapur keluarga?</h2><p>Bantu merawat warisan kuliner kita. Bagikan pengetahuan, foto hidangan, atau cerita tradisi dari daerah Anda.</p></div><a class="button" href="{{ url('kuliner#kontribusi') }}">Bagikan Cerita Anda →</a></section>
</main>
{% endblock %}
