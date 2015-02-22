require 'bundler/capistrano'

set :whenever_command, "bundle exec whenever"
require 'whenever/capistrano'


default_run_options[:pty] = true

set :domain, 'il.geosith.com'
set :applicationdir, "/srv/www/il.geosith.com/imagelocations"

#set :application, "set your application name here"


# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :user, "mailoarsac"
set :scm_passphrase, "ping1234"

set :scm, 'git'
set :repository,  "https://github.com/arsac/imagelocations.git"
set :git_enable_submodules, 1 # if you have vendored rails
set :branch, 'master'
set :git_shallow_clone, 1
set :scm_verbose, true

set :deploy_via, :remote_cache
set :deploy_to, applicationdir

set :ssh_options, { :forward_agent => true, :port => 22221 }

# roles (servers)
role :web, domain
role :app, domain
role :db,  domain, :primary => true
# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
end