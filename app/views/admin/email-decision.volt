{% extends 'layouts/main.volt' %}
{% block content %}
<main class="email-verify-page">
  <section class="email-verify-card">
    <div class="email-verify-top">
      <span class="email-verify-mark">✿</span>
      <span>RASAKULINER <small>MITRA KULINER NUSANTARA</small></span>
    </div>
    <div class="email-verify-body">
      <span class="eyebrow">Ruang verifikasi mitra</span>
      <h1>Konfirmasi pendaftaran Seller</h1>
      <p class="email-verify-lead">Satu langkah untuk menyambut mitra kuliner baru ke dalam keluarga RasaKuliner.</p>
      {% if decisionError is defined and decisionError %}
        <div class="verify-alert verify-alert-error"><strong>Tautan tidak dapat digunakan</strong><span>{{ decisionError|e }}</span></div>
      {% elseif message is defined and message %}
        <div class="verify-success-icon">✓</div>
        <h2 class="verify-success-title">Keputusan berhasil diproses</h2>
        <div class="verify-alert verify-alert-success">{{ message|e }}</div>
        <a class="button" href="{{ url('admin/seller') }}">Kembali ke panel admin</a>
      {% elseif action is defined and action %}
        <div class="verify-status"><span class="verify-dot"></span> MENUNGGU VERIFIKASI</div>
        <div class="verify-profile">
          <div class="verify-profile-label">PROFIL CALON MITRA</div>
          <h2>{{ action['nama_usaha']|default('Nama usaha belum tersedia')|e }}</h2>
          <div class="verify-profile-row"><span>Pemilik</span><strong>{{ action['nama']|default('Tidak tersedia')|e }}</strong></div>
          <div class="verify-profile-row"><span>Email</span><strong>{{ action['email']|default('Tidak tersedia')|e }}</strong></div>
        </div>
        {% if decision == 'approve' %}
          <div class="verify-explain"><strong>Jika disetujui</strong><p>Status Seller akan berubah menjadi aktif, role Seller diberikan, dan pendaftar akan menerima email pemberitahuan.</p></div>
        {% else %}
          <div class="verify-explain verify-explain-warn"><strong>Jika ditolak</strong><p>Status pendaftaran akan menjadi ditolak. Sertakan alasan agar calon mitra mengetahui hal yang perlu diperbaiki.</p></div>
        {% endif %}
        {% if error is defined and error %}<div class="verify-alert verify-alert-error">{{ error|e }}</div>{% endif %}
        <form method="post" class="verify-form">
          {% if decision == 'reject' %}
            <label>Alasan penolakan<textarea name="rejection_reason" rows="4" required placeholder="Contoh: Informasi alamat usaha belum lengkap..."></textarea></label>
          {% endif %}
          <button class="verify-submit {% if decision == 'reject' %}is-reject{% endif %}" type="submit">{% if decision == 'approve' %}✓ Konfirmasi & aktifkan Seller{% else %}Tolak pendaftaran Seller{% endif %}</button>
        </form>
        <p class="verify-footnote">Tautan pribadi · Berlaku 48 jam · Hanya dapat digunakan satu kali</p>
      {% endif %}
    </div>
    <div class="email-verify-footer">RASAKULINER <span>Merawat rasa, menjaga cerita.</span></div>
  </section>
</main>
{% endblock %}
