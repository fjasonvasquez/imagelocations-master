class AddNewIndexes < ActiveRecord::Migration
  def up
  	#Asset Versions
  	#add_index :asset_versions, [:asset_id,:asset_size_id], :unique => true
  	add_index :asset_versions, :asset_id, :unique => false
  	add_index :asset_versions, :asset_size_id, :unique => false
  	
  	#Asset Sizes
  	add_index :asset_sizes, :site_id, :unique => false
  	add_index :asset_sizes, [:site_id,:key], :unique => true
  	
  	#Asset Entitites
  	
  	add_index :asset_entities, :site_entity_id, :unique => false
  	add_index :asset_entities, :asset_id, :unique => false
  	
  	#Asset Entity Collections
  	
  	add_index :asset_entities_collections, :asset_entity_id, :unique => false
  	add_index :asset_entities_collections, :collection_id, :unique => false
  	
  	#Asset Vidoes
  	add_index :asset_videos, :video_id, :unique => false
  	
  	#Banner Entities
  	add_index :banner_entities, :section_id, :unique => false
  	
  	#Banner Entity Site Entities
  	add_index :banner_entity_site_entities, :banner_entity_id, :unique => false
  	add_index :banner_entity_site_entities, :related_site_entity_id, :unique => false
  	
  	#Locations
  	add_index :locations, :series_id, :unique => false
  	add_index :locations, :permit_id, :unique => false
  	add_index :locations, :city_id, :unique => false
  	
  	#Tears
  	add_index :tears, :publication_id, :unique => false
  	add_index :tears, :location_id, :unique => false
  	
  	#Cities
  	add_index :cities, :name, :unique => false
  	add_index :cities, :state_id, :unique => false
  	
  	#States
  	add_index :states, :name, :unique => false
  	add_index :states, :country_alpha2, :unique => false
  
  	#Categories
  	add_index :categories, :name, :unique => false
  	
  	#Category Locations
  	add_index :categories_locations, :category_id, :unique => false
  	add_index :categories_locations, :location_id, :unique => false
  	
  	#Taxonomy terms
  	add_index :taxonomy_terms, :name, :unique => false
  	add_index :taxonomy_terms, :taxonomy_id, :unique => false
  	  	
  	#Taxonomy Term Entities
  	add_index :taxonomy_term_entities, :site_entity_id, :unique => false
  	add_index :taxonomy_term_entities, :taxonomy_term_id, :unique => false
  	
  	#Field Entities
  	add_index :field_entities, [:site_entity_id, :field_id], :unique => true
  	add_index :field_entities, :field_id, :unique => false
  	add_index :field_entities, :site_entity_id, :unique => false
  	
  	
  	#Related Site Entities
  	add_index :related_site_entities, :site_entity_id, :unique => false
  	add_index :related_site_entities, :related_site_entity_id, :unique => false
  	
  	#Section Objects
  	add_index :section_objects, :section_id, :unique => false
  	
  	#Sections
  	add_index :sections, [:key, :site_id], :unique => true
  	add_index :sections, :site_id, :unique => false
  	
  	#Settings
  	add_index :settings, [:site_id, :key, :section], :unique => true
  	add_index :settings, :site_id, :unique => false
  	
  	#Site Entities
  	add_index :site_entities, :site_id, :unique => false
  	add_index :site_entities, :status, :unique => false
  	
  	#Profiles
  	add_index :profiles, :company_id, :unique => false
  	
  	#Region Conditions
  	add_index :region_conditions, :region_id, :unique => false
  	
  	#Regions
  	add_index :regions, :weather_city_id, :unique => false
  end

  def down
  	#Asset Versions
  	#add_index :asset_versions, [:asset_id,:asset_size_id], :unique => true
  	remove_index :asset_versions, :asset_id
  	remove_index :asset_versions, :asset_size_id
  	
  	#Asset Sizes
  	remove_index :asset_sizes, :site_id
  	remove_index :asset_sizes, [:site_id,:key]
  	
  	#Asset Entitites
  	
  	remove_index :asset_entities, :site_entity_id
  	remove_index :asset_entities, :asset_id
  	
  	#Asset Entity Collections
  	
  	remove_index :asset_entities_collections, :asset_entity_id
  	remove_index :asset_entities_collections, :collection_id
  	
  	#Asset Vidoes
  	remove_index :asset_videos, :video_id
  	
  	#Banner Entities
  	remove_index :banner_entities, :section_id
  	
  	#Banner Entity Site Entities
  	remove_index :banner_entity_site_entities, :banner_entity_id
  	remove_index :banner_entity_site_entities, :related_site_entity_id

  	#Locations
  	remove_index :locations, :series_id
  	remove_index :locations, :permit_id
  	remove_index :locations, :city_id
  	
  	#Tears
  	remove_index :tears, :publication_id
  	remove_index :tears, :location_id
  	
  	#Cities
  	remove_index :cities, :name
  	remove_index :cities, :state_id
  	
  	#States
  	remove_index :states, :name
  	remove_index :states, :country_alpha2
  	
  	#Categories
  	remove_index :categories, :name
  	
  	#Category Locations
  	remove_index :categories_locations, :category_id
  	remove_index :categories_locations, :location_id
  	
  	#Taxonomy terms
  	remove_index :taxonomy_terms, :name
  	remove_index :taxonomy_terms, :taxonomy_id
  	
  	#Taxonomy Term Entities
  	remove_index :taxonomy_term_entities, :site_entity_id
  	remove_index :taxonomy_term_entities, :taxonomy_term_id
  	
  	#Field Entities
  	remove_index :field_entities, [:site_entity_id, :field_id]
  	remove_index :field_entities, :field_id
  	remove_index :field_entities, :site_entity_id
  	
  	#Related Site Entities
  	remove_index :related_site_entities, :site_entity_id
  	remove_index :related_site_entities, :related_site_entity_id
  	
  	#Section Objects
  	remove_index :section_objects, :section_id
  	
  	#Sections
  	remove_index :sections, [:key, :site_id]
  	remove_index :sections, :site_id
  	
  	#Settings
  	remove_index :settings, [:site_id, :key, :section]
  	remove_index :settings, :site_id
  	
  	#Site Entities
  	remove_index :site_entities, :site_id
  	remove_index :site_entities, :status
  	
  	#Profiles
  	remove_index :profiles, :company_id
  	
  	#Region Conditions
  	remove_index :region_conditions, :region_id
  	
  	#Regions
  	remove_index :regions, :weather_city_id
  end
end
