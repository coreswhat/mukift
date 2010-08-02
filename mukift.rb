
# run
#  $ ruby mukift.rb -p 4000 -e development

require 'rubygems'
require 'sinatra'
require 'mysql'
require 'active_record'

MUKIFT_ROOT = File.dirname(__FILE__) unless defined?(MUKIFT_ROOT)

MUKIFT_ENV  = Sinatra::Application.environment unless defined?(MUKIFT_ENV)

# logger

  LOGGER = (MUKIFT_ENV != :production) ? Logger.new(STDOUT) : nil unless defined?(LOGGER)     
 
# lib

  # bittorrent
    require File.join(MUKIFT_ROOT, 'lib', 'bittorrent', 'bcode')
    
  # tracker
    require File.join(MUKIFT_ROOT, 'lib', 'tracker', 'tracker')   
    
# config

  Dir.glob(File.join(MUKIFT_ROOT, 'config', '*.rb')).each {|f| require f }
    
# app
   
  # models
    Dir.glob(File.join(MUKIFT_ROOT, 'app', 'models', '**', '*')).each {|f| require f } 

  # configure
    require File.join(MUKIFT_ROOT, 'app', 'configure')
  
  # routes
    require File.join(MUKIFT_ROOT, 'app', 'routes')
    
    
        





























#