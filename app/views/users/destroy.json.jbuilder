
json.err_code @err_code?@err_code: 0
json.err_msg @err_msg?@err_msg : ''
#if !@err_code
#  json.data do 
#    json.(@user, :id, :username, :password, :email, :phone_no, :description, :role_id)
#  end
#end
