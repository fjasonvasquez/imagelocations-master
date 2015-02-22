class CreateTears < ActiveRecord::Migration
  def change
    create_table :tears do |t|
	  t.string :name
	  t.references :publication
	  t.references :location
	  t.text :description
	  t.string :cover
      t.timestamps
    end
  end
end
