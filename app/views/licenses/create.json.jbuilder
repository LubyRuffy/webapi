
json.err_code @err_code?@err_code: 0
json.err_msg @err_msg?@err_msg : ''
if !@err_code
  json.data do 
  end
end
