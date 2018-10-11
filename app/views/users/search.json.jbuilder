json.array!(@users) do |user|
  json.name user.first_name + ' ' + user.last_name
  json.url user_path(user)
end
