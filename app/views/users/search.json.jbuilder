
json.users do
  json.array!(@users) do |user|
    json.name user.first_name + user.last_name
  end
end