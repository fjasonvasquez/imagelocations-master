class CreatePublicationCategories < ActiveRecord::Migration
  def change
    create_table :publication_categories do |t|
	  t.string :name
      t.timestamps
    end
    
    
    add_column :publications, :publication_category_id, :integer
      
    # create_table :publication_categories_publications, :id => false do |t|
#       t.references :publication_category, :publication
#     end
#     add_index :publication_categories_publications, [:publication_category_id, :publication_id], :unique => true, :name => "index_on_publication_category"


  end
end
