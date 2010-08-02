
# spec helper
  require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe '- tracker' do 
    
  describe 'Tracker' do  
    include Tracker 
  
    describe 'AnnounceRequest' do 

      before(:each) do
        clear_database
        load_default_variables
  
        @params = { :passkey     => @user.passkey,
                    :event       => 'started',
                    :info_hash   => @torrent.info_hash,
                    :numwant     => '50',
                    :port        => '20000',
                    :uploaded    => '10',
                    :downloaded  => '20',
                    :left        => '30',
                    :peer_id     => "-#{@client.code}#{@client.version}-000000000000",
                    :no_peer_id  => '1',
                    :compact     => '1',
                    :key         => 'key' }
      end
    
      it 'should be instantiated given valid parameters' do
        r = AnnounceRequest.new @params      
        r.started?.should be_true
        r.stopped?.should be_false
        r.completed?.should be_false
        r.numwant.should == 50
        r.port.should == 20000
        r.uploaded.should == 10
        r.downloaded.should == 20
        r.left.should == 30
        r.seeder?.should be_false
        r.no_peer_id.should be_true
        r.compact.should be_true            
      end  
      
      it 'should set uploaded and downloaded offsets' do
        r = AnnounceRequest.new @params            
        r.set_offsets(5, 5)                  
        r.up_offset.should == 5
        r.down_offset.should == 15           
      end                  
    end
  end
end

