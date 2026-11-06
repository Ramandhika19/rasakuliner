{% extends 'layouts/main.volt' %}
{% block content %}
<main class="auth-page"><section class="auth-card"><span class="eyebrow">Bergabung sebagai mitra</span><h1>Kenalkan rasa khas daerahmu.</h1><p class="auth-intro">Daftarkan usaha makanan atau minuman khas daerah. Setelah akun dibuat, kamu bisa mengelola profil usaha, mengirim data kuliner untuk ditampilkan, dan memantau ulasan pengunjung.</p>
{% if error %}<div class="form-alert">{{ error|e }}</div>{% endif %}
<form method="post" class="seller-form">
<label>Nama lengkap<input name="nama" required maxlength="120" placeholder="Nama pemilik usaha"></label>
<label>Email<input type="email" name="email" required placeholder="nama@email.com"></label>
<label>Password<input type="password" name="password" required minlength="8" placeholder="Minimal 8 karakter"></label>
<label>Nama usaha / brand<input name="nama_usaha" required maxlength="160" placeholder="Contoh: Warung Bali Asli"></label>
<label>Jenis usaha<input name="jenis_usaha" placeholder="Makanan, minuman, oleh-oleh..."></label>
<label>Nomor WhatsApp<input name="nomor_telepon" placeholder="08xxxxxxxxxx"></label>
<label class="full">Alamat usaha<textarea name="alamat" rows="3" placeholder="Alamat dan kota usaha"></textarea></label>
<button class="button" type="submit">Daftar sebagai Seller →</button>
</form><p class="auth-foot">Sudah punya akun seller? <a href="{{ url('login-seller') }}">Login di sini</a></p></section></main>
{% endblock %}
