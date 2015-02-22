module CollectionsHelper
	def pdf_file_download_path(collection)
		
		download_collections_path(:collection => { :name => collection.name, :asset_entity_ids => collection.asset_entity_ids} ,:format => :pdf, :only_path => false)
	end
	
	
	def collection_from_location_and_images_path(location, images)
	
		_collection = Collection.new :name => location.name, :asset_entity_ids => images.collect {|i| i.id }
		pdf_file_download_path(_collection)
	end
	
	def flatten_hash(hash = params, ancestor_names = [])
    flat_hash = {}
    hash.each do |k, v|
      names = Array.new(ancestor_names)
      names << k
      if v.is_a?(Hash)
        flat_hash.merge!(flatten_hash(v, names))
      else
        key = flat_hash_key(names)
        key += "[]" if v.is_a?(Array)
        flat_hash[key] = v
      end
    end
    
    flat_hash
  end
  
  def flat_hash_key(names)
    names = Array.new(names)
    name = names.shift.to_s.dup 
    names.each do |n|
      name << "[#{n}]"
    end
    name
  end
  
  def hash_as_hidden_fields(hash = params)
    hidden_fields = []
    flatten_hash(hash).each do |name, value|
      value = [value] if !value.is_a?(Array)
      value.each do |v|
        hidden_fields << hidden_field_tag(name, v.to_s, :id => nil)          
      end
    end
    
    hidden_fields.join("\n").html_safe
  end
			
end
