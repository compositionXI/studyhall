set :deploy_env, 'staging'
set :rails_env, 'staging'

set :bundle_without, [:development, :test]
#set :branch, 'andy_demo_chat_on_envolve'

server "staging01.c45577.blueboxgrid.com", :app, :web, :db, :primary => true 
