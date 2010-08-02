
describe '- tracker' do 
    
  describe 'Tracker' do  
  
    describe 'Announce' do
      include Tracker::Announce
  
      context '- response:' do
        
        before(:each) do
          clear_database
          load_default_variables
          
          @config   = APP_CONFIG[MUKIFT_ENV].dup 
               
          @messages = MESSAGES[@config[:locale]][:announce].dup
          
          @config[:log_announces] = true
          @config[:announce_interval_seconds] = 1800
          @config[:announce_min_interval_seconds] = 1800
          @config[:ban_unknown_clients] = false
          @config[:bonus_rules] = { :seeding => 1 } # 100% bonus for seeding
          
          @torrent.size = 10000
          @torrent.save!
          
          @params = { :passkey     => @user.passkey,
                      :event       => '',
                      :info_hash   => @torrent.info_hash,
                      :numwant     => '20',
                      :port        => '20000',
                      :uploaded    => '0',
                      :downloaded  => '0',
                      :left        => @torrent.size.to_s,
                      :peer_id     => "-#{@client.code}#{@client.version}-000000000000",
                      :no_peer_id  => '1',
                      :compact     => '',
                      :key         => 'key' }
        end
      
        it 'should include other peers ips and ports in response in plain format' do
          params = @params.dup
          
          params[:passkey] = @user_two.passkey
          params[:port] = '10002'       
          announce(params, '0.0.0.2', @config, @messages, LOGGER)
          
          params[:passkey] = @user_three.passkey
          params[:port] = '10003'
          announce(params, '0.0.0.3', @config, @messages, LOGGER)
                
          params[:compact] = ''              
          params[:passkey] = @user.passkey
          resp = announce(params, '0.0.0.0', @config, @messages, LOGGER)
                  
          resp.should include('d2:ip7:0.0.0.24:porti10002e')
          resp.should include('d2:ip7:0.0.0.34:porti10003e')        
        end 
        
        it 'should include other peers ips and ports in response in compact format' do
          params = @params.dup
  
          params[:passkey] = @user_two.passkey
          params[:port] = '10002'       
          announce(params, '0.0.0.2', @config, @messages, LOGGER)
          
          params[:passkey] = @user_three.passkey
          params[:port] = '10003'
          announce(params, '0.0.0.3', @config, @messages, LOGGER)
                
          params[:compact] = '1'              
          params[:passkey] = @user.passkey
          resp = announce(params, '0.0.0.0', @config, @messages, LOGGER)
                               
          user_two_compact_ip   = Peer.make_compact_ip('0.0.0.2', 10002)
          user_three_compact_ip = Peer.make_compact_ip('0.0.0.3', 10003)
          
          resp.ends_with?("5:peers12:#{user_two_compact_ip}#{user_three_compact_ip}e").should be_true
        end                
      end
    end
  end
end