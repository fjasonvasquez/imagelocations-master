class Publication < ActiveRecord::Base
  attr_accessible :name, :cover, :remove_cover, :publication_category_id
  
  mount_uploader :cover, CoverUploader
  
  has_many :tears, :order => "tears.name ASC"
  
  belongs_to :publication_category
  
  validates_presence_of :name
  
  scope :has_tears, proc { joins(:tears).where("tears.id IS NOT NULL").group("publications.id")}
  
  scope :order_by_category, proc { joins("LEFT JOIN publication_categories on publication_categories.id = publications.publication_category_id").select("publications.*, CASE WHEN publications.publication_category_id IS NOT NULL THEN 0 ELSE 1 END AS has_category, CASE WHEN publications.publication_category_id IS NOT NULL THEN 0 ELSE 1 END AS has_category").order("has_category ASC, publication_categories.name ASC, name ASC")}
  
  
  def cover_image_url(version = nil)
  	begin
  		cover_url(version) || tears.newest().first.cover_url(version)
  	end
  end
  
  
  
  def fullname
	 _name = name
	 
	 unless publication_category.nil?
		 
		 _name = "#{publication_category.name}: #{_name}"
     end
	_name
  end
  
end
