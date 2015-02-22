class SectionObject < ActiveRecord::Base
  attr_accessible :section, :object, :allow_banner
  
  belongs_to :section
  
  
  def object=(value)
  	value = value.name if value.respond_to?(:name)
	self[:object] = value  	
  end
  
end
