set :deploy_env, 'staging'
set :branch, 'staging'

set :bundle_without, [:development, :test]

server "stage01.45469.blueboxgrid.com", :app, :web, :db, :primary => true 
