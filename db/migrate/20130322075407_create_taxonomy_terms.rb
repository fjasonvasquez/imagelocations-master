class CreateTaxonomyTerms < ActiveRecord::Migration
  def change
    create_table :taxonomy_terms do |t|
      t.references :taxonomy, :null => false
      t.string :name, :null => false
      #t.string :label, :null => false
      t.integer :parent_id, :null => false, :default => 0
      t.timestamps
    end
    add_index :taxonomy_terms, [:taxonomy_id, :name], :unique => true
  end
end
