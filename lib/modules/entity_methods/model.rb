require 'active_support/concern'

module EntityMethods
	module Model
	  extend ActiveSupport::Concern
	  included do
	  	 include PublicActivity::Model
	  	 tracked owner: Proc.new{ |controller, model| controller && controller.current_user }
	  	 	  		
	  	 cattr_accessor :allow_site_entities
	  	 
	  	 Field.find_each do |field|
	  	 
	  	 	
	  	 	if field.args[:as] == :boolean
	  	 	
		  	 	define_singleton_method "is_#{field.name}" do
		  	 		
		  	 		joins(:current_entity => {:field_entities => :field})
		  	 		.where(["(fields.name = ? and field_entities.value = ?)", field.name, "1"])		  	 		
		  	 	end
		  	 	
		  	 	define_singleton_method "is_not_#{field.name}" do
		  	 		
		  	 		site_entities = SiteEntity.arel_table
		  	 		field_entities = FieldEntity.arel_table
		  	 		fields = Field.arel_table
		  	 	
		  	 		entity_fields = site_entities.join(fields, Arel::Nodes::InnerJoin)
		  	 				.on(
		  	 					fields[:name].eq(field.name).and(site_entities[:site_id].eq(fields[:site_id]).or(fields[:site_id].eq(0)))
		  	 				)
		  	 				.join_sources
		  	 		
		  	 		
		  	 		entity_fields_values = fields.join(field_entities, Arel::Nodes::OuterJoin)
		  	 				.on(
		  	 					site_entities[:id].eq(field_entities[:site_entity_id]).and(field_entities[:field_id].eq(fields[:id]))
		  	 				)
		  	 				.join_sources
		  	 		joins(:current_entity).joins(entity_fields).joins(entity_fields_values).where(["field_entities.value IS NULL OR field_entities.value = ?", "0"]).uniq
		  	 	end
	  	 	end
	  	 
	  	 end
	  	 
	  	 @@allow_site_entities = true
	  	 
	  	 def self.allow_site_entities?
	  	 	@@allow_site_entities
	  	 end
	  	 
	  	 def self.allow_site_entities(value)
	        @@allow_site_entities = value
	        
	        has_many :site_entities, :as => :site_entitable, :dependent => :destroy, :inverse_of => :site_entitable
	        
	        
	        
	        if @@allow_site_entities
	        		        	
	        	scope :site, proc { |site| joins(:site_entities).where(:site_entities => {:site_id => site }) }
	        	
	            
	            after_create :save_default_entity
	            
	        	has_many :sites, :through => :site_entities
	        	
	        	if self != TaxonomyTerm
	        		has_many :taxonomy_term_entities, :through => :site_entities, :dependent => :delete_all
	        	end
	        	
	        	attr_accessible :site_entities_attributes
	        	accepts_nested_attributes_for :site_entities, allow_destroy: true
	        	
	        	before_validation :set_default_site_entities
	        	validate :default_site_entities_exists
	        	
	        	has_one :default_entity, :as => :site_entitable, :class_name => "SiteEntity", :conditions => proc { "site_id = #{Site.default.id}" }
	        	
	        	has_one :current_entity, :as => :site_entitable, :class_name => "SiteEntity", :conditions => proc { "site_entities.site_id = #{Site.current.id}" }
	        		        	
	        	has_one :current_published_entity, :as => :site_entitable, :class_name => "SiteEntity", 
	        			:conditions => proc { "site_entities.site_id = #{Site.current.id} AND site_entities.status = '#{SiteEntity.published_status}'" }	        	
	        	
	        	#has_many :current_asset_entities, :class_name => "AssetEntity", :through => :site_entities, :foreign_key => :, :conditions => proc { "site_id = #{Site.current.id}" }
	        	
	        	has_many :field_entities, :through => :site_entities
	            has_many :fields, :through => :field_entities
	            
	            has_many :current_field_entities, :through => :current_published_entity, :class_name => "FieldEntity", :source => :field_entities
	            
	            has_many :current_taxonomy_term_entities, :through => :current_published_entity, :class_name => "TaxonomyTermEntity", :source => :taxonomy_term_entities
	           
	            
	            has_many :current_taxonomy_terms, :through => :current_taxonomy_term_entities, :class_name => "TaxonomyTerm", :source => :taxonomy_term
	        	
	        	if self != Asset
		        	has_many :asset_entities, :through => :site_entities, :dependent => :delete_all
	  	 			has_many :assets, :through => :asset_entities
	  	 			
	  	 				  	 			
	  	 			has_many :current_asset_entities, :through => :current_entity, :class_name => "AssetEntity", :source => :asset_entities
	  	 			
	  	 		
	  	 			has_many :images, :through => :asset_entities, :foreign_key => "asset_id"
	  	 		end

	  	 		
	        else
	        
	        	has_one :site_entity, :as => :site_entitable, :dependent => :destroy, :inverse_of => :site_entitable
	        	has_one :site, :through => :site_entity
	        	has_many :taxonomy_term_entities, :through => :site_entity, :dependent => :delete_all
	        	
	        	
	        	
	        	attr_accessible :site_entity_attributes
	        	accepts_nested_attributes_for :site_entity, allow_destroy: true
	        	
	        	before_validation :set_default_site_entity
	        	
	        	validate :default_site_entity_exists
	        	
	        	if self != Asset
		        	has_many :asset_entities, :through => :site_entity, :dependent => :delete_all
	  	 			has_many :assets, :through => :site_entity  
	  	 			has_many :images, :through => :site_entity, :foreign_key => "asset_id"
	  	 		end
	        end
	        
	        has_many :taxonomy_terms, :through => :taxonomy_term_entities
	        has_many :taxonomies, :through => :taxonomy_terms
	        
	        
	        delegate :published?, :to => :current_entity, :prefix => false, :allow_nil => true
	        
	        
	        delegate :slug, :to => :current_entity, :prefix => false, :allow_nil => true
	        
	        
	        scope :by_status, proc { |status| joins(:site_entities).where(:site_entities => {:status => status }) }
	        	
	        scope :published, proc { joins(:site_entities).where(:site_entities => {:status => SiteEntity.published_status}) }
	        	
	        scope :by_term, proc { |term| 
	        	joins(:taxonomy_term_entities)
	        	.joins("INNER JOIN site_entities tt_se ON tt_se.id = taxonomy_term_entities.site_entity_id")
	        	.where(:taxonomy_term_entities => {:taxonomy_term_id => term }).where("tt_se.site_id = #{Site.current.id}") 
	        }
     
	        
         end
         
         
         
	  	 class_eval do
	  	 	
	  	 	
	  	 	
	  	 	def self.find_by_id_or_slug(id_or_slug)
	  	 		joins(:site_entities)
	  	 		.where(["(site_entities.slug = ? AND site_entities.slug IS NOT NULL) OR #{self.table_name}.id = ?",id_or_slug,id_or_slug])
	  	 		.limit(1)
	  	 		.order(sanitize_sql_array(["site_entities.slug = ? ASC",id_or_slug]))
	  	 	
	  	 	end
	  	 	
	  	 	def self.available_by_letter
				trim_name = "substr(upper(trim(#{self.table_name}.name)), 1,1)"
	  	
				select("#{trim_name} as letter")
				.joins(:site_entities)
				.group(trim_name)
			end
			
			def self.published()
				joins(:current_published_entity)
			end
			
			
			
			def self.object_fields
				Field.joins(:field_objects).where(:field_objects => {:object => self.name}, :fields => {:site_id => [0, Site.current.id]})
			end
			
			def self.by_field(field,value)
				joins(:site_entities => {:field_entities => :field })
				.where(:site_entities => {:site_id => Site.current.id}, :field_entities => {:value => value}, :fields => {:name => field})
				.group("#{self.table_name}.id")
			end
			
	  	 end
      end
	  
	  
	  def initialized_site_entities
	  	#ap site_entities
	  	@initialized_site_entities ||= [].tap do |o|
	  		Site.active.find_each do |site|
		  		if se = site_entities.find { |se| se.site_id == site.id }
		  			o << se.tap { |se| se.enable ||= true }
		  		else
		  			o << site_entities.build({:site => site})
		  		end
		  	end
	  	end
	  end
	
	def current_asset_by_key(key = nil)
		
		_asset = current_asset_entities.includes(:asset).by_key(key) unless current_asset_entities.nil?
		img = _asset.first unless _asset.nil?
		img
		#img = current_entity.assets.by_key(key).first unless current_entity.nil?
		#img ||= default_entity.asset_entities.includes(:asset_size).by_key(key).first unless default_entity.nil?
	end
	
	def current_assets_by_key(*keys)

		@current_assets = nil
		@current_assets ||= begin
			#current_entity.asset_entities.includes(:asset_size, :asset => [:asset_versions]).by_key(keys).any? ? current_entity.asset_entities.includes(:asset_size, :asset => [:asset_versions]).by_key(keys) : default_entity.asset_entities.includes(:asset_size, :asset => [:asset_versions]).by_key(keys)
			_scope = self.current_entity.asset_entities.includes(:asset).send(:by_key,*keys)
			
			
			_scope
		end
		#@current_assets ||= current_entity.assets.by_key(keys)
		
	end
	
	def object_fields
		self.class.object_fields
	end
	
	
	def available_sites
		  Site.active().excluding_ids(self.sites.map{|site| site.id})
  	end
  	
	def current_image(key = nil)
		self.current_asset_by_key(key)
	end
	
	def current_related_entities(klass = nil)
		current_entity.related_entities.any? ? current_entity.related_entities : default_entity.related_entities
	end
	
	def current_published_related_entities()
		current_entity.related_entities.published().any? ? current_entity.related_entities.published() : default_entity.related_entities.published()
	end
	
	def featured?
		current_entity.fields
	end
	
	def field(field)
		current_entity.send("field_#{field}")
	end
	
	
	
	
	Field.find_each do |attr|
  	
	  	define_method("field_#{attr.name}") do
	    	field_value = current_entity.field_entities.find_by_field_id(attr.id) unless current_entity.nil?
	    	field_value ||= default_entity.field_entities.find_by_field_id(attr.id) unless default_entity.nil?
	    
			field_value.value unless field_value.nil? || field_value.value.empty?
	    #(send(attr) || Date.today).strftime('%b %d, %Y')
		end   
		
  #define_method("#{attr}_human=") do |date_string|
  #  self.send "#{attr}=", Date.strptime(date_string, '%b %d, %Y')
  #end
  end unless !Field.table_exists?
	 
	 private
	 	def save_default_entity
	 		_current_entity = site_entities.detect {|s| s.site == Site.current && !s.site.default?}
	 		
	 		current_entity.build_and_save_default() unless _current_entity.nil?
	 		
	 	end
	 	
	 	def set_default_site_entities
	 		
	 		self.site_entities.build([{:site => Site.default}]) unless self.site_entities.any?{ |s| s.site == Site.default()}
	 		
	 	end
	 	
	 	def set_default_site_entity
		 	build_site_entity(:site => Site.default, :status => SiteEntity.published_status) if self.site_entity.nil?
		end
	  	
	  	def default_site_entity_exists
	  	
	  		errors.add(:site_entity, "#{self.class.name} must have default site") if self.site_entity.nil?
	  	
	  	end
	  	
	  	def default_site_entities_exists
	  		
	  		errors.add(:site_entities, "#{self.class.name} must have default site") unless self.site_entities.any?{ |s| s.site == Site.default()}	
	  	end
	end
end