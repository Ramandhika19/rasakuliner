{% extends 'layouts/main.volt' %}
{% block content %}
<main class="auth-page"><section class="auth-card auth-narrow"><span class="eyebrow">Ruang Seller & Admin</span><h1>Selamat datang kembali.</h1><p class="auth-intro">Login untuk mengelola usaha atau memeriksa pendaftaran Seller.</p>
{% if error %}
<div class="form-alert" role="alert" style="background:#fff4df;color:#80520b;border:1px solid #f0d49a;padding:14px 16px;border-radius:10px;margin:16px 0;line-height:1.5">
<strong>Informasi pendaftaran Seller</strong><br>
{{ error|e }}
{% if 'menunggu persetujuan' in error %}
<p style="margin:8px 0 0">Mohon tunggu. Tim admin sedang memeriksa pendaftaranmu. Kamu akan menerima email setelah pendaftaran diterima atau ditolak.</p>
{% endif %}
</div>
{% endif %}
<form method="post" class="seller-form"><label class="full">Email<input type="email" name="email" required placeholder="Email akun"></label><label class="full">Password<input type="password" name="password" required placeholder="Password"></label><button class="button" type="submit">Login →</button></form>
<p class="auth-foot">Belum menjadi mitra? <a href="{{ url('daftar-seller') }}">Daftar jadi seller</a></p></section></main>
{% endblock %}
