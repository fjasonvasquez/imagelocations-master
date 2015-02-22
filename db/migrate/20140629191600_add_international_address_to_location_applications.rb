class AddInternationalAddressToLocationApplications < ActiveRecord::Migration
  def change
  		add_column :location_applications, :international_address, :text, :after => :country, :null => false, :default => ""
  		add_column :location_applications, :ip, :string, :after => :id, :null => false, :default => ""
  end
end
