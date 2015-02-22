# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20150107233725) do

  create_table "activities", :force => true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "activities", ["owner_id", "owner_type"], :name => "index_activities_on_owner_id_and_owner_type"
  add_index "activities", ["recipient_id", "recipient_type"], :name => "index_activities_on_recipient_id_and_recipient_type"
  add_index "activities", ["trackable_id", "trackable_type"], :name => "index_activities_on_trackable_id_and_trackable_type"

  create_table "asset_entities", :force => true do |t|
    t.integer  "site_entity_id",                    :null => false
    t.integer  "asset_id",                          :null => false
    t.string   "key"
    t.text     "meta"
    t.integer  "priority",           :default => 0
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "watermark_override"
  end

  add_index "asset_entities", ["asset_id"], :name => "index_asset_entities_on_asset_id"
  add_index "asset_entities", ["site_entity_id"], :name => "index_asset_entities_on_site_entity_id"

  create_table "asset_entities_collections", :force => true do |t|
    t.integer "asset_entity_id", :null => false
    t.integer "collection_id",   :null => false
  end

  add_index "asset_entities_collections", ["asset_entity_id"], :name => "index_asset_entities_collections_on_asset_entity_id"
  add_index "asset_entities_collections", ["collection_id"], :name => "index_asset_entities_collections_on_collection_id"

  create_table "asset_sizes", :force => true do |t|
    t.integer "site_id"
    t.string  "key"
    t.string  "process",   :default => "resize_to_fill"
    t.integer "height"
    t.integer "width"
    t.boolean "watermark", :default => false
  end

  add_index "asset_sizes", ["site_id", "key"], :name => "index_asset_sizes_on_site_id_and_key", :unique => true
  add_index "asset_sizes", ["site_id"], :name => "index_asset_sizes_on_site_id"

  create_table "asset_versions", :force => true do |t|
    t.integer "asset_id",                         :null => false
    t.integer "asset_size_id",                    :null => false
    t.boolean "processed",     :default => false
    t.integer "height",        :default => 0
    t.integer "width",         :default => 0
  end

  add_index "asset_versions", ["asset_id"], :name => "index_asset_versions_on_asset_id"
  add_index "asset_versions", ["asset_size_id"], :name => "index_asset_versions_on_asset_size_id"

  create_table "asset_videos", :force => true do |t|
    t.integer  "video_id",         :null => false
    t.string   "source"
    t.string   "source_embed_url"
    t.string   "type"
    t.string   "content_type"
    t.integer  "file_size"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "asset_videos", ["video_id"], :name => "index_asset_videos_on_video_id"

  create_table "assets", :force => true do |t|
    t.string   "source"
    t.string   "type"
    t.string   "content_type"
    t.integer  "file_size"
    t.string   "title"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "height",          :default => 0
    t.integer  "width",           :default => 0
    t.integer  "photographer_id", :default => 0
  end

  create_table "authentications", :force => true do |t|
    t.integer  "user_id",      :null => false
    t.string   "provider",     :null => false
    t.string   "access_token"
    t.string   "uid"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "authentications", ["uid"], :name => "index_authentications_on_uid"
  add_index "authentications", ["user_id", "provider"], :name => "index_authentications_on_user_id_and_provider", :unique => true
  add_index "authentications", ["user_id"], :name => "index_authentications_on_user_id"

  create_table "banner_entities", :force => true do |t|
    t.string   "type"
    t.integer  "section_id",                :null => false
    t.integer  "priority",   :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "banner_entities", ["section_id"], :name => "index_banner_entities_on_section_id"

  create_table "banner_entity_site_entities", :force => true do |t|
    t.integer  "banner_entity_id",                      :null => false
    t.string   "banner"
    t.integer  "related_site_entity_id", :default => 0
    t.integer  "priority",               :default => 0
    t.text     "options"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  add_index "banner_entity_site_entities", ["banner_entity_id"], :name => "index_banner_entity_site_entities_on_banner_entity_id"
  add_index "banner_entity_site_entities", ["related_site_entity_id"], :name => "index_banner_entity_site_entities_on_related_site_entity_id"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "type"
    t.integer  "locations_count", :default => 0
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "series_id"
  end

  add_index "categories", ["name"], :name => "index_categories_on_name"

  create_table "categories_locations", :id => false, :force => true do |t|
    t.integer "category_id"
    t.integer "location_id"
  end

  add_index "categories_locations", ["category_id", "location_id"], :name => "index_categories_locations_on_category_id_and_location_id", :unique => true
  add_index "categories_locations", ["category_id"], :name => "index_categories_locations_on_category_id"
  add_index "categories_locations", ["location_id"], :name => "index_categories_locations_on_location_id"

  create_table "cities", :force => true do |t|
    t.string  "name",                           :null => false
    t.integer "state_id",                       :null => false
    t.string  "logo"
    t.float   "latitude"
    t.float   "longitude"
    t.string  "timezone"
    t.integer "locations_count", :default => 0
  end

  add_index "cities", ["name"], :name => "index_cities_on_name"
  add_index "cities", ["state_id"], :name => "index_cities_on_state_id"

  create_table "collections", :force => true do |t|
    t.integer  "user_id",                   :null => false
    t.integer  "site_id",    :default => 0
    t.string   "name"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "logo"
    t.integer  "profiles_count", :default => 0
    t.integer  "projects_count", :default => 0
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "dashboards", :force => true do |t|
    t.integer "user_id", :null => false
  end

  add_index "dashboards", ["user_id"], :name => "index_dashboards_on_user_id", :unique => true

  create_table "field_entities", :force => true do |t|
    t.integer  "site_entity_id"
    t.integer  "field_id"
    t.text     "value"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "field_entities", ["field_id"], :name => "index_field_entities_on_field_id"
  add_index "field_entities", ["site_entity_id", "field_id"], :name => "index_field_entities_on_site_entity_id_and_field_id", :unique => true
  add_index "field_entities", ["site_entity_id"], :name => "index_field_entities_on_site_entity_id"

  create_table "field_objects", :force => true do |t|
    t.integer "field_id"
    t.string  "object"
  end

  add_index "field_objects", ["field_id", "object"], :name => "index_field_id_object", :unique => true

  create_table "fields", :force => true do |t|
    t.string  "name"
    t.string  "label"
    t.string  "object",   :default => "all"
    t.integer "priority", :default => 0
    t.boolean "public",   :default => false
    t.text    "args"
    t.integer "site_id",  :default => 0
  end

  add_index "fields", ["name", "object"], :name => "index_name_object", :unique => true
  add_index "fields", ["site_id"], :name => "index_fields_on_site_id"

  create_table "location_application_images", :force => true do |t|
    t.string   "source"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.integer  "location_application_id", :default => 0, :null => false
  end

  create_table "location_applications", :force => true do |t|
    t.integer  "site_id",                                      :null => false
    t.integer  "user_id"
    t.string   "status",                :default => "pending"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.string   "name",                  :default => "",        :null => false
    t.string   "email",                 :default => "",        :null => false
    t.string   "phone",                 :default => "",        :null => false
    t.text     "usage"
    t.text     "exclusive"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "postcode"
    t.string   "country"
    t.float    "latitude"
    t.float    "longitude"
    t.text     "notes"
    t.text     "international_address", :default => "",        :null => false
    t.string   "ip",                    :default => "",        :null => false
    t.text     "listing"
  end

  create_table "location_applications_sites", :id => false, :force => true do |t|
    t.integer "location_application_id"
    t.integer "site_id"
  end

  create_table "locations", :force => true do |t|
    t.integer  "series_id"
    t.integer  "permit_id"
    t.integer  "series_number", :default => 0
    t.string   "address"
    t.string   "postcode"
    t.integer  "city_id"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "locations", ["city_id"], :name => "index_locations_on_city_id"
  add_index "locations", ["permit_id"], :name => "index_locations_on_permit_id"
  add_index "locations", ["series_id", "series_number"], :name => "index_locations_on_series_id_and_series_number", :unique => true
  add_index "locations", ["series_id"], :name => "index_locations_on_series_id"

  create_table "locations_projects", :id => false, :force => true do |t|
    t.integer "locations_id"
    t.integer "projects_id"
  end

  create_table "memberships", :force => true do |t|
    t.integer "user_id",                :null => false
    t.integer "site_id", :default => 0, :null => false
    t.integer "role_id",                :null => false
  end

  add_index "memberships", ["user_id", "site_id", "role_id"], :name => "index_memberships_on_user_id_and_site_id_and_role_id", :unique => true

  create_table "object_permissions", :force => true do |t|
    t.integer "permissionable_id"
    t.integer "permission_id"
    t.text    "conditions"
    t.string  "permissionable_type", :default => "Role", :null => false
  end

  add_index "object_permissions", ["permissionable_id", "permissionable_type", "permission_id"], :name => "index_permisionable_and_permission_id", :unique => true

  create_table "order_entities", :force => true do |t|
    t.integer  "orderable_id",                                                  :null => false
    t.string   "orderable_type",                                                :null => false
    t.integer  "order_id",                                                      :null => false
    t.decimal  "price",          :precision => 8, :scale => 2, :default => 0.0
    t.integer  "quantity",                                     :default => 1
    t.datetime "created_at",                                                    :null => false
    t.datetime "updated_at",                                                    :null => false
  end

  add_index "order_entities", ["orderable_id", "orderable_type", "order_id"], :name => "orderable_order_index", :unique => true

  create_table "orders", :force => true do |t|
    t.integer  "site_id",                                                        :null => false
    t.datetime "order_date",                                                     :null => false
    t.string   "billing_name"
    t.string   "billing_address"
    t.string   "billing_zip"
    t.string   "billing_state"
    t.string   "billing_country"
    t.text     "notes"
    t.decimal  "total",           :precision => 8, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                     :null => false
    t.datetime "updated_at",                                                     :null => false
  end

  create_table "pages", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "payments", :force => true do |t|
    t.integer  "order_id"
    t.string   "type"
    t.decimal  "amount",     :precision => 8, :scale => 2, :default => 0.0
    t.string   "token"
    t.string   "status"
    t.text     "meta"
    t.datetime "created_at",                                                :null => false
    t.datetime "updated_at",                                                :null => false
  end

  create_table "permissions", :force => true do |t|
    t.string "action"
    t.string "object"
    t.string "name"
  end

  add_index "permissions", ["action", "object"], :name => "index_permissions_on_action_and_object", :unique => true

  create_table "permits", :force => true do |t|
    t.string   "name"
    t.string   "logo"
    t.integer  "locations_count", :default => 0
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "photographers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "photographers", ["name"], :name => "index_photographers_on_name", :unique => true

  create_table "plans", :force => true do |t|
    t.integer  "site_id",                                     :default => 0,        :null => false
    t.integer  "promo_code_id"
    t.string   "name",                                        :default => ""
    t.string   "status",                                      :default => "active"
    t.integer  "duration"
    t.decimal  "price",         :precision => 8, :scale => 2
    t.boolean  "renewable",                                   :default => true,     :null => false
    t.boolean  "saleable",                                    :default => true,     :null => false
    t.text     "description"
    t.datetime "created_at",                                                        :null => false
    t.datetime "updated_at",                                                        :null => false
  end

  create_table "profiles", :force => true do |t|
    t.integer "user_id",    :null => false
    t.string  "avatar"
    t.string  "first_name"
    t.string  "last_name"
    t.integer "company_id"
  end

  add_index "profiles", ["company_id"], :name => "index_profiles_on_company_id"
  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id", :unique => true

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.integer  "company_id", :default => 0
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "promo_codes", :force => true do |t|
    t.integer  "plan_id",                                                        :null => false
    t.string   "code",                                                           :null => false
    t.decimal  "discount",   :precision => 8, :scale => 2, :default => 0.0
    t.string   "status",                                   :default => "active", :null => false
    t.datetime "created_at",                                                     :null => false
    t.datetime "updated_at",                                                     :null => false
  end

  create_table "publication_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "publication_categories_publications", :id => false, :force => true do |t|
    t.integer "publication_category_id"
    t.integer "publication_id"
  end

  add_index "publication_categories_publications", ["publication_category_id", "publication_id"], :name => "index_on_publication_category", :unique => true

  create_table "publications", :force => true do |t|
    t.string   "name"
    t.string   "cover"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.integer  "publication_category_id"
  end

  create_table "region_conditions", :force => true do |t|
    t.integer "region_id"
    t.string  "type"
    t.string  "value"
  end

  add_index "region_conditions", ["region_id", "type", "value"], :name => "index_region_conditions_on_region_id_and_type_and_value", :unique => true
  add_index "region_conditions", ["region_id"], :name => "index_region_conditions_on_region_id"

  create_table "regions", :force => true do |t|
    t.string   "name"
    t.string   "label"
    t.integer  "weather_city_id"
    t.text     "weather_forecast"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "regions", ["weather_city_id"], :name => "index_regions_on_weather_city_id"

  create_table "related_site_entities", :force => true do |t|
    t.integer  "site_entity_id"
    t.integer  "related_site_entity_id"
    t.integer  "priority",               :default => 0
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  add_index "related_site_entities", ["related_site_entity_id"], :name => "index_related_site_entities_on_related_site_entity_id"
  add_index "related_site_entities", ["site_entity_id"], :name => "index_related_site_entities_on_site_entity_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "label"
    t.integer  "level",      :default => 10
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "section_objects", :force => true do |t|
    t.integer "section_id",                     :null => false
    t.string  "object",       :default => "0"
    t.boolean "allow_banner", :default => true
  end

  add_index "section_objects", ["section_id"], :name => "index_section_objects_on_section_id"

  create_table "sections", :force => true do |t|
    t.string  "name"
    t.string  "key"
    t.integer "site_id",                :null => false
    t.integer "limit",   :default => 0
  end

  add_index "sections", ["key", "site_id"], :name => "index_sections_on_key_and_site_id", :unique => true
  add_index "sections", ["site_id"], :name => "index_sections_on_site_id"

  create_table "series", :force => true do |t|
    t.string   "name"
    t.integer  "locations_count", :default => 0
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "series", ["name"], :name => "index_name", :unique => true

  create_table "session_activations", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "session_id", :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "session_activations", ["session_id"], :name => "index_session_activations_on_session_id", :unique => true
  add_index "session_activations", ["user_id"], :name => "index_session_activations_on_user_id"

  create_table "settings", :force => true do |t|
    t.integer "site_id"
    t.string  "key"
    t.string  "section",         :default => "general"
    t.string  "controller_name", :default => "application"
    t.string  "value"
    t.text    "options"
    t.string  "action_name"
  end

  add_index "settings", ["site_id", "key", "section"], :name => "index_settings_on_site_id_and_key_and_section", :unique => true
  add_index "settings", ["site_id"], :name => "index_settings_on_site_id"

  create_table "simple_captcha_data", :force => true do |t|
    t.string   "key",        :limit => 40
    t.string   "value",      :limit => 6
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "simple_captcha_data", ["key"], :name => "idx_key"

  create_table "site_entities", :force => true do |t|
    t.integer  "site_entitable_id",                        :null => false
    t.string   "site_entitable_type",                      :null => false
    t.integer  "site_id",             :default => 0
    t.integer  "priority",            :default => 0
    t.string   "status",              :default => "draft"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.string   "slug"
    t.string   "entity_title",        :default => "",      :null => false
  end

  add_index "site_entities", ["site_entitable_id", "site_entitable_type", "site_id"], :name => "index_site_entitable_site_id", :unique => true
  add_index "site_entities", ["site_id", "slug"], :name => "index_site_entities_on_site_id_and_slug"
  add_index "site_entities", ["site_id"], :name => "index_site_entities_on_site_id"
  add_index "site_entities", ["status"], :name => "index_site_entities_on_status"

  create_table "sites", :force => true do |t|
    t.string  "hostname"
    t.string  "name"
    t.string  "namespace"
    t.integer "active"
    t.string  "google_tracking_id"
  end

  add_index "sites", ["hostname"], :name => "index_sites_on_hostname", :unique => true
  add_index "sites", ["namespace"], :name => "index_sites_on_namespace", :unique => true

  create_table "states", :force => true do |t|
    t.string "name",           :null => false
    t.string "state_code"
    t.string "country_alpha2"
  end

  add_index "states", ["country_alpha2"], :name => "index_states_on_country_alpha2"
  add_index "states", ["name", "country_alpha2"], :name => "index_states_on_name_and_country_alpha2", :unique => true
  add_index "states", ["name"], :name => "index_states_on_name"

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id",                                :null => false
    t.integer  "plan_id",                                :null => false
    t.datetime "start_date",                             :null => false
    t.datetime "expiration_date"
    t.string   "status",          :default => "pending", :null => false
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "subscriptions", ["user_id", "plan_id", "status"], :name => "index_subscriptions_on_user_id_and_plan_id_and_status", :unique => true
  add_index "subscriptions", ["user_id", "plan_id"], :name => "index_subscriptions_on_user_id_and_plan_id"

  create_table "taxonomies", :force => true do |t|
    t.string   "type"
    t.string   "name"
    t.integer  "priority",   :default => 0
    t.integer  "public",     :default => 0
    t.string   "object",     :default => "all"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "taxonomies", ["name"], :name => "index_taxonomies_on_name", :unique => true

  create_table "taxonomy_term_entities", :force => true do |t|
    t.integer  "taxonomy_term_id", :null => false
    t.integer  "site_entity_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "taxonomy_term_entities", ["site_entity_id"], :name => "index_taxonomy_term_entities_on_site_entity_id"
  add_index "taxonomy_term_entities", ["taxonomy_term_id", "site_entity_id"], :name => "index_taxable_entity", :unique => true
  add_index "taxonomy_term_entities", ["taxonomy_term_id"], :name => "index_taxonomy_term_entities_on_taxonomy_term_id"

  create_table "taxonomy_terms", :force => true do |t|
    t.integer  "taxonomy_id",                :null => false
    t.string   "name",                       :null => false
    t.integer  "parent_id",   :default => 0, :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "taxonomy_terms", ["name"], :name => "index_taxonomy_terms_on_name"
  add_index "taxonomy_terms", ["taxonomy_id", "name"], :name => "index_taxonomy_terms_on_taxonomy_id_and_name", :unique => true
  add_index "taxonomy_terms", ["taxonomy_id"], :name => "index_taxonomy_terms_on_taxonomy_id"

  create_table "tears", :force => true do |t|
    t.string   "name"
    t.integer  "publication_id"
    t.integer  "location_id"
    t.text     "description"
    t.string   "cover"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "order",          :default => 0
  end

  add_index "tears", ["location_id"], :name => "index_tears_on_location_id"
  add_index "tears", ["publication_id"], :name => "index_tears_on_publication_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email",                  :default => "",       :null => false
    t.string   "encrypted_password",     :default => "",       :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "status",                 :default => "active"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
