class Sitemap < ApplicationRecord
	belongs_to :scan	
	serialize :sitemap, Hash

	def self.create_sitemap(sitemap_info, scanId)
		sitemap = Sitemap.where(scan_id:scanId).first
		if sitemap
			if sitemap.sitemap.empty?
				sitemap.sitemap = sitemap_info
			else
				sitemap_info.each_pair do |key,value|
					sitemap.sitemap.store(key, value)
				end
			end
			sitemap.save
		else
			input = Hash.new
			input[:sitemap] = sitemap_info
			input[:scan_id] = scanId
			sitemap = Sitemap.new input

			begin
				sitemap.save!
			rescue
				return
			end
		end
	end
end
