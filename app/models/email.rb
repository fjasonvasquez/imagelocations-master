class Email

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
	
  attr_accessor :user, :name, :sender, :recipient, :cc, :bcc, :subject, :body
  
  validates :name, :sender, :recipient, :subject, :body, :presence => true
  
  validates :sender, :recipient, :cc, :bcc, :format => { :with => %r{.+@.+\..+} }, :allow_blank => true
  
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def user=(user)
  	@user = user
  end
  
  
  def persisted?
    false
  end
end


