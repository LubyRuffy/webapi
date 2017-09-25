json.err_code @err_code ? @err_code.to_s : "0"
json.err_msg @err_msg ?@err_msg : ""
json.data do
	if !@err_code
		json.url @scan.url
		json.name @scan.name
		json.template do
			json.id @template.id.to_s
			json.name @template.name
		end
		json.all_template do
			json.array! @all_template do |tmp|
				json.id tmp.id.to_s
				json.name tmp.name
			end
		end
		json.login_plugin do
			json.enble @scan.login_setting.to_s
			json.type @scan.login_type
			json.user_pass do
				json.url @scan.login_url
				json.username @scan.http_authentication_username
				json.password @scan.http_authentication_password
			end
			json.cookie @scan.http_cookies
		end
		json.crawl do
			json.enable @scan.spider_setting.to_s
			json.depth_limit @scan.scope_directory_depth_limit
			json.page_limit @scan.scope_page_limit
			json.include_pattern @scan.scope_extend_paths
			json.exclude_file_extensions @scan.scope_exclude_content_patterns
			json.exclude_pattern @scan.scope_exclude_path_patterns
		end

	end
end
