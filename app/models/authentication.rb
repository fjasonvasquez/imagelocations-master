class Authentication < ActiveRecord::Base
  attr_accessible :user, :provider, :access_token, :uid
  belongs_to :user
  
  validates_presence_of :user, :provider, :access_token
  
  
  def provider_name
  	provider.titelize
  end
  
  
end
