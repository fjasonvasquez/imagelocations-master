class CreateOrderEntities < ActiveRecord::Migration
  def change
    create_table :order_entities do |t|
      t.belongs_to :orderable, :polymorphic => true, :null => false
      t.references :order, :null => false
      t.decimal :price, :precision => 8, :scale => 2, :default => 0
      t.integer :quantity, :default => 1
      t.timestamps
    end
    
    add_index :order_entities, [:orderable_id, :orderable_type, :order_id], :unique => true, :name => "orderable_order_index"
  end
end
