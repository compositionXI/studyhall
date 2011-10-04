set :deploy_env, 'staging'
set :rails_env, 'staging'

set :bundle_without, [:development, :test]

server "stage01.45469.blueboxgrid.com", :app, :web, :db, :primary => true 
