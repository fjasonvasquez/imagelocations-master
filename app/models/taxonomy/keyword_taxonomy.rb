class KeywordTaxonomy < Taxonomy  
  
  def self.model_name
    Taxonomy.model_name
  end
  
  def has_terms?
  	true
  end
  
   def initialized_entity_taxonomy_terms(site_entity)	 			
    entity = site_entity.needs_dup? ? site_entity.entity_dup : site_entity
    
    [].tap do |o|
        entity.taxonomy_term_entities.each do |tte|
        	
        	if !tte.taxonomy_term.nil? && tte.taxonomy_term.taxonomy_id == self.id
 
        		o << tte.tap do |te| 
        			te.id = nil if site_entity.needs_dup?
        			te.site_entity = site_entity
        			te.enable ||= true 
        		end
        	end
        end
    end
  end
  
end