
json.err_code @err_code?@err_code : 0
json.err_msg @err_msg?@err_msg : ""
if !@err_code
  json.data do 
    json.dns1 @dns1?@dns1:''
    json.dns2 @dns2?@dns2:''
  end
end
