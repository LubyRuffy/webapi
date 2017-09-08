#json.partial! "templates/template", template: @templatei
json.err_code @err_code ? @err_code.to_s : "0"
json.err_msg @err_msg ? @err_msg : ""
json.data do
	if !@err_code
		json.id @template.id.to_s
		json.name @template.name
		json.checks do
	    	json.array! @check do |tmp|
				json.id tmp.id.to_s
				json.name tmp.name
			end
		end
		json.all do
			json.array! @all do |tmp|
				json.id tmp.id.to_s
				json.name tmp.name
			end
		end
	end
end
