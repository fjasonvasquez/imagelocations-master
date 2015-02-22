class CreateTaxonomies < ActiveRecord::Migration
  def change
    create_table :taxonomies do |t|
      t.string :type
      t.string :name
      t.integer :priority, :default => 0
      t.integer :public, :default => 0
      #t.string :label
      t.string :object, :default => :all
      t.timestamps
    end
    
    add_index :taxonomies, [:name], :unique => true
  end
end
