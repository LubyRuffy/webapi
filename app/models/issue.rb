require "pry-byebug"
class Issue < ApplicationRecord
	belongs_to :scan
	def self.create_issue(issue, scan_id)
		if !issue
			return
		end
		tmp = self.input_param issue, scan_id
		@issue = Issue.new tmp
		begin 
			@issue.save!
		rescue 
			return
		end
	end

	private

	def self.input_param(param, scan_id)
		tmp = Hash.new
		tmp[:scan_id] = scan_id
		tmp[:name] = param["name"]
		tmp[:url] = param["request"]["url"]
		tmp[:cwe] = param["cvssv2"]
		tmp[:cwe_url] = param["cwe_url"]
		tmp[:description] = param["description"]
		tmp[:vector_type] = param["vector"]["type"]
		tmp[:http_method] = param["request"]["method"]
		tmp[:tags] = param["tags"]
		tmp[:references] = param["references"]
		tmp[:proof] = param["proof"]
		tmp[:response_body] = param["response"]["body"]
		tmp[:references] = param["references"]
		tmp[:remedy_guidance] = param["remedy_guidance"]
		tmp[:remarks] = param["remarks"]
		tmp[:severity] = param["severity"]
		tmp[:digest] = param["digest"]
		tmp[:response] = param["response"]
		tmp[:request] = param["request"]
		return tmp
	end
end
