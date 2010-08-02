
describe '- models' do 
    
  describe 'Snatch' do
  
    context '- callbacks:' do
      
      before(:each) do
        clear_database
        load_default_variables
      end
  
      it 'should update torrent counters on creation' do
        @torrent.snatches_count = 0
        @torrent.leechers_count = 1
        @torrent.seeders_count = 0      
        @torrent.save!
        
        Snatch.kreate! @torrent, @user
        @torrent.reload
  
        @torrent.snatches_count.should == 1
        @torrent.leechers_count.should == 0
        @torrent.seeders_count.should == 1
      end
    end
  end
end