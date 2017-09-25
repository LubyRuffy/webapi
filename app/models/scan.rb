require "pry-byebug"
class Scan < ApplicationRecord
	include TyphoeusRequest
	has_many :issues, dependent: :destroy # Will delete with scan deleted.
	has_many :sitemaps, dependent: :destroy # Same as upper .
	serialize :issue_digests,					Array
	serialize :statistics,						Hash
	serialize :scope_exclude_path_patterns,		Array
	serialize :scope_exclude_content_patterns,	Array
	serialize :scope_extend_paths,				Array

	def self.get_scan(id)  
		begin
			scan = self.find(id)
		rescue
			return
		end
		return scan
	end
	
	def get_data
		data = get_info_from_scans(self.scan_id)
		if data == "Scan not found for token: #{self.scan_id}."
			return false
		end
		self.refresh data

		if data["busy"] == true
			return true
		else
			return false
		end
	end

	def refresh(data)
		self.active = true
		self.status = data["status"]
		self.statistics = data["statistics"].merge(messages:data["messages"])
		save
		if !data["issues"].empty?
			push_issues data["issues"]
		end
		if !data["sitemap"].empty?
			push_sitemap data["sitemap"]
		end
		if data["busy"]== false
			finish
			delete_scans_task(self.scan_id)
		end
	end

	def push_issues(issues)
		issues.each do |issue|
			if self.issue_digests.include?(issue["digest"]) == true
				next
			end
			
			has_issue =Issue.where( scan_id: self.id, digest: issue["digest"].to_s).first
			if has_issue
				next
			end
			
			self.issue_digests << issue["digest"]
			save
			
			Issue.create_issue issue, self.id
		end
	end
	
	def push_sitemap(sitemap)
		Sitemap.create_sitemap sitemap, self.id
	end

	def finish
		self.status = "done"
		self.active = false
		self.finished_at = Time.now
		save
	end
end
