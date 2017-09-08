#json.array! @templates, partial: 'templates/template', as: :template
json.err_code @err_code ? @err_code.to_s : "0"
json.err_msg @err_msg ? @err_msg : ""
json.data do
	if(!@err_code) 
		json.array! @template do |tmp|
			json.id tmp.id.to_s
			json.name tmp.name
			json.ref tmp.ref.to_s
		end
	end
end
