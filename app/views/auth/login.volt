{% extends 'layouts/main.volt' %}
{% block content %}
<main class="auth-page"><section class="auth-card auth-narrow"><span class="eyebrow">Ruang Seller</span><h1>Selamat datang kembali.</h1><p class="auth-intro">Login untuk mengelola promosi kuliner dan melihat tanggapan pengunjung.</p>
{% if error %}<div class="form-alert">{{ error|e }}</div>{% endif %}
<form method="post" class="seller-form"><label class="full">Email<input type="email" name="email" required placeholder="Email akun seller"></label><label class="full">Password<input type="password" name="password" required placeholder="Password"></label><button class="button" type="submit">Login sebagai Seller →</button></form>
<p class="auth-foot">Belum menjadi mitra? <a href="{{ url('daftar-seller') }}">Daftar jadi seller</a></p></section></main>
{% endblock %}
