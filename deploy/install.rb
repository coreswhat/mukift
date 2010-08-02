
# Sprinkle gem recipe to install the server required software (works better with
# ubuntu according to the author). It uses the 'prepare' recipe to connect to the server.
#   run:
#     $ sprinkle -v -c -s deploy/install.rb

$:<< File.join(File.dirname(__FILE__), 'stack')

# stack base

  %w(essential mysql required_gems ruby_enterprise scm).each do |lib|
    require lib
  end

# web server

  require 'apache'

# policy

  policy :stack, :roles => :app do
    requires :webserver               # apache or nginx
    requires :appserver               # passenger
    requires :ruby_enterprise         # ruby enterprise edition
    requires :required_gems           # gems  
    # requires :scm                   # git (enable it if deploying from a remote repository)
  end

# mechanism

  deployment do    
    delivery :capistrano do
      if Capistrano::CLI.ui.agree('* WARNING: Make sure the Passenger version in stack/apache is the latest or Sprinkle will mess things up. Continue? (y/n):')
        begin
          recipes 'deploy/prepare' # it uses this recipe's settings
        rescue LoadError
          puts 'error: cannot find capistrano install recipe'
        end
      else
        exit
      end
    end
  
    # source based package installer defaults
    source do
      prefix   '/usr/local'
      archives '/usr/local/sources'
      builds   '/usr/local/build'
    end
  end

# sprinkle version check

  begin
    gem 'sprinkle', ">= 0.2.3"
  rescue Gem::LoadError
    puts "sprinkle 0.2.3 required.\n Run: `sudo gem install sprinkle`"
    exit
  end
  




