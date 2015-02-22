class FieldEntity < ActiveRecord::Base
  attr_accessor :enable
  
  attr_accessible :id, :field, :field_id, :value, :enable
  
  #belongs_to :field_entitable, :polymorphic => true
  belongs_to :site_entity, :touch => true
  belongs_to :field
  
  delegate :name, :to => :field, :allow_nil => false  
  delegate :label, :to => :field, :allow_nil => false
  delegate :args, :to => :field, :allow_nil => false
  
  scope :by_field, proc { |field| joins(:field).where(:fields => {:name => field})}
  
  
  def render
  	_as = args[:as]
  	unless value.nil?
      	case _as
      	
      		when :boolean
      			if value.to_i.zero? then "True" else "False" end
      		else
      			value.html_safe
      	end
    end
  
  end
  
end
