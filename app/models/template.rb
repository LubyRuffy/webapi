class Template < ApplicationRecord
	validates :name ,presence: true, length: { maximum: 64}, uniqueness: true
	serialize :checks ,Array
	def after_initialize  
	    self.checks ||= {}  
	end

	def self.get_template(id)
		begin
			template = self.find(id)
		rescue
			return
		end
		return template
	end
	#index >0 add, <0 del
	def self.update_ref(id, index)
		template = self.get_template id
		if !template
			return false
		end
		template.update_attributes(:ref=>(template.ref+index))
		return true		
	end
end
