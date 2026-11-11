{% extends 'layouts/main.volt' %}
{% block content %}
<main class="auth-page"><section class="auth-card" style="max-width:980px;width:100%">
  <span class="eyebrow">Panel Administrator</span>
  <h1>Verifikasi pendaftaran Seller</h1>
  <p class="auth-intro">Periksa data usaha sebelum memberikan akses Seller. Keputusan akan dikirimkan ke email pendaftar.</p>
  <p><a class="outline-button" href="{{ url('admin/kuliner') }}">Verifikasi pengajuan kuliner Mitra →</a></p>
  {% if message %}<div class="form-alert" style="background:#eaf8ef;color:#176b36">{{ message|e }}</div>{% endif %}
  {% if error %}<div class="form-alert">{{ error|e }}</div>{% endif %}
  {% for seller in pendingSellers %}
  <article style="border:1px solid #e8e5df;border-radius:14px;padding:20px;margin:18px 0">
    <h2 style="margin:0 0 8px">{{ seller.nama_usaha|e }}</h2>
    <p><b>Pemilik:</b> {{ seller.nama|e }} · <b>Email:</b> {{ seller.email|e }}</p>
    <p><b>Jenis usaha:</b> {{ seller.jenis_usaha|default('Belum diisi')|e }} · <b>Telepon:</b> {{ seller.nomor_telepon|default('—')|e }}</p>
    <p><b>Alamat:</b> {{ seller.alamat|default('—')|e }}</p>
    <p><small>Diajukan: {{ seller.created_at|e }}</small></p>
    <div style="display:flex;gap:12px;flex-wrap:wrap;align-items:flex-start">
      <form method="post" action="{{ url('admin/seller') }}" onsubmit="return confirm('Setujui pendaftaran Seller ini?')">
        <input type="hidden" name="csrf_token" value="{{ csrfToken|e }}"><input type="hidden" name="user_id" value="{{ seller.id }}"><input type="hidden" name="decision" value="approve">
        <button class="button" type="submit">Accept / Setujui</button>
      </form>
      <form method="post" action="{{ url('admin/seller') }}" style="display:flex;gap:8px;flex-wrap:wrap;align-items:center">
        <input type="hidden" name="csrf_token" value="{{ csrfToken|e }}"><input type="hidden" name="user_id" value="{{ seller.id }}"><input type="hidden" name="decision" value="reject">
        <input name="rejection_reason" required placeholder="Alasan penolakan" style="min-width:220px;padding:12px;border:1px solid #ddd;border-radius:8px">
        <button type="submit" style="padding:12px 18px;border:0;border-radius:8px;background:#8d3030;color:white;cursor:pointer">Reject / Tolak</button>
      </form>
    </div>
  </article>
  {% else %}
    <p>Belum ada pendaftaran Seller yang menunggu verifikasi.</p>
  {% endfor %}
  <p class="auth-foot"><a href="{{ url('logout') }}">Keluar dari akun admin</a></p>
</section></main>
{% endblock %}
