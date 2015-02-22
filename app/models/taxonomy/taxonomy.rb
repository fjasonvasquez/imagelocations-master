class Taxonomy < ActiveRecord::Base
  attr_accessible :type, :name, :class, :taxonomy_term
  attr_accessible :priority, :public, :taxonomy_term_entities, :taxonomy_terms_attributes
  
  has_many :taxonomy_terms, :inverse_of => :taxonomy, :dependent => :delete_all
  
  has_many :taxonomy_term_entities, :through => :taxonomy_terms
  
  accepts_nested_attributes_for :taxonomy_terms, :allow_destroy => true
  
  scope :has_terms, proc {|tax| includes(:taxonomy_terms).where("taxonomy_terms.taxonomy_id IS NOT NULL")}
  
  
  default_scope order(:priority)
  
  #validates_presence_of :label
  validates_presence_of :name
  validates_presence_of :type
  
  validates :name, :uniqueness => { :case_sensitive => false, :message => "This name is taken already"}
  
  def initialized_entity_taxonomy_terms(site_entity)	 			
    entity = site_entity.needs_dup? ? site_entity.entity_dup : site_entity
    @initialized_entity_taxonomy_terms ||= [].tap do |o|
    	#unless entity.new_record?
    		#ap entity.taxonomy_term_entities.where(:taxonomy_term_id => taxonomy_term_ids)
    		#ap entity.taxonomy_term_entities
    		#entity_tt = entity.taxonomy_term_entities.where(:taxonomy_term_id => taxonomy_term_ids)
    	#else
    		#ap entity_tt
    	
    	#end
    	
        taxonomy_terms.order_by(:name,"asc").each do |term|
        	if  tte = entity.taxonomy_term_entities.find { |te| te.taxonomy_term_id == term.id }
        		
        		o << tte.tap do |tte| 
        			tte.id = nil if site_entity.needs_dup?
        			tte.site_entity = site_entity
        			tte.enable ||= true 
        		end
        		
        	else
        		o << entity.taxonomy_term_entities.new({:taxonomy_term => term})
        	end
        end
    end
  end
  
  def has_terms?
  	!taxonomy_terms.empty?
  	#!taxonomy_terms.nil?	
  end
  
  def type_name
  	self.class.taxonomy_type
  end
  
  def can_add_terms?
  	true
  end
  
  def self.taxonomy_type
  	self.name.sub("Taxonomy","")
  end
  
  def self.public
  	where(:public => 1)
  end
  
  def self.taxonomy_types
  	{}.tap do |o|
  		Taxonomy.send(:subclasses).each do |t|
  		
  			o[t.name.sub("Taxonomy","")] = t.name
  		end
  	
  	end
  end
  
  def initialized_entity_taxonomy_term(entity)
	  entity.taxonomy_term_entities.includes(:taxonomy).where(:taxonomies => {:id => self.id}).first() || entity.taxonomy_term_entities.new(:site_entity => entity)
  end
  
  private
  	def set_taxonomy_name_or_label
  		
  		self.name ||= self.label.underscore unless self.label.nil?
  		
  		self.label ||= self.name.titleize unless self.name.nil?
  	
  	end
end
