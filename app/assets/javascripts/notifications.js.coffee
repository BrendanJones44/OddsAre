class Notifications
  constructor: ->
    @notifications = $("[data-behavior='notifications']")
    @setup() if @notifications.length > 0

  setup: ->
    $("[data-behavior='notifications-link']").on "click", @handleClick
    $.ajax(
      url: "/notifications.json"
      dataType: "JSON"
      method: "GET"
      success: @handleSuccess
    )

  handleClick: (e) =>
    $.ajax(
      url: "/notifications/mark_as_read"
      dataType: "JSON"
      method: "POST"
      success: ->
        $("[data-behavior='unread-count']").text(0)
    )

  handleSuccess: (data) =>
    items = $.map data, (notification) ->
      "<a class='dropdown-item' href='#{notification.url}'>#{notification.actor.first_name} #{notification.actor.last_name} (@#{notification.actor.user_name}) sent you a friend request</a>"
    $("[data-behavior='notification-items']").html(items)
    $("[data-behavior='unread-count']").text(items.length)

start_notifictations = ->
    new Notifications

$(document).ready(start_notifictations)
$(document).on('page:load', start_notifictations)


document.addEventListener('turbolinks:request-start', start_notifictations)
document.addEventListener('turbolinks:load', start_notifictations)
