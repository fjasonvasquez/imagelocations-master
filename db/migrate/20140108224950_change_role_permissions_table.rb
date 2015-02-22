class ChangeRolePermissionsTable < ActiveRecord::Migration
  def up
  	
  	
  	
  	rename_column :role_permissions, :role_id, :permissionable_id
  	
  	add_column :role_permissions, :permissionable_type, :string, :null => false, :default => "Role", :after => :id
  	
  	rename_table :role_permissions, :object_permissions
  	
  	
  	
  	remove_index :object_permissions, :name => 'index_role_permissions_on_role_id_and_permission_id' 
  	
  	
  	add_index :object_permissions, [:permissionable_id, :permissionable_type, :permission_id], :unique => true, :name => "index_permisionable_and_permission_id"
  	
  	#change_table :object_permissions do |t|
      
      #t.references :permissionable, :polymorphic => true
    #end
    
  end

  def down
  	
  	rename_column :object_permissions, :permissionable_id, :role_id
  	remove_column :object_permissions, :permissionable_type
  	
  	rename_table :object_permissions, :role_permissions
  	
  	remove_index :role_permissions, :name => 'index_permisionable_and_permission_id' 
  	
  	add_index :role_permissions, [:role_id, :permission_id], :unique => true
  	
  	#change_table :role_permissions do |t|
    #  t.remove_references :permissionable, :polymorphic => true
    #end
    
  end
end
