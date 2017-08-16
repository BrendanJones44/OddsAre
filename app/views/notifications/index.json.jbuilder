json.array! @notifications do |notification|
  json.recipient notification.recipient
  json.actor notification.actor
  json.action notification.action
  json.notifiable notification.notifiable
  json.url user_path(notification.actor)
end
