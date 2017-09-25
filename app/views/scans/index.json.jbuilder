json.err_code @err_code ? @err_code.to_s: "0"
json.err_msg @err_msg ?@err_msg : ""
json.data do
	json.array! @scan do |tmp|
		json.id tmp.id.to_s
		json.url tmp.url
		json.name tmp.name
		json.root_id tmp.root_id.to_s
		json.template tmp.checks_id.to_s
		json.status tmp.status
		json.started_at tmp.started_at
		json.finished_at tmp.finished_at
		json.statistics tmp.statistics
	end
end
