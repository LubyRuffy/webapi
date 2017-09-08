class ScansController < ApplicationController
	#get /scans/new
	def new
		@template = Template.all
	end
	
	#get /scans  (add for test)
	def index
		@scan = Scan.all
	end

	#post /scans/delete
	def delete
		params[:id].each do |tmp|
			begin
				@scan = Scan.find(tmp.to_d)
			rescue
				@err_code = 20013
				@err_msg = "don't found scans"
				return
			end
			@scan.destroy
		end
	end

	#get /scans/:id
	def show
		begin
			@scan = Scan.find(params[:id])
		rescue
			@err_code = 20013
			@err_msg = "don't found scans"
			return
		end
		
		begin
			@template = Template.find(@scan.checks_id)
		rescue
			@err_code = 20009
			@err_msg = "don't found templates"
			return
		end

		@all_template = Template.all
	
	end

	#post  /scans/:id
	def update
		begin
			@scan = Scan.find(params[:id])
		rescue
			@err_code = 20013
			@err_msg = "don't found scans"
			return
		end
		update_params = Hash.new
		update_params[:url] = params[:url]
		update_params[:name] = params[:name]
		update_params[:checks_id] = params[:template][:id]
		update_params[:login_setting] = params[:login_plugin][:enable]
		update_params[:login_type] = params[:login_plugin][:type]
		update_params[:login_url] = params[:login_plugin][:user_pass][:url]
		update_params[:http_authentication_username] = params[:login_plugin][:user_pass][:username]
		update_params[:http_authentication_password] = params[:login_plugin][:user_pass][:password]
		update_params[:http_cookies] = params[:login_plugin][:cookie]
		update_params[:spider_setting] = params[:crawl][:enable]
		update_params[:scope_directory_depth_limit] = params[:crawl][:depth_limit]
		update_params[:scope_page_limit] = params[:crawl][:page_limit]
		update_params[:scope_exclude_path_patterns] = params[:crawl][:exclude_pattern]
		update_params[:scope_exclude_content_patterns] = params[:crawl][:exclude_file_extensions]
		update_params[:scope_extend_paths] = params[:crawl][:include_pattern]

		@scan.update_attributes(update_params)

	end

	#post /scans
	def create
		create_params = Hash.new
		create_params[:url] = params[:url]
		create_params[:name] = params[:name]
		create_params[:checks_id] = params[:template][:id]
		create_params[:login_setting] = params[:login_plugin][:enable]
		create_params[:login_type] = params[:login_plugin][:type]
		create_params[:login_url] = params[:login_plugin][:user_pass][:url]
		create_params[:http_authentication_username] = params[:login_plugin][:user_pass][:username]
		create_params[:http_authentication_password] = params[:login_plugin][:user_pass][:password]
		create_params[:http_cookies] = params[:login_plugin][:cookie]
		create_params[:spider_setting] = params[:crawl][:enable]
		create_params[:scope_directory_depth_limit] = params[:crawl][:depth_limit]
		create_params[:scope_page_limit] = params[:crawl][:page_limit]
		create_params[:scope_exclude_path_patterns] = params[:crawl][:exclude_pattern]
		create_params[:scope_exclude_content_patterns] = params[:crawl][:exclude_file_extensions]
		create_params[:scope_extend_paths] = params[:crawl][:include_pattern]
		
		@scan = Scan.new create_params
		begin
			@scan.save!
		rescue
			@err_code = 20014
			@err_msg = "create scan err"
			return
		end
		#save and start scan
		#if params[:commit_type] == 2

		#end

	end

	#post /scans/:id/repeat
	def repeat
		begin
			old_scan = Scan.find(params[:id])
		rescue
			@err_code = 20013
			@err_msg = "don't found scans"
			return
		end
		
		@scan = Scan.new do |tmp|
			tmp.root_id = old_scan.id
			tmp.url = old_scan.url
			tmp.name = old_scan.name
			tmp.checks_id = old_scan.checks_id
			tmp.login_setting = old_scan.login_setting
			tmp.login_type = old_scan.login_type
			tmp.login_url = old_scan.login_url
			tmp.http_authentication_username = old_scan.http_authentication_username
			tmp.http_authentication_password = old_scan.http_authentication_password
			tmp.http_cookies = old_scan.http_cookies
			tmp.spider_setting = old_scan.spider_setting
			tmp.scope_directory_depth_limit = old_scan.scope_directory_depth_limit
			tmp.scope_page_limit = old_scan.scope_page_limit
			tmp.scope_exclude_path_patterns = old_scan.scope_exclude_path_patterns
			tmp.scope_exclude_content_patterns = old_scan.scope_exclude_content_patterns
			tmp.scope_extend_paths = old_scan.scope_extend_paths
		end
		begin 
			@scan.save!
		rescue
			@err_code = 20014
			@err_msg = "create scan err"
		end
	end

	#post /scans/:id/stop
	def stop
		begin
			@scan = Scan.find(params[:id])
		rescue
			@err_code = 20013
			@err_msg = "don't found scans"
			return
		end

	end

	#post /scans/:id/start
	def start
		begin
			@scan = Scan.find(params[:id])
		rescue
			@err_code = 20013
			@err_msg = "don't found scans"
			return
		end

	end

	#post /scans/:id/resume
	def resume
		begin
			@scan = Scan.find(params[:id])
		rescue
			@err_code = 20013
			@err_msg = "don't found scans"
			return
		end


	end

	#post /scans/:id/pause
	def pause
		begin
			@scan = Scan.find(params[:id])
		rescue
			@err_code = 20013
			@err_msg = "don't found scans"
			return
		end

	end
end
