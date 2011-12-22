set :deploy_env, 'staging'
set :rails_env, 'staging'

set :bundle_without, [:development, :test]
set :branch, 'andy_demo_chat_on_envolve'

server "stage01.45469.blueboxgrid.com", :app, :web, :db, :primary => true 
