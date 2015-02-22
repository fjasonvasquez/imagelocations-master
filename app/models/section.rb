class Section < ActiveRecord::Base
  attr_accessible :site, :name, :key, :limit
  attr_accessible :section_objects_attributes
  
  
  
  belongs_to :site
  
  has_many :banner_entities, :dependent => :destroy
  
  
  has_many :section_objects, :dependent => :destroy
  
  accepts_nested_attributes_for :section_objects, :allow_destroy => true
  
  
  def at_limit?  
  	!limit.zero? && limit <= banner_entities.count
  end
  
  
  def has_one_section_object?
  	section_objects.count == 1
  end
  
  
end
