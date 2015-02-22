module TaxonomiesHelper
	def term_taxonomies
		[].tap do |o|
			Taxonomy.all.each do |t|
				o << t if t.can_add_terms?
			end
		end	
	end

end
