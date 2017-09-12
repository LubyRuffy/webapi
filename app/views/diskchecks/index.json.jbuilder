
json.err_code @err_code?@err_code : 0
json.err_msg @err_msg?@err_msg : ""
if !@err_code
  json.data do 
    json.db_full      @db_full
    json.report_full  @report_full
    json.db_size      @db_size
    json.report_size  @report_size
    json.db_limit     @limit.db_limit
    json.report_limit @limit.report_limit
  end
end
