source 'http://rubygems.org'

gem 'rack', '>= 1.4.0'
gem 'rails', '~> 3.2.0.rc2'
gem 'mysql2'

gem 'bcrypt-ruby', '= 3.0.0' # pinned to 3.0.0 until the 3.0.1 segfault is resolved.
gem 'authlogic'
#gem 'omniauth', '~> 1.0' # for facebook
gem 'omniauth', :git => "git://github.com/intridea/omniauth.git"
gem 'omniauth-facebook'
gem 'rails3-generators'
gem 'opentok'
gem "paperclip", "~> 2.4.4"
gem 'aws-s3'
gem 'rest-client'
gem 'has_mailbox'
gem 'execjs'
gem 'therubyracer'
gem 'thumbs_up'
gem 'kaminari'
gem 'sunspot_rails'
gem "sunspot_with_kaminari", '~> 0.1'
gem "sunspot_solr"
gem "remotipart", "~> 1.0"
gem 'rails_admin', :git => 'git://github.com/sferik/rails_admin.git'
gem 'contacts', :git => 'git://github.com/agentrock/contacts'
gem 'gdata', :git => 'git://github.com/agentrock/gdata.git'
gem 'hpricot'
gem "transitions", :require => ["transitions", "active_record/transitions"]
gem 'delayed_job_active_record'
gem "recaptcha", :require => "recaptcha/rails"
gem "friendly_id", "~> 4.0.0"

gem "ruby-hmac"
gem 'rchardet19'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "~> 3.2.0"
  gem 'coffee-rails', "~> 3.2.0"
  gem 'uglifier'
end

gem 'jquery-rails'
gem 'mediaelement_rails'
gem 'httparty'
gem "nifty-generators", :group => :development

# Gem for parsing RSS/Atom Feeds
gem 'feedzirra', :git => 'git://github.com/pauldix/feedzirra.git'
gem 'curb', '0.7.15' 
gem 'whenever'

# memcached client 
gem 'dalli'

group :test, :development do
    gem 'rspec-rails'
    gem 'factory_girl_rails'
    gem 'faker'
    gem 'ruby-debug19'
    gem 'guard'
    gem 'guard-rspec'
    gem 'guard-spork'
    gem 'spork', '>= 0.9.0.rc'
    gem 'rb-fsevent', :git => 'git://github.com/ttilley/rb-fsevent.git', :branch => 'pre-compiled-gem-one-off' #better support for Mac OS X filesystem
end

group :development do
  gem 'foreman'
end

group :cucumber do
    gem 'capybara'
    gem 'database_cleaner'
    gem 'cucumber-rails'
    gem 'cucumber'
    gem 'spork', '>= 0.9.0.rc'
    gem 'launchy'
    gem 'sunspot_test'
end

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano'
gem 'capistrano-ext'
gem 'cap-recipes'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

gem "devise"
