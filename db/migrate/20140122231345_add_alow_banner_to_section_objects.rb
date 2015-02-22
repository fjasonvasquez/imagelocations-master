class AddAlowBannerToSectionObjects < ActiveRecord::Migration
  def change
  	add_column :section_objects, :allow_banner, :boolean, :after => :object, :default => true
  end
end
