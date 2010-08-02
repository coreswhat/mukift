
# spec helper
  require File.join(File.dirname(__FILE__), '..', 'spec_helper')

# concerns
  Dir.glob(File.join(File.dirname(__FILE__), 'snatch_spec', '*')).each {|f| require f }

describe '- models' do 
    
  describe 'Snatch' do

    context '- main class:' do
    
      before(:each) do
        clear_database
        load_default_variables
      end
    
      it 'should be created given valid parameters' do
        @torrent.leechers_count = 1
        @torrent.save!
        
        Snatch.kreate! @torrent, @user
        
        s = find_snatch_by_torrent_and_user(@torrent, @user)
        s.should_not be_nil
        s.torrent.should == @torrent
        s.user.should == @user
      end
      
      it 'should not be created and not raise error if already exists' do
        @torrent.leechers_count = 2
        @torrent.save!
        
        Snatch.kreate! @torrent, @user      
        lambda { Snatch.kreate!(@torrent, @user) }.should_not raise_error
        Snatch.count.should == 1
      end    
    end
  end
end