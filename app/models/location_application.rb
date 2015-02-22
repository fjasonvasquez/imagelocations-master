class LocationApplication < ActiveRecord::Base
  apply_simple_captcha :add_to_base => true
  
  validates :terms_of_service, acceptance: { accept: '1' }
  
  IMAGES_LIMIT = 5
  
  belongs_to :site
  
  scope :site, proc { |s| where(:location_applications => {:site_id => s})}
  
  attr_accessor :full_validation
  attr_accessor :images
  attr_accessor :international_phone
  attr_accessor :captcha_key, :captcha
  
  attr_accessible :status, :location_application_images_attributes, :images, :state, :city, :name, :email, :phone, :notes, :usage, :exclusive, :ip, :listing
  
  
  attr_accessible :international_phone, :international_address, :site_ids, :terms_of_service, :address, :postcode
  
  attr_accessible :captcha_key, :captcha
  
  serialize :usage, Array
  serialize :exclusive, Array
  serialize :listing, Array
  
  geocoded_by :full_address
  after_validation :geocode, :if => proc { |l| l.address_field_changed? && l.has_address?}
  
  has_many :location_application_images, :dependent => :destroy
  
  belongs_to :site
  belongs_to :user
  
  has_and_belongs_to_many :sites
  
  accepts_nested_attributes_for :location_application_images
  
  #validates_presence_of :images, :if => proc {|la| la.location_application_images.blank? }
  
  validates_presence_of :site, :email, :name
  
  validates_presence_of :phone, :if => proc {|la| la.international_phone.blank? }
  
  validates_presence_of :city, :state, :postcode, :address, :if => proc { |la| la.international_address.blank? }
  
  validates :email, :format => { :with => %r{.+@.+\..+} }, :allow_blank => false
  
  validate :full_error_validation, :if => proc {|la| la.full_validation }
  
  validate :check_images_count
  
  before_validation :set_site
  
  before_validation :set_images
  
  after_validation :set_images_errors
  
  after_validation :set_international_phone
  
  
  def set_international_phone
  	
  	self.phone = international_phone if phone.blank? && !international_phone.blank?
  
  end
  
  def full_error_validation
  	#self.errors.add(:address, "can't be blank") if address.blank?
  	self.errors.add(:usage, "Please select usage") if usage.empty?
	self.errors.add(:listing, "Please select a listing") if listing.empty?
	#self.errors.add(:sites, "Please select a site") if sites.empty?
  end
  
  
  def full_address
  
  
  end
  
  def address_field_changed?
  	
  	self.address_changed? || self.postcode_changed? || self.city_changed? || self.state_changed?
  end
  
  def has_address?
  	
  	self.address? || self.postcode? || self.city? || self.state?
  end
  
  def usage
  
  	self[:usage]
  
  end
  
  def check_images_count
  	
  	_count = 0
  	 	
  	_count += images.count unless images.nil?
   	
  	_count += location_application_images.count unless location_application_images.nil?

  	errors.add(:images, "Please limit images to #{IMAGES_LIMIT}") if _count > IMAGES_LIMIT

  end
  
  def set_site
  	self.site ||= Site.current
  end
   
  def set_images
  	
  	unless images.nil?
  		images.each do |image|
  			
  			location_application_images << LocationApplicationImage.new(:source => image)
  		
  		end
  	
  	end
  	
  end
  
  def set_images_errors
  	_errors = []
  	location_application_images.each do |image|
  		image.errors.each do |attribute, error|
  		
  			errors.add(:images, error)
  		end
  		
  	end
  	
  end
  
  
end
