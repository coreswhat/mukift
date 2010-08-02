
describe '- models' do 
    
  describe 'Peer' do
  
    context '- callbacks:' do
      
      before(:each) do
        clear_database
        load_default_variables
        
        @h = {
          :torrent           => @torrent,
          :user              => @user,
          :ip                => '0.0.0.0',
          :port              => 10000,
          :uploaded          => 0,
          :downloaded        => 0,
          :left              => @torrent.size,
          :seeder            => false,
          :peer_id           => 'peer_id',
          :current_action_at => Time.now,
          :client            => @client
        }
      end
  
      it 'should increment torrent seeders counter on creation' do
        @h[:seeder], @h[:left] = true, 0
        
        @torrent.seeders_count = 0
        @torrent.save!      
        
        Peer.kreate! @h, true
        @torrent.reload
  
        @torrent.seeders_count.should == 1
      end
  
      it 'should increment torrent leechers counter on creation' do
        @torrent.leechers_count = 0
        @torrent.save!
        
        Peer.kreate! @h, true
        @torrent.reload
  
        @torrent.leechers_count.should == 1
      end
  
      it 'should decrement torrent seeders counter on destruction' do
        @h[:seeder], @h[:left] = true, 0
        
        @torrent.seeders_count = 0
        @torrent.save!
        
        p = Peer.kreate! @h, true
        p.destroy
        @torrent.reload
  
        @torrent.seeders_count.should == 0
      end
  
      it 'should decrement torrent leechers counter on destruction' do
        @torrent.leechers_count = 0
        @torrent.save!
        
        p = Peer.kreate! @h, true            
        p.destroy
        @torrent.reload
  
        @torrent.leechers_count.should == 0
      end
    end
  end
end  
  
  
  

