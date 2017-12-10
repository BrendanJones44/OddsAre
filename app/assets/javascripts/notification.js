$(function() {
	$('.dismiss-notification').on("click", function(event){
		var notificationElement = $(this);
		var parent = $(this).parent().parent();
		console.log(parent);
    event.preventDefault();
		$.ajax({
			url: $('.dismiss-notification').attr("url"),
			type: 'POST',
			success:function(){
				parent.remove();
				var numberOfNotifications = Number($('#notification-count').text()) - 1;
				if(numberOfNotifications === 0){
					$('#notification-dropdown').append( "<a class='dropdown-item' href=''>No new notifications</a>" );
				}
				$('#notification-count').text(numberOfNotifications);
			}
		})
  })
});
