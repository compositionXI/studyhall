set :stages, %w(production staging)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

set :application, "set your application name here"
set :repository,  "git@intridea.unfuddle.com:intridea/studyhall.git"

set :scm, :git

set :user, "www-data"
set :group, "www-data"

set :deploy_via, :remote_cache
set :deploy_to, "/var/www/#{application}"
set :deploy_env, 'production'

#role :web, "your web-server here"                          # Your HTTP server, Apache/etc
#role :app, "your app-server here"                          # This may be the same as your `Web` server
#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
