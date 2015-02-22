class RegionCondition < ActiveRecord::Base
  attr_accessor :enable
  
  attr_accessible :id, :region_id, :type, :value, :enable
  
  
  def self.condition_join_statement
  	clause = [].tap { |o|
  		
  		self.subclasses.each do |s|
  			o << "(#{s.send(:condition_join)})" if s.respond_to?(:condition_join)
  		end
  	}.join(" OR ")
  	"LEFT JOIN region_conditions ON #{clause} INNER JOIN regions ON region_conditions.region_id = regions.id" unless clause.blank?
  	
  end
  
  
  def self.condition_join
  	
  end
end
