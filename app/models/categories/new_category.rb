class NewCategory < Category
	
	
	# def locations
# 		Location.order("locations.created_at DESC").limit(10)
# 	end
# 	
# 	
# 	def self.category_join(scope)
# 		l = Arel::Table.new(:locations, :as => "new_locations")
# 		se = Arel::Table.new(:site_entities, :as => "new_locations_entities")
# 		
# 		ago = (DateTime.now - 1.month).to_formatted_s(:db)
# 		
# 
# 		#ap arel_table.join(l.join(se).on(se[:site_entitable_id]),Arel::Nodes::OuterJoin).on(l[:id]).join_sql
# 		#ap arel_table[:id]
# 		#ap self
# 		#"LEFT OUTER JOIN site_entities AS #{se.table_alias} ON #{se.table_alias}.site_entitable_type = 'Location' AND #{se.table_alias}.created_at > '#{ago}'"
# 		#inner join categories on themselves
# 		"LEFT OUTER JOIN categories"
# 		nil
# 	end
	
	def self.category_where
  		#"categories.type = 'NewCategory'"
	end 
    
    def is_special?
  	true
  end  
end
