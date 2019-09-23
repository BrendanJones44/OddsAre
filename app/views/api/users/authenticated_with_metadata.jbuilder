json.message 'authenticated'
json.data do
  json.user_id @user_id

  json.notifications @notifications do |notification|
    json.id notification.id
    json.actor notification.actor
    json.action notification.action
    json.notifiable_id notification.notifiable_id
    json.notifiable_type notification.notifiable_type
  end

  json.friends @friends do |friend|
    json.id friend.id
    json.user_name friend.user_name
    json.name friend.full_name
  end
end
