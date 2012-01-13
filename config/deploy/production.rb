set :whenever_environment, defer { production } 
set :deploy_env, 'production' 
set :rails_env, 'production' 
set :bundle_without, [:development, :test] 
server "app01.c45577.blueboxgrid.com", :app, :web, :db, :primary => true 
