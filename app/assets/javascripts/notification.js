// Bind function to page so it still works on navigation
document.addEventListener("turbolinks:load", function() {
	// Function to dimiss notifications from notification dropdown x
	$(function() {
		$('.dismiss-notification').on("click", function(event){
			var notificationElement = $(this);
			// Grab the surrounding dropdown-item to remove notification once updated
			var dropdownItem = $(this).parent();
			// Don't navigate away from page
	    event.preventDefault();
			// Update notification object as read
			$.ajax({
				// Grab notification's dynamic url attribute
				url: $('.dismiss-notification').data("dismiss-url"),
				type: 'POST',
				success:function(){
					// Remove dropdown-item once notification updated
					dropdownItem.remove();
					var numberOfNotifications = Number($('#notification-count').text()) - 1;
					// Don't leave an empty dropdown-menu
					if(numberOfNotifications === 0){
						$('#notification-dropdown').append("<a class='dropdown-item' href=''>No new notifications</a>");
					}
					// Update the notification count with -1 of what it was.
					$('#notification-count').text(numberOfNotifications);
				}
			})
	  })
	});
})
document.addEventListener("turbolinks:load", function() {
	$(function() {
		$('.notification-link').on("click", function(event){
			if ($(this).data("dismiss-type") === "on_click"){
				console.log($(this))
				$.ajax({
					// Grab notification's dynamic url attribute
					url: $('.notification-link').data("dismiss-url"),
					type: 'POST',
					success:function(){
						// Remove dropdown-item once notification updated
						var numberOfNotifications = Number($('#notification-count').text()) - 1;
						// Don't leave an empty dropdown-menu
						if(numberOfNotifications === 0){
							$('#notification-dropdown').append("<a class='dropdown-item' href=''>No new notifications</a>");
						}
						// Update the notification count with -1 of what it was.
						$('#notification-count').text(numberOfNotifications);
					}
				})
			}
		});
	});
})
