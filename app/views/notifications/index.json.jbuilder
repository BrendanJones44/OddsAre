json.array! @notifications do |notification|
  json.id notification.id
  json.actor notification.actor
  json.action notification.action
  json.notifiable notification.notifiable
  json.url polymorphic_path(notification.notifiable)
end
