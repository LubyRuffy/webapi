json.err_code @err_code
json.err_msg @err_msg
json.data do 
  if @err_code == 0
    json.username @user.username
    json.password @user.password
    json.email    @user.email
    json.phone_no @user.phone_no
    json.description @user.description
    json.role_id  @user.role_id
  end
end
