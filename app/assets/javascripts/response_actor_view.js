// Bind function to page so it still works on navigation
document.addEventListener("turbolinks:load", function() {
  $(function() {
    // Don't refresh page
    event.preventDefault();
    $('#challenge_response_show_actor_number').on("click", function(event) {
      if ($('#challenge_response_show_actor_number').text() === "Show number") {
        $('#challenge_response_actor_number_view').show();
        $('#challenge_response_show_actor_number').text("Hide number");
      } else {
        $('#challenge_response_actor_number_view').hide();
        $('#challenge_response_show_actor_number').text("Show number");
      }
    })
  })
})
