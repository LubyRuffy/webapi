class Sitemap < ApplicationRecord
	belongs_to :scan	
	serialize :sitemap, Hash
end
