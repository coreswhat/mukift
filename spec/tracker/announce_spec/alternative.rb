
describe '- tracker' do 
    
  describe 'Tracker' do  
  
    describe 'Announce' do
      include Tracker::Announce
      
      context '- alternative:' do
        
        before(:each) do
          clear_database
          load_default_variables
          
          @config   = APP_CONFIG[MUKIFT_ENV].dup 
               
          @messages = MESSAGES[@config[:locale]][:announce].dup
          
          @config[:log_announces]                 = true
          @config[:announce_interval_seconds]     = 1800
          @config[:announce_min_interval_seconds] = 1800
          @config[:ban_unknown_clients]           = false
          @config[:bonus_rules]                   = { :seeding => 1 } # 100% bonus for seeding
          
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
                      :compact     => '0',
                      :key         => 'key' }
        end
      
        it 'should create peer if peer not found for an announce request with no event' do
          params = @params.dup
          
          params[:event] = ''
          
          resp = announce(params, '0.0.0.0', @config, @messages, LOGGER)      
          
          resp.should_not include('Unexpected server error.')
          resp.should include('d8:intervali1800e12:min intervali1800e8:completei0e10:incompletei1e')
          
          p = find_peer_by_torrent_and_user_and_ip_and_port @torrent, @user, '0.0.0.0', 20000
          p.should_not be_nil
          p.seeder?.should be_false
          
          l = find_announce_log_by_torrent_and_user_and_ip_and_port_and_event_and_seeder @torrent, @user, '0.0.0.0', 20000, nil, false
          l.should_not be_nil
        end
        
        it 'should create peer if peer not found for an announce request with event completed' do
          params = @params.dup
          
          params[:event] = 'completed'
          params[:left]  = '0'
          
          resp = announce(params, '0.0.0.0', @config, @messages, LOGGER)      
          
          resp.should_not include('Unexpected server error.')
          resp.should include('d8:intervali1800e12:min intervali1800e8:completei1e10:incompletei0e')
          
          p = find_peer_by_torrent_and_user_and_ip_and_port @torrent, @user, '0.0.0.0', 20000
          p.should_not be_nil
          p.seeder?.should be_true
          
          l = find_announce_log_by_torrent_and_user_and_ip_and_port_and_event_and_seeder @torrent, @user, '0.0.0.0', 20000, 'completed', true
          l.should_not be_nil
        end      
        
        it 'should not create peer if peer not found for an announce request with event stopped' do
          params = @params.dup
          
          params[:event] = 'stopped'
          
          resp = announce(params, '0.0.0.0', @config, @messages, LOGGER)      
          
          resp.should_not include('Unexpected server error.')
          resp.should include('d8:intervali1800e12:min intervali1800e8:completei0e10:incompletei0e')
          
          p = find_peer_by_torrent_and_user_and_ip_and_port @torrent, @user, '0.0.0.0', 20000
          p.should be_nil
          
          @torrent.reload
          
          @torrent.leechers_count.should == 0
          @torrent.seeders_count.should == 0
          
          l = find_announce_log_by_torrent_and_user_and_ip_and_port_and_event_and_seeder @torrent, @user, '0.0.0.0', 20000, 'stopped', false
          l.should_not be_nil
        end      
      end
    end
  end
end