
# spec helper
  require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe '- tracker' do 
    
  describe 'Tracker' do  
  
    describe 'Support' do  
      include Tracker::Support  
        
      before(:each) do
        clear_database
                         
        @client_azureus_style = make_client('UT', 1770)
        @client_shadow_style  = make_client('S', 15500)
      end
      
      context '- client:' do
          
        it 'should retrieve client from database given azureus style code' do      
          peer_id = "-#{@client_azureus_style.code}#{@client_azureus_style.version}-000000000000"      
          c = parse_client(peer_id)      
          c.should == @client_azureus_style
        end
        
        it 'should retrieve client from database given shadow style code' do      
          peer_id = "#{@client_shadow_style.code}#{@client_shadow_style.version}---00000000000"      
          c = parse_client(peer_id)      
          c.should == @client_shadow_style
        end
        
        it 'should create unsaved client if code not found in database' do      
          peer_id = "-XX1000-000000000000"      
          c = parse_client(peer_id)      
          c.code.should == 'XX'
          c.version.should == 1000
        end
        
        it 'should set unknown client to banned if unknown clients are to be banned' do      
          peer_id = "-XX1000-000000000000"      
          c = parse_client(peer_id, true)      
          c.code.should == 'XX'
          c.version.should == 1000
          c.banned.should be_true
        end
      end    
    end
  end
end