class Project < ActiveRecord::Base
    
  include EntityMethods::Model
  allow_site_entities true
  
  belongs_to :company, :counter_cache => true, :touch => true
  
  attr_accessible :name, :company, :company_id
  
  validates_presence_of :name
  
  scope :by_company, proc {|company| joins(:company).where("companies.id = ?", company)}
  
  
  def self.available_by_letter
	trim_name = "substr(upper(trim(#{self.table_name}.name)), 1,1)"

	select("#{trim_name} as letter")
	.joins(:site_entities)
	.joins(:company)
	.group(trim_name)
  end
  
  
  def self.search(string)
  	condition = ["%" + string.downcase.gsub(" ","%") + "%"]
  	where("LOWER(projects.name) LIKE ?",condition)  	
  end
end
