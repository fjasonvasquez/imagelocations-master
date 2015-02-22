class WeddingestatesHomeController < HomeController
  has_scope :site
  caches_action :index, :expires_in => 5.minutes, :cache_path => Proc.new { |c| c.params.merge({:user_signed_in => c.user_signed_in?, :user_is_subscribed => c.user_is_subscribed?}).delete_if { |k,v| k.starts_with?('utm_') || k.starts_with?('per_page') } }, :if => Proc.new { !request.ssl? }
  

  
  def index
      @front_entities = apply_scopes(BannerEntity).published().by_section(:regions).includes(:banner_entity_site_entities => :site_entity)
      
      @home_slideshow_entities = apply_scopes(LocationBannerEntity).published().by_section(:home_slideshow).includes(:banner_entity_site_entities => :site_entity)
      
  end
  
end
