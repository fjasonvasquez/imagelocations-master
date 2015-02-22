class Setting < ActiveRecord::Base
  attr_accessible :site_id, :key, :section, :controller_name, :action_name, :value, :options
  belongs_to :site
  
  serialize :value
  serialize :options, Hash
  
  default_scope { order("controller_name ASC, action_name, section ASC")}
  
  scope :sections, proc { select("section").group("section")}
  scope :section, proc { |section| where(:section => section) }
  
  scope :by_controller, proc { |controller| where(:controller_name => controller) }
  
  scope :controllers, proc { |group| select(:controller_name).group(:controller_name)}
  
  before_create :set_default_options
  
  DEFAULTS = {
	  
  }
  def options
  	self[:options][:label] ||= self[:key].intern.to_s.titleize
    self[:options]
  end
  
  def options=(val)
    self[:options] = val
  end
  
  def controller_name
  	self[:controller_name].to_sym unless self[:controller_name].nil?
  end
  
  def action_name
  	self[:action_name].to_sym unless self[:action_name].nil?
  end
  
  private
  	
  def set_default_options
  		
	  self.options.is_a?(Hash) || self.options = {}

  end
end
