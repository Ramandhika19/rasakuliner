{% extends 'layouts/main.volt' %}
{% block content %}
<main class="auth-page"><section class="auth-card" style="max-width:1000px;width:100%">
  <span class="eyebrow">Panel Administrator</span>
  <h1>Verifikasi data kuliner Mitra</h1>
  <p class="auth-intro">Periksa nama makanan, identitas usaha, alamat, dan titik koordinat sebelum lokasi ditampilkan di peta seluruh Indonesia.</p>
  <p><a class="outline-button" href="{{ url('admin/seller') }}">← Verifikasi Seller</a></p>
  {% if message %}<div class="form-alert" style="background:#eaf8ef;color:#176b36">{{ message|e }}</div>{% endif %}
  {% if error %}<div class="form-alert">{{ error|e }}</div>{% endif %}
  {% for food in pendingFoods %}
  <article style="border:1px solid #e8e5df;border-radius:14px;padding:20px;margin:18px 0">
    <h2 style="margin:0 0 8px">{{ food.nama|e }}</h2>
    <p><b>Usaha:</b> {{ food.nama_usaha|e }} · <b>Pemilik:</b> {{ food.pemilik|e }} ({{ food.email|e }})</p>
    <p><b>Daerah asal makanan:</b> {{ food.daerah|e }} · <b>Kategori:</b> {{ food.kategori|e }}</p>
    <p><b>Alamat usaha:</b> {{ food.lokasi_alamat|e }}</p>
    <p><b>Koordinat:</b> {{ food.latitude }}, {{ food.longitude }}</p>
    <p><a href="https://www.openstreetmap.org/?mlat={{ food.latitude }}&mlon={{ food.longitude }}#map=17/{{ food.latitude }}/{{ food.longitude }}" target="_blank" rel="noopener">Periksa titik di OpenStreetMap ↗</a></p>
    <div style="display:flex;gap:12px;flex-wrap:wrap;align-items:flex-start">
      <form method="post" action="{{ url('admin/kuliner') }}" onsubmit="return confirm('Setujui kuliner dan tampilkan lokasinya di peta?')">
        <input type="hidden" name="csrf_token" value="{{ csrfToken|e }}"><input type="hidden" name="kuliner_id" value="{{ food.id }}"><input type="hidden" name="decision" value="approve">
        <button class="button" type="submit">Setujui &amp; Tampilkan</button>
      </form>
      <form method="post" action="{{ url('admin/kuliner') }}" style="display:flex;gap:8px;flex-wrap:wrap;align-items:center">
        <input type="hidden" name="csrf_token" value="{{ csrfToken|e }}"><input type="hidden" name="kuliner_id" value="{{ food.id }}"><input type="hidden" name="decision" value="reject">
        <input name="rejection_reason" required placeholder="Alasan penolakan" style="min-width:220px;padding:12px;border:1px solid #ddd;border-radius:8px">
        <button type="submit" style="padding:12px 18px;border:0;border-radius:8px;background:#8d3030;color:white;cursor:pointer">Tolak</button>
      </form>
    </div>
  </article>
  {% else %}
    <p>Belum ada pengajuan kuliner Mitra yang menunggu verifikasi.</p>
  {% endfor %}
  <p class="auth-foot"><a href="{{ url('logout') }}">Keluar dari akun admin</a></p>
</section></main>
{% endblock %}
