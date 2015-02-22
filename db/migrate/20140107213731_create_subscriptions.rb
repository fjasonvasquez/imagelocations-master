class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :user, :null => false
      t.references :plan, :null => false
      t.datetime :start_date, :null => false
      t.datetime :expiration_date
      t.string :status, :null => false, :default => "pending"
      t.timestamps
    end
    
    add_index :subscriptions, [:user_id, :plan_id], :unique => false
	add_index :subscriptions, [:user_id, :plan_id, :status], :unique => true
  end
end
