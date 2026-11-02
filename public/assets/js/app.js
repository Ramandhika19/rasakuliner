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
});
