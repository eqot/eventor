json.array! @users do |user|
  json.email user.email
  json.name user.name
end
