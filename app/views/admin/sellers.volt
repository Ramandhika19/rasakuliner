{% extends 'layouts/main.volt' %}
{% block content %}
<main class="seller-review-page">
  <section class="seller-review-wrap">
    <div class="seller-review-hero">
      <div>
        <span class="eyebrow">Ruang pengelola RasaKuliner</span>
        <h1>Temukan mitra rasa berikutnya.</h1>
        <p>Periksa informasi usaha dengan teliti sebelum membuka akses Seller. Setiap keputusan akan dikirim langsung ke email pendaftar.</p>
      </div>
      <div class="seller-review-stamp"><span>✿</span><b>RASAKULINER</b><small>MERAWAT RASA<br>MENJAGA CERITA</small></div>
    </div>
    {% if message %}<div class="review-flash is-success" role="status"><b>✓ Berhasil</b><span>{{ message|e }}</span></div>{% endif %}
    {% if error %}<div class="review-flash is-error" role="alert"><b>Perlu diperiksa</b><span>{{ error|e }}</span></div>{% endif %}
    <div class="seller-review-heading"><div><span class="review-kicker">ANTRIAN VERIFIKASI</span><h2>Pendaftaran menunggu</h2></div><span class="review-count">{{ pendingSellers|length }} menunggu</span></div>
    {% for seller in pendingSellers %}
    <article class="seller-review-card">
      <div class="seller-review-card-top"><span class="review-pending"><i></i> MENUNGGU TINJAUAN</span><small>{{ seller.created_at|e }}</small></div>
      <div class="seller-review-card-main">
        <div class="seller-review-icon">✿</div>
        <div class="seller-review-identity"><h3>{{ seller.nama_usaha|e }}</h3><p>{{ seller.jenis_usaha|default('Usaha kuliner')|e }}</p></div>
      </div>
      <div class="seller-review-details">
        <div><small>PEMILIK USAHA</small><b>{{ seller.nama|e }}</b></div>
        <div><small>EMAIL PENDAFTAR</small><b>{{ seller.email|e }}</b></div>
        <div><small>NOMOR WHATSAPP</small><b>{{ seller.nomor_telepon|default('Belum diisi')|e }}</b></div>
        <div class="review-address"><small>ALAMAT USAHA</small><b>{{ seller.alamat|default('Belum diisi')|e }}</b></div>
      </div>
      <div class="seller-review-actions">
        <form method="post" action="{{ url('admin/seller') }}" onsubmit="return confirm('Setujui pendaftaran Seller ini?')">
          <input type="hidden" name="csrf_token" value="{{ csrfToken|e }}"><input type="hidden" name="user_id" value="{{ seller.id }}"><input type="hidden" name="decision" value="approve">
          <button class="review-approve" type="submit">✓ Terima Seller</button>
        </form>
        <form method="post" action="{{ url('admin/seller') }}" class="review-reject-form" onsubmit="return confirm('Tolak pendaftaran Seller ini?')">
          <input type="hidden" name="csrf_token" value="{{ csrfToken|e }}"><input type="hidden" name="user_id" value="{{ seller.id }}"><input type="hidden" name="decision" value="reject">
          <input name="rejection_reason" required placeholder="Tulis alasan penolakan...">
          <button class="review-reject" type="submit">Tolak</button>
        </form>
      </div>
    </article>
    {% else %}
    <div class="seller-review-empty"><span>✿</span><h3>Semua sudah tertangani.</h3><p>Belum ada pendaftaran Seller yang menunggu verifikasi. Mitra baru akan muncul di sini setelah mendaftar.</p></div>
    {% endfor %}
    <p class="seller-review-foot"><a href="{{ url('logout') }}">Keluar dari akun admin</a><span>RasaKuliner · Ruang khusus administrator</span></p>
  </section>
</main>
{% endblock %}
