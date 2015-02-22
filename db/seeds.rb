#Fill permissions from rake task
Rake::Task['purge_media'].invoke
Rake::Task['permissions:setup'].invoke


Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each { |seed| load seed }

# Sites







