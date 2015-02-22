class CreateDatabases < ActiveRecord::Migration
  def up
    create_table :sites do |t|
      t.string :hostname
      t.string :name
      t.string :namespace
      t.integer :active
    end
    add_index :sites, [:namespace], :unique => true
    add_index :sites, [:hostname], :unique => true
    
    create_table :settings do |t|
      t.integer :site_id
      t.string :key
      t.string :section, :default => "general"
      t.string :controller, :default => ""
      t.string :value
      t.text :options
    end
    
    create_table :dashboards do |t|
      t.references :user, :null => false
    end
    add_index :dashboards, [:user_id], :unique => true
    
    create_table :roles do |t|
      t.string :name
      t.string :label
      t.integer :level, :default => 10
      t.timestamps
    end
    
    create_table :permissions do |t|
      t.string :action
      t.string :object
      t.string :name
    end
    add_index :permissions, [:action, :object], :unique => true
    
    create_table :role_permissions do |t|
      t.references :role, :permission
      t.text :conditions
      
    end
    add_index :role_permissions, [:role_id, :permission_id], :unique => true
    
    
    create_table :memberships do |t|
      t.references :user, :null => false
      t.references :site, :null => false, :default => 0
      t.references :role, :null => false
    end
    add_index :memberships, [:user_id, :site_id, :role_id], :unique => true
    
    #create_table :permissions_roles, :id => false do |t|
    #  t.references :permission, :role
    #end
    #add_index :permissions_roles, [:permission_id, :role_id], :unique => true
    
    
    
    create_table :users do |t|
      ## Database authenticatable
      t.string :username
      t.string :email,              :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => ""
      
      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip
      
      t.string  :status, :default => User::USER_STATUSES[0]
      #t.integer  :role_id
      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, :default => 0 # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      ## Token authenticatable
      # t.string :authentication_token
	  
      t.timestamps
    end

    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    # add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true
    # add_index :users, :authentication_token, :unique => true
    
    create_table :profiles do |t|
    	t.references :user, :null => false
    	t.string :avatar
    	t.string :first_name
    	t.string :last_name
    	t.references :company
    end
    add_index :profiles, :user_id, :unique => true
    
  end
  def down
  	drop_table :sites
  	drop_table :settings
  	drop_table :users
  	drop_table :roles
  	drop_table :memberships
  	drop_table :permissions
  	drop_table :role_permission
  end
end
