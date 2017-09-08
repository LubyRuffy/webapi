require "pry-byebug"

class TemplatesController < ApplicationController
	#get /templates/new
	#get list of checks
	def new
		@check=Check.all
	end

	#get /templates
	#get list of templates
	def index
		@template=Template.all
	end
	
	#post /templates
	#create a new template
	def create
		
		create_params = Hash.new
		create_params[:name] = params[:name]
		create_params[:checks] = Array.new
		params[:checks].each do |tmp|
			begin
				check = Check.find(tmp[:id])
			rescue
				@err_code = 20010
				@err_msg = "don't found checks"
				return
			end
			if(check.name != tmp[:name])
				@err_code = 20012
				@err_msg = "check name not match"
				return
			end
			create_params[:checks] << tmp[:id]
		end
		create_params[:ref] = 0
		@template = Template.new create_params
		begin
			@template.save!
		rescue ActiveRecord::RecordInvalid
			@err_code = 20007
			@err_msg = "template name collided"
		rescue 
			@err_code = 20008;
			@err_msg = "create template err"
		end

	end
	
	#post /templates/delete
	#create one or more template
	def delete
		params[:id].each do |i|
			begin
				@template = Template.find(i.to_d)
			rescue
				@err_code = 20009
				@err_msg = "don't found template"
				return
			end
			@template.destroy
		end
	end
	
	#get /templates/{id}
	#get one template infomation
	def show
		begin
			@template = Template.find(params[:id])
		rescue
			@err_code = 20009
			@err_msg = "don't found template"
			return
		end
		
		@check = Array.new	
		@template.checks.each do |i|
			begin
				Check.find(i.to_d)
			rescue
				@err_code = 20010
				@err_msg = "don't found checks"
				return
			end
			@check << Check.find(i.to_d)
		end
		@all = Check.all
	end
	
	#post /templates/{id}
	#update one template
	def update	
		begin
			@template = Template.find(params[:id])
		rescue 
			@err_code = 20009
			@err_msg = "don't found template"
			return
		end
		
		if(@template.name != params[:name])
			@err_code = "20011"
			@err_msg = "template name not match"
			return
		else
			update_params = Array.new
			params[:checks].each do |tmp|
				begin 
					check = Check.find tmp[:id]
				rescue
					@err_code = 20010
					@err_msg = "don't found checks"
					return
				end
				if(check.name != tmp[:name])
					@err_code = 20012
					@err_msg = "check name not match"
					return
				end
				update_params << tmp[:id]
			end
			@template.update_attributes(:checks=>update_params)
		end
	end
end
