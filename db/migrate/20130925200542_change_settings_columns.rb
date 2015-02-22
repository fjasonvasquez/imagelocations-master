class ChangeSettingsColumns < ActiveRecord::Migration
  def up
  	rename_column :settings, :controller, :controller_name
  	add_column :settings, :action_name, :string, :after => :controller_name
  	
  	change_column :settings, :controller_name, :string, :default => :application
  end

  def down
  	remove_column :settings, :action_name, :string
  	rename_column :settings, :controller_name, :controller
  	
  	change_column :settings, :controller, :string, :default => ""
  end
end
