class TaxonomyTerm < ActiveRecord::Base
  
  include EntityMethods::Model
  allow_site_entities true
  
    
  attr_accessible :taxonomy_term_id, :taxonomy_id, :name, :taxonomy

  has_many :taxonomy_term_entities, :dependent => :delete_all, :inverse_of => :taxonomy_term
  
  has_many :taxonomy_term_entities_site_entities, :through => :taxonomy_term_entities, :source => :site_entity
  
  has_many :locations, :through => :taxonomy_term_entities_site_entities, :source_type => "Location", :source => :site_entitable
  #has_many :asset_entities, :as => :asset_entitable, :dependent => :delete_all
  #has_many :assets, :through => :asset_entities
  
  #belongs_to :parent, :class_name => "TaxonomyTerm"
  #has_many :taxonomy_terms, :foreign_key => "parent_id"
  
  belongs_to :taxonomy, :inverse_of => :taxonomy_terms, :touch => true

  #accepts_nested_attributes_for :asset_entities, allow_destroy: true
  
  #before_validation :set_taxonomy_term_label_or_name
  
  scope :by_taxonomy, proc {|tax| joins(:taxonomy).where("taxonomies.id = ?",tax)}
  
  
  
  validates :name, :presence => true
  #validates :label, :presence => true
  validates :taxonomy, :presence => true
  validates_associated :taxonomy
  
  
  def self.search(string)
  	condition = ["%" + string.downcase.gsub(" ","%") + "%"]
  	where("LOWER(taxonomy_terms.name) LIKE ?",condition).order("taxonomy_terms.name ASC")
  	
  end
  
  def self.available_by_letter
  	trim_name = "substr(upper(trim(taxonomy_terms.name)), 1,1)"
  	
  	select("#{trim_name} as letter")
  	.joins(:taxonomy)
  	.joins(:site_entities)
  	.group(trim_name)
  end
  
  def self.current_entity_terms(type, ids)
  	type = type.name
  	joins(:taxonomy).joins(:taxonomy_term_entities).joins("INNER JOIN site_entities s2 ON 
  			s2.site_entitable_type = '#{type}' 
  			AND s2.id = taxonomy_term_entities.site_entity_id
  			AND s2.status = '#{SiteEntity.published_status}'
  			AND s2.site_id = #{Site.current.id}").where("taxonomies.public = 1 AND s2.site_entitable_id IN (?)", ids)
  
  end
  
  
  def available_taxonomies
  	[].tap do |o|
		Taxonomy.all.each do |t|
			if (!taxonomy.nil? && t == taxonomy) || t.can_add_terms?
				o << t
			end
		end
	end
  end
  
    
  
  
end
