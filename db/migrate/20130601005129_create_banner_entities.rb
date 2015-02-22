class CreateBannerEntities < ActiveRecord::Migration
  def change
    create_table :banner_entities do |t|
      t.string :type
      t.references :section, :null => false
	  t.integer :priority, :default => 0
      t.timestamps
    end
  end
end
