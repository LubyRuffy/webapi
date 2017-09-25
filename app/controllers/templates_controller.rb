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
		
		tmp = input_params 1, params
		if !tmp
			return
		end
		@template = Template.new tmp
		begin
			@template.save!
#		rescue ActiveRecord::RecordInvalid
#			api_err 20007, "template name collied"

		rescue =>e
			if e.record.errors.messages[:name].include?("is too long (maximum is 64 characters)")
				api_err 20021, "template name is too long (maximum is 64 characters)"
			elsif  e.record.errors.messages[:name].include?("has already been taken")
				api_err 20007, "template name collied"
			else
				api_err 20008, "create template err"
			end
		end
	end
	
	#post /templates/delete
	#create one or more template
	def delete
		params[:id].each do |i|
			@template = Template.get_template i.to_d
			if !@template
				api_err 20009, "don't found template"
				return
			end
			
			if @template.ref > 0
				api_err 20017,"template ref more than 1"
				return
			end
			@template.destroy
		end
	end
	
	#get /templates/{id}
	#get one template infomation
	def show
		@template = Template.get_template params[:id]
		if !@template
			api_err 20009, "don't found template"
			return
		end
		
		@check = Array.new	
		@template.checks.each do |i|
			tmp = Check.get_check i.to_d
			if !tmp
				api_err 20010, "don't found checks"
				return 
			end
			@check << tmp
		end
		@all = Check.all
	end
	
	#post /templates/{id}
	#update one template
	def update
		@template = Template.get_template params[:id]
		if !@template
			api_err 20009, "don't found template"
			return
		end
		
		if(@template.name != params[:name])
			api_err 20011, "template name not match"
			return
		end
		if @template.ref > 0
			api_err 20017,"template ref more than 1"
			return
		end

		update_params = input_params 2, params
		if !update_params
			return
		end
		@template.update_attributes(update_params)
	end
	
	private

	#used for create or update  
	#flag:1 for create, 2 for update 
	def input_params(flag, params)
		create = Hash.new
		if flag == 1
			create[:name] = params[:name]
			create[:ref] = 0
		end
		create[:checks] = Array.new
		params[:checks].each do |tmp|
			check = Check.get_check tmp[:id]
			if !check
				api_err 20010, "don't found checks"
				return
			end
			if(check.name != tmp[:name])
				api_err 20012, "check name not match"
				return
			end
			create[:checks] << tmp[:id]
		end
		return create
	end

end
