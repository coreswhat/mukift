
describe '- tracker' do 
    
  describe 'Tracker' do  
  
    describe 'Announce' do
      include Tracker::Announce

      context '- full cycle:' do
        
        before(:all) do
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
                      :compact     => '0',
                      :key         => 'key' }
        end
      
        it 'should process an announce request with event started' do
          params = @params.dup
          
          params[:event] = 'started'
          
          resp = announce(params, '0.0.0.0', @config, @messages, LOGGER)      
          
          resp.should_not include('Unexpected server error.')
          resp.should include('d8:intervali1800e12:min intervali1800e8:completei0e10:incompletei1e')
          
          p = find_peer_by_torrent_and_user_and_ip_and_port @torrent, @user, '0.0.0.0', 20000
          p.should_not be_nil
          p.seeder?.should be_false
          p.uploaded.should == 0
          p.downloaded.should == 0
          p.client_code.should == @client.code
          p.client_version.should == @client.version
          
          @torrent.reload
          
          @torrent.leechers_count.should == 1
          @torrent.seeders_count.should == 0
          
          l = find_announce_log_by_torrent_and_user_and_ip_and_port_and_event_and_seeder @torrent, @user, '0.0.0.0', 20000, 'started', false
          l.should_not be_nil
          l.up_offset.should == 0
          l.down_offset.should == 0
        end      
        
        it 'should process a leeching announce request with no event' do
          params = @params.dup
          
          stored_peer = find_peer_by_torrent_and_user_and_ip_and_port @torrent, @user, '0.0.0.0', 20000
          
          params[:uploaded] = '1111'
          params[:downloaded] = '2222'
          params[:left] = (@torrent.size - 2222).to_s
                  
          resp = announce(params, '0.0.0.0', @config, @messages, LOGGER)      
          
          resp.should_not include('Unexpected server error.')
          resp.should include('d8:intervali1800e12:min intervali1800e8:completei0e10:incompletei1e')
                  
          p = find_peer_by_torrent_and_user_and_ip_and_port @torrent, @user, '0.0.0.0', 20000
          p.should_not be_nil
          p.id.should == stored_peer.id
          p.seeder?.should be_false
          p.uploaded.should == 1111
          p.downloaded.should == 2222
          p.leftt.should == (@torrent.size - 2222)       
           
          @torrent.reload
          
          @torrent.leechers_count.should == 1
          @torrent.seeders_count.should == 0  
               
          @user.reload
          
          @user.uploaded.should == 1111
          @user.downloaded.should == 2222
          
          l = find_announce_log_by_torrent_and_user_and_ip_and_port_and_event_and_seeder @torrent, @user, '0.0.0.0', 20000, nil, false        
          l.should_not be_nil
          l.up_offset.should == 1111
          l.down_offset.should == 2222
        end
        
        it 'should process an announce request with event completed' do
          params = @params.dup
          
          stored_peer = find_peer_by_torrent_and_user_and_ip_and_port @torrent, @user, '0.0.0.0', 20000
          
          params[:event] = 'completed'
          params[:uploaded] = (1111 + 1111).to_s
          params[:downloaded] = (2222 + (@torrent.size - 2222)).to_s
          params[:left] = 0
          
          resp = announce(params, '0.0.0.0', @config, @messages, LOGGER)      
          
          resp.should_not include('Unexpected server error.')
          resp.should include('d8:intervali1800e12:min intervali1800e8:completei1e10:incompletei0e')
          
          p = find_peer_by_torrent_and_user_and_ip_and_port @torrent, @user, '0.0.0.0', 20000
          p.should_not be_nil
          p.id.should == stored_peer.id
          p.seeder?.should be_true
          p.uploaded.should == 1111 + 1111
          p.downloaded.should == 2222 + (@torrent.size - 2222)
          p.leftt.should == 0         
          
          find_snatch_by_torrent_and_user(@torrent, @user).should_not be_nil
          
          @torrent.reload
          
          @torrent.leechers_count.should == 0
          @torrent.seeders_count.should == 1
          
          @user.reload
          
          @user.uploaded.should == 1111 + 1111
          @user.downloaded.should == 2222 + (@torrent.size - 2222)
          
          l = find_announce_log_by_torrent_and_user_and_ip_and_port_and_event_and_seeder @torrent, @user, '0.0.0.0', 20000, 'completed', true
          l.should_not be_nil
          l.up_offset.should == 1111
          l.down_offset.should == (@torrent.size - 2222)
        end
  
        it 'should process a seeding announce request with no event' do
          params = @params.dup
          
          stored_peer = find_peer_by_torrent_and_user_and_ip_and_port @torrent, @user, '0.0.0.0', 20000
          
          params[:uploaded] = (1111 + 1111 + 1111).to_s
          params[:downloaded] = (2222 + (@torrent.size - 2222)).to_s
          params[:left] = 0
                  
          resp = announce(params, '0.0.0.0', @config, @messages, LOGGER)      
          
          resp.should_not include('Unexpected server error.')
          resp.should include('d8:intervali1800e12:min intervali1800e8:completei1e10:incompletei0e')
                  
          p = find_peer_by_torrent_and_user_and_ip_and_port @torrent, @user, '0.0.0.0', 20000
          p.should_not be_nil
          p.id.should == stored_peer.id
          p.seeder?.should be_true
          p.uploaded.should == 1111 + 1111 + 1111
          p.downloaded.should == 2222 + (@torrent.size - 2222)
          p.leftt.should == 0     
                  
          @torrent.reload
          
          @torrent.leechers_count.should == 0
          @torrent.seeders_count.should == 1
          
          @user.reload
          
          @user.uploaded.should == 1111 + 1111 + (1111 * 2) # with bonus for seeding
          @user.downloaded.should == 2222 + (@torrent.size - 2222)
          
          l = find_announce_log_by_torrent_and_user_and_ip_and_port_and_event_and_seeder @torrent, @user, '0.0.0.0', 20000, nil, true      
          l.should_not be_nil
          l.up_offset.should == 1111
          l.down_offset.should == 0
        end
              
        it 'should process an announce request with event stopped' do
          params = @params.dup
          
          stored_peer = find_peer_by_torrent_and_user_and_ip_and_port @torrent, @user, '0.0.0.0', 20000
          
          params[:event] = 'stopped'
          params[:uploaded] = (1111 + 1111 + 1111 + 1111).to_s
          params[:downloaded] = (2222 + (@torrent.size - 2222)).to_s
          params[:left] = 0
          
          resp = announce(params, '0.0.0.0', @config, @messages, LOGGER)      
          
          resp.should_not include('Unexpected server error.')
          resp.should include('d8:intervali1800e12:min intervali1800e8:completei1e10:incompletei0e')
          
          p = find_peer_by_torrent_and_user_and_ip_and_port @torrent, @user, '0.0.0.0', 20000
          p.should be_nil
          
          @torrent.reload
          
          @torrent.leechers_count.should == 0
          @torrent.seeders_count.should == 0
          
          @user.reload
          
          @user.uploaded.should == 1111 + 1111 + (1111 * 2) + (1111 * 2) # with bonus for seeding
          @user.downloaded.should == 2222 + (@torrent.size - 2222)
          
          l = find_announce_log_by_torrent_and_user_and_ip_and_port_and_event_and_seeder @torrent, @user, '0.0.0.0', 20000, 'stopped', true
          l.should_not be_nil
          l.up_offset.should == 1111
          l.down_offset.should == 0
        end
      end
    end
  end    
end    
    
    
    
    
    
    
    
    
    
    
    
    
