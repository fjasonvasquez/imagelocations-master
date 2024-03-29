class AddUserActiveSessions < ActiveRecord::Migration
  def change
    create_table :session_activations do |t|
      t.integer :user_id,   null: false
      t.string :session_id, null: false
      t.timestamps
    end

    add_index :session_activations, :user_id
    add_index :session_activations, :session_id, unique: true
  end
end
