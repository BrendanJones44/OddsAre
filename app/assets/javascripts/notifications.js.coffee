class Notifications
  constructor: ->
    @notifications = $("[data-behavior='notifications']")
    $("[data-behavior='unread-count']").text(@notifications.length)
    @setup()

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
    )

  handleSuccess: (data) =>
    if data.length > 0
      items = $.map data, (notification) ->
        "<a class='dropdown-item' href='#{notification.url}'>#{notification.actor.first_name} #{notification.actor.last_name} (@#{notification.actor.user_name}) #{notification.action}</a>"
      $("[data-behavior='notification-items']").html(items)
      $("[data-behavior='unread-count']").text(items.length)
    else
      item = "<a class='dropdown-item' href=''#'>No New Notifications</a>"
      $("[data-behavior='notification-items']").html(item)


start_notifictations = ->
    new Notifications

$(document).ready(start_notifictations)
$(document).on('page:load', start_notifictations)


document.addEventListener('turbolinks:request-start', start_notifictations)
document.addEventListener('turbolinks:load', start_notifictations)
