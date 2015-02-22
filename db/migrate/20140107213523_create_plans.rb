class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.references :site, :null => false, :default => 0
      t.references :promo_code
      t.string :name, :default => ""
      t.string :status, :default => "active"
      t.integer :duration
      t.decimal :price, :precision => 8, :scale => 2
      t.boolean :renewable, :default => true, :null => false
      t.boolean :saleable, :default => true, :null => false
      t.text :description
      t.timestamps
    end
  end
end
