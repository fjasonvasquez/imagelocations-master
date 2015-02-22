class ImagelocationsHomeController < HomeController
  has_scope :site
  caches_action :index, :cache_path => Proc.new { |c| c.params.delete_if { |k,v| k.starts_with?('utm_') || k.starts_with?('per_page') } }
  
  
  
  def index
      @spotlight_entities = apply_scopes(LocationBannerEntity).published().by_section(:featured_locations).includes(:banner_entity_site_entities => :site_entity)

  	  
  	  @tear_entity = apply_scopes(BannerEntity).published().by_section(:featured_tear).first
  	  
	  @body_entities = apply_scopes(BannerEntity).published().by_section(:home).page(params[:page]).per(params[:per_page])

  end
  
end
