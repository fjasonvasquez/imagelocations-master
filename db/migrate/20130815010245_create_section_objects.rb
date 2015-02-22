class CreateSectionObjects < ActiveRecord::Migration
  def change
     create_table :section_objects do |t|
	  t.references :section, :null => false
	  t.string :object, :default => 0
    end
  end
end
