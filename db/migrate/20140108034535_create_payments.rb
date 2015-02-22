class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :order
      t.string :type
      t.decimal :amount, :precision => 8, :scale => 2, :default => 0
      t.string :token
      t.string :status
      t.text :meta
      t.timestamps
    end
  end
end
