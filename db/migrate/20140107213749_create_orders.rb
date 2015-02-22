class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      #t.belongs_to :orderable, :polymorphic => true, :null => false
      t.references :site, :null => false
      t.datetime :order_date, :null => false
      t.string :billing_name
	  t.string :billing_address
	  t.string :billing_zip
	  t.string :billing_state
	  t.string :billing_country
	  
	  t.text :notes
	  
	  t.decimal :total, :precision => 8, :scale => 2, :default => 0
	  
      t.timestamps
    end
  end
end
