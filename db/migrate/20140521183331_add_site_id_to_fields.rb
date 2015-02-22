class AddSiteIdToFields < ActiveRecord::Migration
  def change
  	add_column :fields, :site_id, :integer, :after => :id, :default => 0
  	
  	add_index :fields, [:site_id], :unique => false
  
  end
end
