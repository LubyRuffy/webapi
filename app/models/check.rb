class Check < ApplicationRecord
	validates :name ,presence: true, length: { maximum: 64}, uniqueness: true	
	#has_many :plugins
end
