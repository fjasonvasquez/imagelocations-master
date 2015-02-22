module PermitsHelper
	def cache_key_for_permits
		count = Permit.count
    	max_updated_at = Permit.maximum(:updated_at).try(:utc).try(:to_s, :number)
    	"permits/#{current_site.id}-all-#{count}-#{max_updated_at}"
    end
end
