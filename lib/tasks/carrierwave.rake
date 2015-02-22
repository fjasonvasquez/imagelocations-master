namespace :carrierwave do
	desc "Update Assets"
	task :dimensions => :environment do
		Asset.find_each do |a|
			if a.source.present? && a.source.file.exists? && (a.height.zero? || a.width.zero?)
				a.send(:update_asset_dimensions)
				a.save!
			end
		end
	end
	
	namespace :banners do
		task :regenerate => :environment do
			BannerEntitySiteEntity.where(["banner_entity_site_entities.banner IS NOT NULL"]).find_each do |be|
				be.banner.recreate_versions!()
			end
		end
	
	end
	
	namespace :covers do
		task :regenerate => :environment do
			Tear.where(["tears.cover IS NOT NULL"]).find_each do |tear|
				begin
					tear.cover.recreate_versions!()
				rescue
					print "Cover for #{tear.id} could not be regenerated\n"
				end
			end
		end
	end

	
	namespace :versions do
	
		task :unprocess => :environment do
			AssetVersion.unprocess_all
		end
		
		
		
		task :unprocess_site, [:namespace, :key] => :environment do |t, args|
			
			site = Site.find_by_namespace(args[:namespace])
			key = args[:key] || nil
			
			_where = {:site_id => site.id }
			
			unless key.nil?
				_where[:key] = key
			
			end
			
			_scope = AssetVersion.joins(:asset_size).where(:asset_sizes => _where)
			
			_scope.update_all( "processed = 'f', height = 0, width = 0" )
			
			
		end
		
		
		task :list, [:site_id]  => [:environment] do |t, args|
			site_id = args[:site_id] || nil
			
			site = Site.find(site_id)
			
			versions = AssetVersion.unprocessed().includes(:asset).includes(:asset_size).where( :asset_sizes => { :site_id => site } )
			
			puts("#{versions.count} versions are waiting to be processed")
		end
		
		task :generate, [:site_id]  => [:environment] do |t, args|
			site_id = args[:site_id] || nil
			
			site = Site.find(site_id)
			
			versions = AssetVersion.unprocessed().includes(:asset).includes(:asset_size).where( :asset_sizes => { :site_id => site } )
			_processed = 0
			versions.find_each do |v|
				v.process
				_processed += 1
			end
			
			puts("#{_processed} versions were processed")
		end
	end
	
	task :remove_orphans => :environment do
		orphans = AssetEntity.find(:all, :include => :asset, :conditions => ["assets.id IS NULL"])
		
		orphans.each do |ae|
			ae.destroy		
		end
		
		puts("#{orphans.count} were found and removed")
	end
	
	
	
end