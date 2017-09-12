
json.err_code @err_code?@err_code : 0
json.err_msg @err_msg?@err_msg : ""
if !@err_code
  json.data do 
    json.db_limit @limit.db_limit
    json.report_limit @limit.report_limit
  end
end
