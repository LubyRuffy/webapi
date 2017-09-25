class Check < ApplicationRecord
	validates :name ,presence: true, length: { maximum: 64}, uniqueness: true	
	#has_many :plugins

	def self.get_check(id)
		begin
			check = self.find(id)
		rescue
			return
		end
		return check
	end
end
