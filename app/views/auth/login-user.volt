{% extends 'layouts/main.volt' %}
{% block content %}
<main class="auth-page"><section class="auth-card auth-narrow"><span class="eyebrow">Ruang Pengunjung</span><h1>Selamat datang kembali.</h1><p class="auth-intro">Login untuk menjelajahi peta kuliner dan berbagi ulasan.</p>
{% if error %}<div class="form-alert" role="alert">{{ error|e }}</div>{% endif %}
<form method="post" class="seller-form"><label class="full">Email<input type="email" name="email" required autocomplete="email" placeholder="nama@email.com"></label><label class="full">Password<input type="password" name="password" required autocomplete="current-password" placeholder="Password"></label><button class="button" type="submit">Login User →</button></form>
<p class="auth-foot">Belum punya akun? <a href="{{ url('daftar-user') }}">Daftar sebagai User</a></p></section></main>
{% endblock %}