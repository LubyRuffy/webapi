class Template < ApplicationRecord
	validates :name ,presence: true, length: { maximum: 64}, uniqueness: true
	serialize :checks ,Array
	def after_initialize  
	    self.checks ||= {}  
	end
end
