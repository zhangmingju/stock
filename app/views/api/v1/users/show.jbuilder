json.result 0
json.user do
  json.id @user.unique_id
  json.name @user.user_name.to_s
  json.image Image.get_images(@user).first.to_s
  if @user.identification == 0
    json.identification "未认证"
  else
    json.identification "认证"
  end
  json.phone_num @user.phone_num.to_s
  json.rand @user.rand.to_s
end