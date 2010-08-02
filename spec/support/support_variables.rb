
module SupportVariables

  def load_default_variables
    @user       = make_user 'joe-the-user'
    @user_two   = make_user 'joe-the-user-two'
    @user_three = make_user 'joe-the-user-three'
    
    @torrent = make_torrent('torrent')    

    @client        = make_client('UT', 1770)
    @client_banned = make_client('BT', 1000, true)
  end
end