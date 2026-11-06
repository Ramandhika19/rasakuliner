{% extends 'layouts/main.volt' %}
{% block content %}
<main class="seller-shell">
<aside class="seller-sidebar">
  <div class="seller-avatar">{% if sellerProfile.foto_profil %}<img src="{{ sellerProfile.foto_profil }}" alt="Foto profil">{% else %}{{ sellerName|slice(0,1)|upper }}{% endif %}</div>
  <b>{{ sellerProfile.nama_usaha|e }}</b><small>Area Seller</small>
  <nav><a href="{{ url('seller') }}">▦　Dashboard</a><a href="{{ url('seller/tambah') }}">＋　Tambah Kuliner</a><a class="selected" href="{{ url('seller/profil') }}">♙　Profil Usaha</a><a href="{{ url('logout') }}">↪　Keluar</a></nav>
</aside>
<section class="seller-content">
  <div class="seller-top"><div><span class="eyebrow">Identitas mitra</span><h1>Profil Usaha</h1><p>Perbarui identitas, kontak, alamat, dan foto profil usahamu.</p></div></div>
  {% if error %}<div class="form-alert">{{ error|e }}</div>{% endif %}
  <form method="post" enctype="multipart/form-data" class="seller-form seller-form-card">
    <label class="full">Foto profil usaha</label>
    <div class="upload-dropzone profile-dropzone full" data-dropzone>
      <input type="file" name="foto_profil" accept="image/jpeg,image/png,image/webp">
      <div class="dropzone-prompt"><span class="dropzone-icon">＋</span><b>Tarik foto profil ke sini</b><small>atau klik untuk memilih · JPG, PNG, WEBP · maks. 4 MB</small></div>
      <img class="dropzone-preview" src="{{ sellerProfile.foto_profil|default('') }}" alt="Pratinjau foto profil" {% if not sellerProfile.foto_profil %}hidden{% endif %}>
      <small class="current-image-note">Foto opsional. Jika tidak memilih gambar baru, foto saat ini tetap digunakan.</small>
    </div>
    <label>Nama usaha<input name="nama_usaha" required value="{{ sellerProfile.nama_usaha|e }}"></label>
    <label>Jenis usaha<input name="jenis_usaha" value="{{ sellerProfile.jenis_usaha|e }}"></label>
    <label>Nomor telepon / WhatsApp<input name="nomor_telepon" value="{{ sellerProfile.nomor_telepon|e }}"></label>
    <label class="full">Alamat usaha<textarea name="alamat" rows="4">{{ sellerProfile.alamat|e }}</textarea></label>
    <div class="form-hint full">Status verifikasi: <b>{{ sellerProfile.verification_status|capitalize }}</b></div>
    <button class="button" type="submit">Simpan profil</button>
  </form>
</section>
</main>
{% endblock %}