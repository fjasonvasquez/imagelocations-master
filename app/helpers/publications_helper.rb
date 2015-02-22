module PublicationsHelper
	def cache_key_for_publications
    	count = Publication.count
		max_updated_at = Publication.maximum(:updated_at).try(:utc).try(:to_s, :number)
		"publications/#{current_site.id}-all-#{count}-#{max_updated_at}"
  end
end
