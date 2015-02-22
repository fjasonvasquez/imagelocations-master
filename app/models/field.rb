class Field < ActiveRecord::Base
  attr_accessible :name, :label, :priority, :public, :args
  attr_accessible :field_objects_attributes
  
  serialize :args, Hash
  
  has_many :field_objects, :dependent => :destroy
  has_many :field_entities, :dependent => :destroy
  
  belongs_to :site
  
  accepts_nested_attributes_for :field_objects, allow_destroy: true
  
  default_scope order('priority ASC')
  
  before_create :set_default_label
  before_create :set_default_args
  
  def args
  	self[:args][:label] ||= self[:label]
    self[:args]
  end

  def args=(val)
    self[:args] = val
  end
  
  private
  	def set_default_label
  		self.label ||= self.name.humanize
  	end
  	
  	def set_default_args
  		self.args.is_a?(Hash)  || self.args = {}
  	end
  
end
