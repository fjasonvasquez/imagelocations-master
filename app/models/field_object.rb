class FieldObject < ActiveRecord::Base
  attr_accessible :field, :field_id, :object
  
  belongs_to :field
  
end
