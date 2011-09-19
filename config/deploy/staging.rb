set :deploy_env, 'staging'

server "stage01.45469.blueboxgrid.com", :app, :web, :db, :primary => true 
