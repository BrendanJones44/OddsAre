var isShowing = false;
function handleMenuToggle(x) {
  x.classList.toggle("change");
  if(isShowing) {
    $('#left-sidebar-wrapper').hide();
  } else {
    $('#left-sidebar-wrapper').show();
    $('#left-sidebar-wrapper').css('z-index', '1000');
    $('#left-sidebar-wrapper').css('overflow-y', 'auto');
  }
  isShowing = !isShowing;
}
document.addEventListener("turbolinks:load", function () {
  isShowing = false;
  $(window).resize(function () {
    if (isShowing){
      x.classList.toggle("change");
    }
    isShowing = false;
    if ($(this).width() >= 676) {
      $('#left-sidebar-wrapper').show();
    }
    else {
      $('#left-sidebar-wrapper').hide();
    }
  });
  $(document).ready(function () {
    if (isShowing) {
      x.classList.toggle("change");
    }
    isShowing = false;
    if ($(window).width() >= 676) {
      $('#left-sidebar-wrapper').show();
    } else {
      $('#left-sidebar-wrapper').hide();
    }
  });
});