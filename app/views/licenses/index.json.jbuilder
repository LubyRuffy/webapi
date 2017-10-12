
json.err_code @err_code?@err_code : 0
json.err_msg @err_msg?@err_msg : ""
if !@err_code
  json.data do 
    json.expired_time @expired_time?@expired_time:""
  end
end
