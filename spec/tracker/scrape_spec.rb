
# spec helper
  require File.join(File.dirname(__FILE__), '..', 'spec_helper')

# scrape_spec
  Dir.glob(File.join(File.dirname(__FILE__), 'scrape_spec', '*')).each {|f| require f }

