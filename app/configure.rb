
# configure

  configure do    
    
    set :config, APP_CONFIG[MUKIFT_ENV]
    
    set :messages, MESSAGES[APP_CONFIG[MUKIFT_ENV][:locale]]    
    
    set :logger, LOGGER
    
    helpers Tracker::Announce, Tracker::Scrape
      
    # error handling
      set :raise_errors, false
      set :show_exceptions, false
                 
      error do
        ErrorLog.kreate_with_error! request.env['sinatra.error']
      end
      
      error 404 do
        halt 'not found'
      end
  end 
  
  
  