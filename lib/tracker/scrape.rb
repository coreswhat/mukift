
module Tracker
  
  module Scrape
    include Tracker::Support
  
    def scrape(params, config, messages, logger = nil)
      begin
        resp = ScrapeResponse.new
        
        set_logger logger            
        
        debug ':-) tracker.scrape'          
  
        failure :not_allowed unless config[:scrape_enabled]
        
        req = ScrapeRequest.new params
              
        failure :invalid_request unless req.passkey && req.info_hashs[0]
  
        set_torrent req, req.info_hashs[0] # only the first torrent info hash is considered
        set_user req
  
        resp.add_file(req.torrent)                   
      rescue Failure => e
        resp.failure_reason = messages[e.message]
      rescue => e
        log_error e, (req.user if req)
        resp.failure_reason = messages[:server_error]
      end
      resp.out(logger) 
    end
  end  
end


  