class CreateFields < ActiveRecord::Migration
  def change
    create_table :fields do |t|
	    t.string :name
	    t.string :label
	    t.string :object, :default => :all
	    t.integer :priority, :default => 0
	    t.boolean :public, :default => 0
	    t.text :args
    end
    
    add_index :fields, [:name, :object], :unique => true, :name => 'index_name_object'    
  end
end
