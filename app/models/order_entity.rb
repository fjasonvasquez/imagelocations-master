class OrderEntity < ActiveRecord::Base
  # attr_accessible :title, :body
  
  belongs_to :orderable, :polymorphic => true, :touch => true, :inverse_of => :order_entities 
  belongs_to :order
end
