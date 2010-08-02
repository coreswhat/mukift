
# spec helper
  require File.join(File.dirname(__FILE__), '..', 'spec_helper')

# announce_spec  
  Dir.glob(File.join(File.dirname(__FILE__), 'announce_spec', '*')).each {|f| require f }

