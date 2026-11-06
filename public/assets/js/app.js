document.addEventListener('DOMContentLoaded', function () {
  var toggle = document.querySelector('.menu-toggle');
  var nav = document.querySelector('.main-nav');
  if (toggle && nav) {
    toggle.addEventListener('click', function () {
      var open = nav.classList.toggle('nav-open');
      nav.style.display = open ? 'flex' : '';
      nav.style.position = open ? 'absolute' : '';
      nav.style.top = open ? '65px' : '';
      nav.style.left = open ? '0' : '';
      nav.style.right = open ? '0' : '';
      nav.style.padding = open ? '20px' : '';
      nav.style.background = open ? '#fff' : '';
      nav.style.flexDirection = open ? 'column' : '';
    });
  }

  document.querySelectorAll('[data-dropzone]').forEach(function (zone) {
    var input = zone.querySelector('input[type="file"]');
    var preview = zone.querySelector('.dropzone-preview');
    if (!input) return;
    zone.addEventListener('click', function (event) {
      if (event.target !== input) input.click();
    });
    ['dragenter', 'dragover'].forEach(function (name) {
      zone.addEventListener(name, function (event) {
        event.preventDefault(); zone.classList.add('is-dragover');
      });
    });
    ['dragleave', 'drop'].forEach(function (name) {
      zone.addEventListener(name, function (event) {
        event.preventDefault(); zone.classList.remove('is-dragover');
      });
    });
    zone.addEventListener('drop', function (event) {
      if (event.dataTransfer && event.dataTransfer.files.length) {
        input.files = event.dataTransfer.files;
        showPreview(input.files[0]);
      }
    });
    input.addEventListener('change', function () {
      if (input.files && input.files[0]) showPreview(input.files[0]);
    });
    function showPreview(file) {
      if (!file.type.match(/^image\/(jpeg|png|webp)$/)) {
        alert('Pilih gambar JPG, PNG, atau WEBP.'); input.value = ''; return;
      }
      if (file.size > 4 * 1024 * 1024) {
        alert('Ukuran gambar maksimal 4 MB.'); input.value = ''; return;
      }
      var reader = new FileReader();
      reader.onload = function (event) {
        preview.src = event.target.result; preview.hidden = false; zone.classList.add('has-preview');
      };
      reader.readAsDataURL(file);
    }
  });
});