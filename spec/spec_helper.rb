
# run
  # models
    # spec spec/models -c -f n
    # spec spec/models/user_spec.rb -c -f n    
  # tracker
    # spec spec/tracker -c -f n

# env  
  MUKIFT_ENV = :test unless defined?(MUKIFT_ENV)

# logger
  LOGGER = nil unless defined?(LOGGER) # comment this line to log to stdout
  
# app root
  MUKIFT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..')) unless defined?(MUKIFT_ROOT)
    
# required files

  # app
    require File.join(MUKIFT_ROOT, 'mukift')
    
  # support
     
    # support dir
      support_dir = File.join(MUKIFT_ROOT, 'spec', 'support')
  
    # support modules
      ['finders', 'makers', 'misc', 'support_variables'].each {|f| require File.join(support_dir, f)}

# rspec

  Spec::Runner.configure do |conf|
    conf.include Finders, Makers, Misc, SupportVariables
  end
    
# echo
  unless $echoed
    puts
    puts "- spec_helper"
    puts "  + mukift env   = #{MUKIFT_ENV}"
    puts "  + mukift root  = #{MUKIFT_ROOT}"
    puts "  + support dir  = #{support_dir}"
    puts
    $echoed = true
  end
























#
