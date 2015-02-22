#Quick drop all, create, and seed task
task :recreate do
	desc "Quick drop all, create, and seed task"
	Rake::Task['db:drop'].invoke
	Rake::Task['db:create'].invoke
	Rake::Task['db:migrate'].invoke
	
	Rake::Task['db:seed'].invoke

end