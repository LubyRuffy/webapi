json.err_code @err_code ? @err_code.to_s : "0"
json.err_msg @err_msg ?@err_msg : ""
json.data do
	if !@err_code
		json.array! @check do |tmp|
			json.id tmp.id.to_s
			json.name tmp.name
		end
	end
end
