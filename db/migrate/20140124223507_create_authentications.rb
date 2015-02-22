class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.references :user, :null => false
      t.string :provider, :null => false
      t.string :access_token
      t.string :uid
      t.timestamps
    end
    
    add_index :authentications, :user_id, :unique => false
    add_index :authentications, :uid, :unique => false
    add_index :authentications, [:user_id, :provider], :unique => true
  end
end
