
# install
#   $ bundle install

source :rubygems

# project

  gem 'sinatra'
  
  # database
  
    gem 'mysql', :require => 'mysql'
    gem 'activerecord', :require => 'active_record'
   
# development

  group :development do
    gem 'thin'
  end
    
# test

  group :test do    
    gem 'rspec', :require => 'spec'
  end

# deploy

  group :deploy do
    gem 'sprinkle'    
    gem 'capistrano'
  end