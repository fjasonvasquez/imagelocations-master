class Company < ActiveRecord::Base
  attr_accessible :name, :logo, :remove_logo
  mount_uploader :logo, LogoUploader
  
  has_many :projects
  has_many :profiles
  has_many :users, :through => :profiles
  
  
  scope :has_project, joins(:projects).where("projects.id IS NOT NULL")
  scope :has_users, joins(:profiles).where("profiles.id IS NOT NULL")
  
  validates :name, :presence => true
end
