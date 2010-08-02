
describe '- tracker' do 
    
  describe 'Tracker' do  
  
    describe 'Announce' do
      include Tracker::Announce

      context '- client failure:' do
        
        before(:each) do
          clear_database
          load_default_variables
          
          @config   = APP_CONFIG[MUKIFT_ENV].dup 
               
          @messages = MESSAGES[@config[:locale]][:announce].dup
          
          @config[:log_announces] = true
          
          @params = { :passkey     => @user.passkey,
                      :event       => '',
                      :info_hash   => @torrent.info_hash,
                      :numwant     => '20',
                      :port        => '20000',
                      :uploaded    => '0',
                      :downloaded  => '0',
                      :left        => @torrent.size.to_s,
                      :peer_id     => "-#{@client.code}0000-000000000000",
                      :no_peer_id  => '1',
                      :compact     => '0',
                      :key         => 'key' }
        end 
        
        it 'should notify if unknown clients not allowed' do
          params = @params.dup
          
          @config[:ban_unknown_clients] = true
                          
          params[:peer_id] = '-XX0000-000000000000'
          
          resp = announce(params, '0.0.0.0', @config, @messages, LOGGER)      
          
          resp.should_not include('Unexpected server error.')
          resp.should include('Client not allowed.')      
        end       
  
        it 'should notify if client banned when unknown clients not allowed' do
          params = @params.dup
                          
          @config[:ban_unknown_clients] = true
                          
          params[:peer_id] = "-#{@client_banned.code}0000-000000000000"
          
          resp = announce(params, '0.0.0.0', @config, @messages, LOGGER)      
          
          resp.should_not include('Unexpected server error.')
          resp.should include('Client not allowed.')      
        end
        
        it 'should notify if client banned when unknown clients allowed' do
          params = @params.dup
                          
          @config[:ban_unknown_clients] = false
                          
          params[:peer_id] = "-#{@client_banned.code}0000-000000000000"
          
          resp = announce(params, '0.0.0.0', @config, @messages, LOGGER)      
          
          resp.should_not include('Unexpected server error.')
          resp.should include('Client not allowed.')      
        end 
        
        it 'should notify if client version banned' do
          params = @params.dup
  
          @client.min_version = 1700
          @client.save!
          
          params[:peer_id] = "-#{@client.code}1600-000000000000"
          
          resp = announce(params, '0.0.0.0', @config, @messages, LOGGER)      
          
          resp.should_not include('Unexpected server error.')
          resp.should include('Client version not allowed.')      
        end       
      end
    end
  end
end

