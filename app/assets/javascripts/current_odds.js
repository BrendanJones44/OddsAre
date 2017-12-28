// Bind function to page so it still works on navigation
document.addEventListener("turbolinks:load", function() {
  $(function() {
    // Don't refresh page
    event.preventDefault();
    $('#current-odds-waiting-on-user-link').on("click", function(event) {
      $('#current-odds-waiting-on-friends-wrapper').hide();
      $('#current-odds-waiting-on-user-wrapper').show();
      $('#current-odds-waiting-on-user-link').addClass("active");
      $('#current-odds-waiting-on-friends-link').removeClass("active");
    })
  })
})

// Bind function to page so it still works on navigation
document.addEventListener("turbolinks:load", function() {
  $(function() {
    // Don't refresh page
    event.preventDefault();
    $('#current-odds-waiting-on-friends-link').on("click", function(event) {
      $('#current-odds-waiting-on-user-wrapper').hide();
      $('#current-odds-waiting-on-friends-wrapper').show();
      $('#current-odds-waiting-on-friends-link').addClass("active");
      $('#current-odds-waiting-on-user-link').removeClass("active");
    })
  })
})
