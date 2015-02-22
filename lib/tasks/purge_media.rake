#Quick drop all, create, and seed task
task :purge_media =>  :environment do
	desc "Purge images created by carrierwave"
	
	dir = "#{Rails.root}/app/uploaders"	 
	Dir.glob(File.join(dir, "**", "*.rb")) do |uploader|
		if uploader =~ /_uploader/
			class_name = uploader.gsub("#{dir}/","").gsub(".rb","").camelize.constantize
			full_path = "#{Rails.public_path}/#{class_name.store_dir}/*"
			FileUtils.rm_rf(Dir.glob(full_path))
			
		end
	end
end

