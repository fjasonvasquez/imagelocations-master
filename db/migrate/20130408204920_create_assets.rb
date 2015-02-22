class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
	  #t.belongs_to :mediaable, :polymorphic => true
	  t.string :source
	  t.string :type
	  t.string :content_type
	  t.integer :file_size
	  t.string :title
      t.timestamps
    end
    
    #add_index :assets, [:type], :unique => false, :name => 'index_type'
  end
end
