{% extends 'layouts/main.volt' %}
{% block content %}
<main class="auth-page">
<section class="auth-card auth-narrow">
<span class="eyebrow">Verifikasi RasaKuliner</span>
<h1>Konfirmasi pendaftaran Seller</h1>
{% if decisionError %}
<div class="form-alert" role="alert">{{ decisionError|e }}</div>
{% elseif message %}
<div class="form-alert" role="status" style="background:#eaf8ef;color:#176b36;padding:16px;border-radius:10px">{{ message|e }}</div>
{% elseif action %}
<p class="auth-intro">Periksa data pendaftar sebelum mengambil keputusan.</p>
<div style="padding:16px;background:#f5f7f4;border-radius:10px;line-height:1.8">
<strong>Pemilik:</strong> {{ action.nama|e }}<br>
<strong>Email:</strong> {{ action.email|e }}<br>
<strong>Nama usaha:</strong> {{ action.nama_usaha|e }}
</div>
{% if error %}<div class="form-alert" role="alert">{{ error|e }}</div>{% endif %}
<form method="post" class="seller-form" style="margin-top:18px">
{% if decision == 'reject' %}
<label class="full">Alasan penolakan<textarea name="rejection_reason" rows="4" required placeholder="Tuliskan alasan penolakan agar pendaftar tahu apa yang perlu diperbaiki"></textarea></label>
{% else %}
<p>Dengan menekan tombol di bawah, status akun akan berubah menjadi <strong>Seller aktif</strong> dan akses Seller akan diberikan.</p>
{% endif %}
<button class="button" type="submit">{% if decision == 'approve' %}Konfirmasi Terima Seller{% else %}Konfirmasi Tolak Seller{% endif %}</button>
</form>
{% endif %}
</section>
</main>
{% endblock %}
