
# spec helper
  require File.join(File.dirname(__FILE__), '..', 'spec_helper')

# concerns
  Dir.glob(File.join(File.dirname(__FILE__), 'peer_spec', '*')).each {|f| require f }

describe '- models' do 
    
  describe 'Peer' do
  
    context '- main class:' do
    
      before(:each) do
        clear_database
        load_default_variables
      end
    
      it 'should be created given valid parameters' do
        h = {
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
          :client            => @client,
        }
    
        connectable = true
    
        p = Peer.kreate! h, connectable
        p.reload
        
        p.ip.should == '0.0.0.0'
        p.port.should == 10000
        p.compact_ip.should_not be_nil
        p.seeder?.should be_false
        
        p.peer_conn.should_not be_nil
        p.peer_conn.connectable?.should be_true
        
        p.client_code        = @client.code
        p.client_description = @client.description
        p.client_version     = @client.version
      end
    end
  end
end  
  
  

