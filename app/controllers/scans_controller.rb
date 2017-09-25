require "pry-byebug"

class ScansController < ApplicationController
	include TyphoeusRequest
	###########get /scans/new
	def new
		@template = Template.all
	end
	
	###########get /scans  (add for test)
	def index
		@scan = Scan.all
	end

	###########post /scans/delete
	def delete
		params[:id].each do |tmp|
			scan = Scan.get_scan tmp
			if !scan
				api_err 20013,"don't found scans"
				return
			end
			if (Template.update_ref(scan.checks_id, -1) == false)
				api_err 20018, "update template ref err"
				return
			end
			scan.destroy
		end
	end

	############get /scans/:id
	def show
		@scan = Scan.get_scan params[:id]
		if !@scan
			api_err 20013,"don't found scans"
			return 
		end
		@template = Template.get_template @scan.checks_id
		if !@template
			api_err 20009, "don't found template"
			return
		end

		@all_template = Template.all
	
	end

	##############post  /scans/:id
	def update
		@scan = Scan.get_scan params[:id]
		if !@scan
			api_err 20013,"don't found scans"
			return
		end
		if (Template.update_ref(@scan.checks_id, -1) == false)
			api_err 20018, "update template ref err"
			return
		end
		
		if (Template.update_ref(params[:template][:id], 1) == false)
			api_err 20018, "update template ref err"
			return
		end

		update_params = input_params params
		@scan.update_attributes(update_params)

	end

	###############post /scans
	def create

		template = Template.get_template params[:template][:id]
		if !template
			api_err 20009, "don't found template"	
		end
		create_params = input_params  params
		@scan = Scan.new create_params
		
		begin
			@scan.save!
		rescue
			api_err 20014, "create scan err"
			return
		end
		
		if (Template.update_ref(params[:template][:id], 1) == false)
			api_err 20018, "update template ref err"
			return
		end
		
		#save and start scan
		if params[:commit_type] == "2"
			data = create_scan_params template, @scan
			id = create_scans_task('scans', data)
			if !id
				api_err 20014, "create scan err"
			end
			@scan.update_attributes(scan_id:id, status:"scanning", started_at:Time.new)
			SaveScanJob.perform_later(@scan.id)
		else
			@scan.update_attributes(status:"ready")
		end

	end

	######################post /scans/:id/repeat
	def repeat
		old_scan = Scan.get_scan params[:id]
		if !old_scan
			api_err 20013,"don't found scans"
			return
		end
		
		@scan = Scan.new do |tmp|
			repeat_params tmp, old_scan
		end
		begin 
			@scan.save!
		rescue
			api_err 20014,"create scan err"
		end
		if (Template.update_ref(@scan.checks_id, 1) == false)
			api_err 20018, "update template ref err"
			return
		end

		template = Template.get_template @scan.checks_id
		if !template
			api_err 20009, "don't found template"	
		end
		data = create_scan_params template, @scan
		id = create_scans_task('scans', data)
		if !id
			api_err 20014, "create scan err"
		end
		@scan.update_attributes(scan_id:id, status:"scanning", started_at:Time.new)
		SaveScanJob.perform_later(@scan.id)
	end

	##############post /scans/:id/stop
	def stop
		@scan = Scan.get_scan params[:id]
		if !@scan
			api_err 20013,"don't found scans"
			return
		end

		if @scan.scan_id
			data = delete_scans_task(@scan.scan_id)
		end
		@scan.update_attributes(status:"stopped", finished_at:Time.new)
	end

	##############post /scans/:id/start
	def start

		@scan = Scan.get_scan params[:id]
		if !@scan
			api_err 20013,"don't found scans"
			return
		end
		
		template = Template.get_template @scan.checks_id
		if !template
			api_err 20009, "don't found template"	
		end

		data = create_scan_params template, @scan
		id = create_scans_task('scans', data)
		if !id
			api_err 20014, "create scan err"
		end
		@scan.update_attributes(scan_id:id, status:"scanning", started_at:Time.new)
		SaveScanJob.perform_later(@scan.id)

	end

	################post /scans/:id/resume
	def resume

		@scan = Scan.get_scan params[:id]
		if !@scan
			api_err 20013,"don't found scans"
			return
		end
		
		data = resume_scans @scan.scan_id
		if data != true
			api_err 20020,"resume scan err"
		end
		SaveScanJob.perform_later(@scan.id)
	end

	##################post /scans/:id/pause
	def pause

		@scan = Scan.get_scan params[:id]
		if !@scan
			api_err 20013,"don't found scans"
			return
		end

		data = pause_scans @scan.scan_id
		if data != true
			api_err 20019,"pause scan err" 
		end
	end

	private


	#used for create or update from web
	def input_params(params)
		new_params = Hash.new
		new_params[:url] = params[:url]
		new_params[:name] = params[:name]
		new_params[:checks_id] = params[:template][:id]
		new_params[:login_setting] = params[:login_plugin][:enable]
		new_params[:login_type] = params[:login_plugin][:type]
		new_params[:login_url] = params[:login_plugin][:user_pass][:url]
		new_params[:http_authentication_username] = params[:login_plugin][:user_pass][:username]
		new_params[:http_authentication_password] = params[:login_plugin][:user_pass][:password]
		new_params[:http_cookies] = params[:login_plugin][:cookie]
		new_params[:spider_setting] = params[:crawl][:enable]
		new_params[:scope_directory_depth_limit] = params[:crawl][:depth_limit]
		new_params[:scope_page_limit] = params[:crawl][:page_limit]
		new_params[:scope_exclude_path_patterns] = params[:crawl][:exclude_pattern]
		new_params[:scope_exclude_content_patterns] = params[:crawl][:exclude_file_extensions]
		new_params[:scope_extend_paths] = params[:crawl][:include_pattern]
		new_params[:status] = "ready"
		return new_params
	end
	#used for create scan from old scan
	def repeat_params(new_scan, old_scan) 
		new_scan.root_id = old_scan.id
		new_scan.url = old_scan.url
		new_scan.name = old_scan.name
		new_scan.checks_id = old_scan.checks_id
		new_scan.login_setting = old_scan.login_setting
		new_scan.login_type = old_scan.login_type
		new_scan.login_url = old_scan.login_url
		new_scan.http_authentication_username = old_scan.http_authentication_username
		new_scan.http_authentication_password = old_scan.http_authentication_password
		new_scan.http_cookies = old_scan.http_cookies
		new_scan.spider_setting = old_scan.spider_setting
		new_scan.scope_directory_depth_limit = old_scan.scope_directory_depth_limit
		new_scan.scope_page_limit = old_scan.scope_page_limit
		new_scan.scope_exclude_path_patterns = old_scan.scope_exclude_path_patterns
		new_scan.scope_exclude_content_patterns = old_scan.scope_exclude_content_patterns
		new_scan.scope_extend_paths = old_scan.scope_extend_paths
	end

	#used for create scan param to arachni
	def create_scan_params(template, scan)
		data = Hash.new
		data[:url] = scan.url
		data[:checks] = Array.new	
		template.checks.each do |tmp|
			Plugin.where(checks_id:tmp).find_each do |t|
				data[:checks] << t.name.chomp
			end
		end
		if scan.login_setting
			data[:http] = Hash.new
			if scan.login_type == 1
				data[:http][:authentication_username] = scan.http_authentication_username
				data[:http][:authentication_password] = scan.http_authentication_password
			else
				data[:http][:cookie_string] = scan.http_cookies
			end
		end	
		if scan.spider_setting
			data[:scope] = Hash.new
			data[:scope][:page_limit] = scan.scope_page_limit
			data[:scope][:directory_depth_limit] = scan.scope_directory_depth_limit
			data[:scope][:exclude_path_patterns] = scan.scope_exclude_path_patterns
			data[:scope][:exclude_content_patterns] = scan.scope_exclude_content_patterns
			data[:scope][:extend_paths] = scan.scope_extend_paths
		end
		return data
	end
end
