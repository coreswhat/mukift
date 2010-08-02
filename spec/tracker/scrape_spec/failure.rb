
describe '- tracker' do 
    
  describe 'Tracker' do  
  
    describe 'Scrape' do
      include Tracker::Scrape

      context '- failure:' do
        
        before(:all) do
          clear_database
          load_default_variables
          
          @config   = APP_CONFIG[MUKIFT_ENV].dup   
             
          @messages = MESSAGES[@config[:locale]][:scrape].dup
          
          @config[:scrape_enabled] = true              
          @config[:ban_unknown_clients] = false           
          
          @params = { :passkey     => @user.passkey,
                      :info_hash   => [ @torrent.info_hash ] }
        end        
  
        it 'should notify if torrent info hash is invalid' do
          params = @params.dup
          
          params[:info_hash] = 'nononono'
          
          resp = scrape(params, @config, @messages, LOGGER)      
          
          resp.should_not include('Unexpected server error.')
          resp.should include('Torrent not found.')      
        end  
        
        it 'should notify if user passkey is invalid' do
          params = @params.dup
          
          params[:passkey] = 'nononono'
          
          resp = scrape(params, @config, @messages, LOGGER)      
          
          resp.should_not include('Unexpected server error.')
          resp.should include('Invalid passkey.')      
        end
        
        it 'should notify if received request with invalid data' do
          params = @params.dup
          
          params.delete(:info_hash)
          params[:info_xxxx_hash] = 'nononono'
          
          resp = scrape(params, @config, @messages, LOGGER)      
          
          resp.should_not include('Unexpected server error.')
          resp.should include('Client sent request with invalid data.')      
        end      
      end    
    end
  end    
end
    
    
    
    
    
    
    
    
    
    
    
    
