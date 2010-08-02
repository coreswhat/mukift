
module Misc
  
  def clear_database
    c = ActiveRecord::Base.connection
       
    c.execute('SET FOREIGN_KEY_CHECKS = 0;')
    
    (c.tables - ['schema_migrations']).each {|t| c.execute("TRUNCATE TABLE #{t};") }
    
    c.execute('SET FOREIGN_KEY_CHECKS = 1;')
  end
end









