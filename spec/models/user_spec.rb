
# spec helper
  require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe '- models' do 
    
  describe 'User' do

    context '- main class:' do
    
      before(:each) do
        clear_database
        load_default_variables
      end
    
      it 'should calculate ratio' do
        User.calculate_ratio(50, 0).should == 0
        User.calculate_ratio(50, 100).should == 0.5
      end
    
      it 'should increment downloaded and uploaded counters and set ratio' do
        @user.uploaded, @user.downloaded, @user.ratio = 0, 0, 0
        @user.save!
        @user.reload
        
        @user.increment_counters!(100, 45)
        @user.reload
    
        @user.uploaded.should == 100
        @user.downloaded.should == 45
        @user.ratio.should == 2.222
      end
    end
  end
end  




