class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :name, :null => false
      t.string :state_code
      t.string :country_alpha2
    end
    add_index :states, [:name, :country_alpha2], :unique => true
  end
end
