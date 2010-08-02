
describe '- tracker' do 
    
  describe 'Tracker' do  
  
    describe 'Scrape' do
      include Tracker::Scrape

      context '- regular:' do
        
        before(:all) do
          clear_database
          load_default_variables
          
          @config   = APP_CONFIG[MUKIFT_ENV].dup 
               
          @messages = MESSAGES[@config[:locale]][:scrape].dup                    
          
          @params = { :passkey   => @user.passkey,
                      :info_hash => [ @torrent.info_hash ] }
        end
      
        it 'should process a scrape request if scrape enabled' do
          @config[:scrape_enabled] = true
          
          @torrent.seeders_count = 3
          @torrent.leechers_count = 5
          @torrent.snatches_count = 7
          @torrent.save!
          
          resp = scrape(@params, @config, @messages, LOGGER)      
          
          resp.should_not include('Unexpected server error.')
          resp.should include('d8:completei3e10:incompletei5e10:downloadedi7e')      
        end
        
        it 'should not process a scrape request if scrape not enabled' do
          @config[:scrape_enabled] = false
          
          resp = scrape(@params, @config, @messages, LOGGER)      
          
          resp.should_not include('Unexpected server error.')
          resp.should include('Tracker does not allow scrape.')      
        end
      end    
    end
  end    
end
  
  
  
  
  
  
  
  
  
  
  
  
