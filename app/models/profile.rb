class Profile < ActiveRecord::Base
	#include Gravatar Feature
	include Gravtastic
	gravtastic
	
	belongs_to :user, :inverse_of => :profile
	
	belongs_to :company, :counter_cache => true
	
	attr_accessible :first_name, :last_name , :company, :company_id

	attr_accessible :avatar, :remove_avatar
	
	mount_uploader :avatar, AvatarUploader
	
	
	delegate :email, :to => :user
	
	after_destroy :remove_user_assets
	
	validates_presence_of :first_name
	validates_presence_of :last_name
	
	#has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"

	#image_url
	
	def remove_user_assets
		store_dir = avatar.store_dir
		#super
		ap ActionController::Base.helpers.asset_path store_dir
		#remove_generic_image!
		FileUtils.remove_dir("#{Rails.root}/#{store_dir}", :force => true)
	end
end