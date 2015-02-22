module TaxonomyTermsHelper
	def taxonomy_filter_options
		{}.tap { |o| Taxonomy.has_terms.all.each.map {|tax| o.merge!({tax.id.to_s => tax.name})} }
	end
	def cache_key_for_taxonomy_terms
		count = TaxonomyTerm.count
    	max_updated_at = TaxonomyTerm.maximum(:updated_at).try(:utc).try(:to_s, :number)
    	"taxonomy_terms/#{current_site.id}-all-#{count}-#{max_updated_at}"
    end
end
