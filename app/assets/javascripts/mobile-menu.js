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
$(window).resize(function () {
  if ($(this).width() >= 676) {
    $('#left-sidebar-wrapper').show();
  }
  else {
    $('#left-sidebar-wrapper').hide();
  }
});
$(document).ready(function () {
  if ($(window).width() >= 676) {
    $('#left-sidebar-wrapper').show();
  } else {
    $('#left-sidebar-wrapper').hide();
  }
});
