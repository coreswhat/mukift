
module Bittorrent

  module Bcode
  
    DICTIONARY  = 'd'
    LIST        = 'l'
    NUMBER      = 'i'
    END_MARK    = 'e'    
    
    class BString
      def initialize(s = nil)
        @s = s || ''
      end

      def out
        @s.size.to_s + ':' + @s
      end
    end

    class BNumber
      def initialize(n)
        @n = n
      end

      def out
        NUMBER + @n.to_s + END_MARK
      end
    end

    class BList
      def initialize
        @a = []
      end

      def <<(e)
        @a << e
      end

      def out
        s = ''
        s << LIST
        @a.each {|e| s << e.out }
        s << END_MARK
      end
    end

    class BDictionary
      def initialize
        @a = []
      end

      def []=(name, e)
        @a << {:name => name, :e => e}
      end

      def out
        s = ''
        s << DICTIONARY
        @a.each do |e|
          s << e[:name].size.to_s + ':' + e[:name]
          s << e[:e].out
        end
        s << END_MARK
      end
    end
  end
end