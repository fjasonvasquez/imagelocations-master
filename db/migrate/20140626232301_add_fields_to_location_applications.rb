class AddFieldsToLocationApplications < ActiveRecord::Migration
  def change
  	create_table :location_applications_sites, :id => false do |t|
	  	t.integer :location_application_id
  		t.integer :site_id
	end
	
	add_column :location_applications, :name, :string, :after => :status, :null => false, :default => ""
	add_column :location_applications, :email, :string, :after => :name, :null => false, :default => ""
	add_column :location_applications, :phone, :string, :after => :email, :null => false, :default => ""
	
	add_column :location_applications, :usage, :text, :after => :phone
	add_column :location_applications, :exclusive, :text, :after => :usage
	
  	add_column :location_applications, :address, :string, :after => :usage
  	add_column :location_applications, :city, :string, :after => :address
  	add_column :location_applications, :state, :string, :after => :city
  	add_column :location_applications, :postcode, :string, :after => :state
  	add_column :location_applications, :country, :string, :after => :postcode
  	add_column :location_applications, :latitude, :float, :after => :country
  	add_column :location_applications, :longitude, :float, :after => :latitude
  	add_column :location_applications, :notes, :text, :after => :longitude
  end
  
end
