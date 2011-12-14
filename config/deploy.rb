set :stages, %w(production staging)
set :default_stage, "staging"

require 'capistrano/ext/multistage'
require 'bundler/capistrano'

set :whenever_environment, defer { stage }
require "whenever/capistrano"

set :application, "StudyHall"
set :repository,  "git@intridea.unfuddle.com:intridea/studyhall.git"

set :scm, :git
set :scm_username, 'brent'

set :user, "deploy"
#set :group, "www-data"

set :keep_releases, 5
set :deploy_via, :remote_cache
set :deploy_to, "/home/deploy/rails_apps/#{application}"

# Set up SSH key forwarding
set :ssh_options, { :forward_agent => true }
before "deploy", "deploy:setup_ssh"


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

namespace :deploy do
  desc "shell out and setup the keys so they can be forwarded"
  task :setup_ssh, :except => { :no_release => true } do
    `ssh-add`
  end

  desc "symlink config files and the solr/ directory"
  task :symlinkconfigs, :roles => :app do
    run <<-CMD
      ln -s #{shared_path}/system/database.yml #{release_path}/config/database.yml
    CMD
    run <<-CMD
      ln -s #{shared_path}/system/s3.yml #{release_path}/config/s3.yml
    CMD
    run <<-CMD
      rm -rf #{release_path}/solr && ln -s #{shared_path}/system/solr #{release_path}/solr
    CMD
  end
  after "deploy:symlink", "deploy:symlinkconfigs"

  namespace :solr do
    desc "Stop solr"
    task :stop, :roles => :app do
      run <<-CMD
        cd #{deploy_to}/current && #{rake} sunspot:solr:stop RAILS_ENV=#{rails_env}
      CMD
    end
    desc "Start solr"
    task :start, :roles => :app do
      run <<-CMD
        cd #{deploy_to}/current && #{rake} sunspot:solr:start RAILS_ENV=#{rails_env}
      CMD
    end

    before "deploy:update_code","deploy:solr:stop"
    after "deploy:symlinkconfigs","deploy:solr:start"
  end
end
