
module Makers
  
  # methods that create records

  require 'digest'

  # client
  
    def make_client(code, version, banned = false)
      c = Client.new
      c.code = code
      c.description = code
      c.version = version
      c.banned = banned
      c.save!
      c.reload
    end
    
  # torrent

    def make_torrent(name = nil)
      t = Torrent.new
      t.name = name || 'torrent_name'
      t.type_id = 1
      t.format_id = 1
      t.size = 12345
      t.info_hash = Digest::SHA1.digest(rand.to_s)
      t.info_hash_hex = Digest.hexencode(t.info_hash).upcase
      t.created_at = Time.now
      t.files_count = 1
      t.piece_length = 1234
      t.save!
      t.reload
    end
  
  # user

    def make_user(username)
      u = User.new
      u.username = username
      u.email = 'whatever@mail.com'
      u.role_id = 1
      u.style_id = 1
      u.passkey = username
      u.crypted_password = 'whatever_password'
      u.salt = 'whatever_salt'
      u.created_at = Time.now
      u.save!
      u.reload
    end
end






  