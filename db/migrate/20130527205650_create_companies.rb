class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :logo
      t.integer :profiles_count, :default => 0
      t.integer :projects_count, :default => 0
      t.timestamps
    end
  end
end
