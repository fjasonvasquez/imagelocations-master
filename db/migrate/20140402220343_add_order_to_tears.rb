class AddOrderToTears < ActiveRecord::Migration
  def change
  	add_column :tears, :order, :integer, :after => :location_id, :default => 0
  end
end
