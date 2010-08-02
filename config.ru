
require 'rubygems'
require 'sinatra'

Bundler.setup

MUKIFT_ROOT = File.dirname(__FILE__)

MUKIFT_ENV = ENV['RACK_ENV'].to_sym

# logger

  log_file = File.new(File.join(MUKIFT_ROOT, 'log', 'sinatra.log'), 'a')
  
  STDOUT.reopen(log_file)
  STDERR.reopen(log_file)

# app file

  require File.join(MUKIFT_ROOT, 'mukift')

# sinatra

  disable :run
  
  run Sinatra::Application

