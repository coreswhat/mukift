
describe '- tracker' do 
    
  describe 'Tracker' do  
  
    describe 'Announce' do
      include Tracker::Announce

      context '- failure:' do
        
        before(:each) do
          clear_database
          load_default_variables
          
          @config   = APP_CONFIG[MUKIFT_ENV].dup  
              
          @messages = MESSAGES[@config[:locale]][:announce].dup
          
          @config[:log_announces] = true
          @config[:ban_unknown_clients] = false
          
          @params = { :passkey     => @user.passkey,
                      :event       => '',
                      :info_hash   => @torrent.info_hash,
                      :numwant     => '20',
                      :port        => '20000',
                      :uploaded    => '0',
                      :downloaded  => '0',
                      :left        => @torrent.size.to_s,
                      :peer_id     => '-UT1770-000000000000',
                      :no_peer_id  => '1',
                      :compact     => '0',
                      :key         => 'key' }
        end 
          
        it 'should notify if torrent info hash is invalid' do
          params = @params.dup
          
          params[:info_hash] = 'nononono'
          
          resp = announce(params, '0.0.0.0', @config, @messages, LOGGER)      
          
          resp.should_not include('Unexpected server error.')
          resp.should include('Torrent not found.')      
        end
        
        it 'should notify if user passkey is invalid' do
          params = @params.dup
          
          params[:passkey] = 'nononono'
          
          resp = announce(params, '0.0.0.0', @config, @messages, LOGGER)      
          
          resp.should_not include('Unexpected server error.')
          resp.should include('Invalid passkey.')      
        end 
        
        it 'should notify if received request with missing data' do
          params = @params.dup
          
          params.delete(:info_hash)
          
          resp = announce(params, '0.0.0.0', @config, @messages, LOGGER)      
          
          resp.should_not include('Unexpected server error.')
          resp.should include('Client sent request with invalid data.')      
        end       
        
        it 'should notify if received request with invalid data' do
          params = @params.dup
          
          params[:port] = 'nononono'
          
          resp = announce(params, '0.0.0.0', @config, @messages, LOGGER)      
          
          resp.should_not include('Unexpected server error.')
          resp.should include('Client sent request with invalid data.')      
        end           
      end
    end
  end
end

