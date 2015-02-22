module CarrierWave
  module RMagick

    def quality(percentage)
      manipulate! do |img|
        img.write(current_path){ self.quality = percentage } unless img.quality == percentage
        img = yield(img) if block_given?
        img
      end
    end

  end
end



CarrierWave.configure do |config|
  config.permissions = 0777
  config.directory_permissions = 0777
  config.storage = :file
end