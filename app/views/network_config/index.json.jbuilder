
json.err_code @err_code?@err_code : 0
json.err_msg @err_msg?@err_msg : ""
if !@err_code
  json.data do 
    json.type @type?@type:''
    json.address @address?@address:''
    json.gateway @gateway?@gateway:''
    json.interface @interface?@interface:''
  end
end
