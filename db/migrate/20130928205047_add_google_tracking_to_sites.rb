class AddGoogleTrackingToSites < ActiveRecord::Migration
  def change
  	add_column :sites, :google_tracking_id, :string, :after => :namespace
  end
end
