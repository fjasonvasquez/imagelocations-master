class CreateTaxonomyTermEntities < ActiveRecord::Migration
  def change
    create_table :taxonomy_term_entities do |t|
      t.references :taxonomy_term, :null => false
      t.references :site_entity
      #t.integer :site_id, :default => 0
      
      #t.belongs_to :taxable, :polymorphic => true

      t.timestamps
    end
    # add_index :entity_taxonomy_terms, [:taxable_id, :taxable_type]
    add_index :taxonomy_term_entities, [:taxonomy_term_id, :site_entity_id], :unique => true, :name => 'index_taxable_entity'
  end
end
