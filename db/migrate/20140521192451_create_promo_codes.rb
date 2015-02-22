class CreatePromoCodes < ActiveRecord::Migration
  def change
    create_table :promo_codes do |t|
      t.references :plan, :null => false
      t.string :code, :null => false
      t.decimal :discount, :precision => 8, :scale => 2, :default => 0
      t.string :status, :null => false, :default => "active"
      t.timestamps
    end
  end
end
