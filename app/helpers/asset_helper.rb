module AssetHelper
	
	def build_asset_source_path(asset_path, asset_version = nil, asset_id, site_id)
		
		ap ImageUploader
	
	end

	def render_asset(asset, key, options = {})
		
		return if asset.nil?
		
		base = admin? ? "admin/" : ""
		
		options[:dimensions] ||= false
		
		if options[:dimensions] && ( version = asset.version(key) )
			
			dimensions = version.dimensions
			
			if !options[:height].nil? && options[:height] && options[:width].nil?
				dimensions[:height] = options[:height]
				dimensions[:width] = (options[:height].to_f / version.ratio).to_i
			end
			
			if !options[:width].nil? && options[:width] && options[:height].nil?
				dimensions[:width] = options[:width]
				dimensions[:height] = (options[:width].to_f * version.ratio).to_i
			end
			options.merge!(dimensions)
			#if(version)
				#options.merge!(version.dimensions)
			#end
		end
		
		options.delete(:dimensions)
		
		begin render(:partial => "#{base}shared/assets/#{asset.class.to_s.underscore}_asset", :locals => {:key => key, :asset => asset, :options => options})
		
		rescue
			render(:partial => "shared/assets/image_asset", :locals => {:key => key, :asset => asset, :options => options})
		end
		
	end
	
	def render_admin_asset(asset, key = :thumb, options = {:data => { :files => asset.to_jq_upload.to_json, :dismiss => "modal" }})
		render_asset(asset, key, options)
	end
	
	def render_asset_thumb(asset, key = :thumb, options = {})
		base = admin? ? "admin/" : ""
		begin render(:partial => "#{base}shared/assets/#{asset.class.to_s.underscore}_asset_thumb", :locals => {:asset => asset, :key => key, :options => options})
		
		rescue
			render(:partial => "shared/assets/image_asset_thumb", :locals => {:asset => asset, :key => key, :options => options})
		end
	end
	
	def render_admin_asset_thumb(asset, key = :thumb, options = {})
		render_asset_thumb(asset, key, options)
		#render(:partial => "admin/shared/assets/#{asset.class.to_s.underscore}_asset_thumb", :locals => {:asset => asset, :options => options})
	end
	
	def cache_key_for_asset(asset, key = nil)
		key ||= "#{controller_name}-#{action_name}"
		updated_at = asset.updated_at.try(:utc).try(:to_s, :number)
    	"assets/#{current_site.id}-#{key}-#{asset.id}-#{updated_at}"
    end
	
end
