
describe '- models' do 
    
  describe 'Torrent' do
  
    context '- validation:' do
      
      before(:each) do
        clear_database
        load_default_variables
      end
  
      it 'should raise error if counters are negative' do
        @torrent.seeders_count = -1
        @torrent.leechers_count = 1     
        lambda { @torrent.save }.should raise_error
        
        @torrent.seeders_count = 1
        @torrent.leechers_count = -1
        lambda { @torrent.save }.should raise_error
      end
    end   
  end
end