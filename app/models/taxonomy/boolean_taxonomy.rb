class BooleanTaxonomy < Taxonomy  
  attr_accessible :taxonomy_term
  
  has_one :taxonomy_term, :foreign_key => :taxonomy_id
  
  #after_initialize :set_true_term
  
  before_create :set_true_term
  #validate :true_term_exists
  
  def can_add_terms?
  	taxonomy_terms.count < 1
  end
  
  def self.model_name
    Taxonomy.model_name
  end

  private
  	def set_true_term
  		build_taxonomy_term(:name => self.name) if self.taxonomy_term.nil?
  		
  		self.taxonomy_term.name = self.name
  		
  		self.taxonomy_term.save! unless self.taxonomy_term.new_record?
  		
  	end

end