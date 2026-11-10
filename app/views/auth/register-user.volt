{% extends 'layouts/main.volt' %}
{% block content %}
<main class="auth-page"><section class="auth-card auth-narrow"><span class="eyebrow">Bergabung dengan RasaKuliner</span><h1>Jelajahi lebih banyak rasa.</h1><p class="auth-intro">Buat akun pengunjung untuk menggunakan peta dan memberikan review kuliner.</p>
{% if error %}<div class="form-alert" role="alert">{{ error|e }}</div>{% endif %}
<form method="post" class="seller-form"><label class="full">Nama lengkap<input name="nama" required maxlength="120" autocomplete="name" placeholder="Nama kamu"></label><label class="full">Email<input type="email" name="email" required autocomplete="email" placeholder="nama@email.com"></label><label class="full">Password<input type="password" name="password" required minlength="8" autocomplete="new-password" placeholder="Minimal 8 karakter"></label><button class="button" type="submit">Buat Akun User →</button></form>
<p class="auth-foot">Sudah punya akun? <a href="{{ url('login-user') }}">Login User</a></p></section></main>
{% endblock %}