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
    var input=zone.querySelector('input[type="file"]');
    var preview=zone.querySelector('.dropzone-preview');
    var multi=zone.querySelector('[data-multi-preview]');
    if(!input)return;
    zone.addEventListener('click',function(e){if(e.target!==input && !e.target.closest('button'))input.click();});
    ['dragenter','dragover'].forEach(function(n){zone.addEventListener(n,function(e){e.preventDefault();zone.classList.add('is-dragover');});});
    ['dragleave','drop'].forEach(function(n){zone.addEventListener(n,function(e){e.preventDefault();zone.classList.remove('is-dragover');});});
    zone.addEventListener('drop',function(e){if(e.dataTransfer&&e.dataTransfer.files.length){setFiles(e.dataTransfer.files);}});
    input.addEventListener('change',function(){setFiles(input.files);});
    function setFiles(files){
      if(input.multiple && files.length>3){alert('Maksimal 3 gambar.');input.value='';return;}
      var valid=[];
      Array.prototype.forEach.call(files,function(file){
        if(!file.type.match(/^image\/(jpeg|png|webp)$/)){alert('Pilih gambar JPG, PNG, atau WEBP.');return;}
        if(file.size>4*1024*1024){alert('Ukuran setiap gambar maksimal 4 MB.');return;}
        valid.push(file);
      });
      if(valid.length!==files.length){input.value='';return;}
      var transfer=new DataTransfer();valid.forEach(function(file){transfer.items.add(file);});input.files=transfer.files;
      if(multi){multi.innerHTML='';valid.forEach(function(file){var img=document.createElement('img');img.alt='Pratinjau gambar';img.src=URL.createObjectURL(file);multi.appendChild(img);});}
      else if(preview&&valid[0]){preview.src=URL.createObjectURL(valid[0]);preview.hidden=false;}
      zone.classList.toggle('has-preview',valid.length>0);
    }
  });

  // Galeri foto publik: klik foto untuk membuka popup dan geser antar gambar.
  var modal=document.createElement('div');
  modal.className='photo-lightbox';
  modal.innerHTML='<button type="button" class="lightbox-close" aria-label="Tutup">×</button><button type="button" class="lightbox-prev" aria-label="Sebelumnya">‹</button><img alt="Foto kuliner"><button type="button" class="lightbox-next" aria-label="Berikutnya">›</button><div class="lightbox-count"></div>';
  document.body.appendChild(modal);
  var currentImages=[],currentIndex=0;
  function renderLightbox(){modal.querySelector('img').src=currentImages[currentIndex];modal.querySelector('.lightbox-count').textContent=(currentIndex+1)+' / '+currentImages.length;modal.querySelector('.lightbox-prev').hidden=currentImages.length<2;modal.querySelector('.lightbox-next').hidden=currentImages.length<2;}
  function openLightbox(images,index){currentImages=images;currentIndex=index||0;renderLightbox();modal.classList.add('open');}
  function closeLightbox(){modal.classList.remove('open');}
  modal.querySelector('.lightbox-close').addEventListener('click',closeLightbox);
  modal.addEventListener('click',function(e){if(e.target===modal)closeLightbox();});
  modal.querySelector('.lightbox-prev').addEventListener('click',function(){currentIndex=(currentIndex+currentImages.length-1)%currentImages.length;renderLightbox();});
  modal.querySelector('.lightbox-next').addEventListener('click',function(){currentIndex=(currentIndex+1)%currentImages.length;renderLightbox();});
  document.addEventListener('keydown',function(e){if(!modal.classList.contains('open'))return;if(e.key==='Escape')closeLightbox();if(e.key==='ArrowRight')modal.querySelector('.lightbox-next').click();if(e.key==='ArrowLeft')modal.querySelector('.lightbox-prev').click();});
  document.querySelectorAll('[data-gallery]').forEach(function(card){
    var images=[];try{images=JSON.parse(card.getAttribute('data-gallery')||'[]');}catch(e){}
    if(!images.length)return;
    var img=card.querySelector('.food-image img');if(!img)return;
    img.style.cursor='zoom-in';img.addEventListener('click',function(e){e.preventDefault();e.stopPropagation();openLightbox(images,0);});
  });

});