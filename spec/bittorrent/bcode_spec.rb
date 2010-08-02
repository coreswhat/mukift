
# spec helper
  require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe '- bittorrent' do 
  
  describe 'Bittorrent' do
    
    describe 'Bcode' do
      include Bittorrent::Bcode
  
      it 'should bencode a string' do
        s = BString.new('value') 
        s.out.should == '5:value'
      end

      it 'should bencode a number' do
        n = BNumber.new(999) 
        n.out.should == 'i999e'
      end

      it 'should bencode a list' do
        l = BList.new
        l << BString.new('one')
        l << BString.new('two')
        l << BNumber.new(3)      
        l.out.should == 'l3:one3:twoi3ee'
      end

      it 'should bencode a dictionary' do
        d = BDictionary.new
        d['bstring'] = BString.new('string') 
        d['bnumber'] = BNumber.new(999)
        l = BList.new
        l << BString.new('one')
        l << BString.new('two')
        d['blist'] = l
        d.out.should == 'd7:bstring6:string7:bnumberi999e5:blistl3:one3:twoee'
      end
    end
  end
end