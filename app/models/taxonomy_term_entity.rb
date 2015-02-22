class TaxonomyTermEntity < ActiveRecord::Base
  
  attr_accessor :name, :enable
  
  attr_accessible :site_id, :taxonomy_term_id, :site_entity, :site_entity_id, :taxonomy_term
  attr_accessible :enable, :taxonomy, :taxonomy_id, :taxonomy_term_attributes
  
  belongs_to :site_entity, :inverse_of => :taxonomy_term_entities
  belongs_to :taxonomy_term, :autosave => true, :inverse_of =>:taxonomy_term_entities
  
  has_one :site, :through => :site_entity
  has_one :taxonomy, :through => :taxonomy_term
  
  before_create :set_taxonomy_term
  
  delegate :name, :to => :taxonomy_term, :allow_nil => false
  
  accepts_nested_attributes_for :taxonomy_term, allow_destroy: false
  
  scope :by_site, lambda { |site| where({:site => site}) unless site.nil? }
  

  def name=(value)
  	
  	self.taxonomy_term = build_taxonomy_term(:name => value, :taxonomy => taxonomy) if self.taxonomy_term.nil?
  	self.taxonomy_term.save! if self.taxonomy_term.id.nil?
  end
  
  def autosave_associated_records_for_taxonomy_term
  	
    if existing_term = taxonomy_term.taxonomy.taxonomy_terms.find_by_name(taxonomy_term.name)
      self.taxonomy_term = existing_term
    else
      self.taxonomy_term.save!
    end
  end
  
  def set_taxonomy_term
  	self.taxonomy_term_id ||= self.taxonomy_term.id
  end
  

end
