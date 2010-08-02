
module Tracker

  class ScrapeResponse
    include Bittorrent::Bcode

    FILES          = 'files'
    FAILURE_REASON = 'failure reason'
    COMPLETE       = 'complete'
    INCOMPLETE     = 'incomplete'
    DOWNLOADED     = 'downloaded'

    attr_accessor :failure_reason

    class ScrapeFile
      attr_accessor :info_hash, :complete, :incomplete, :downloaded
    end

    def initialize
      @files = []
    end
    
    def add_file(torrent)
      f = ScrapeFile.new
      f.info_hash = torrent.info_hash
      f.complete = torrent.seeders_count
      f.incomplete = torrent.leechers_count
      f.downloaded = torrent.snatches_count
      @files << f
    end

    def out(logger = nil)
      logger.debug ':-) scrape_response.out' if logger
      root = BDictionary.new
      if self.failure_reason
        root[FAILURE_REASON] = BString.new(self.failure_reason)
      else
        unless @files.blank?
          logger.debug ":-) sending #{@files.size} file(s)" if logger
          b_files = BDictionary.new
          @files.each do |f|
            b_file = BDictionary.new
            b_file[COMPLETE] = BNumber.new(f.complete)
            b_file[INCOMPLETE] = BNumber.new(f.incomplete)
            b_file[DOWNLOADED] = BNumber.new(f.downloaded)
            b_files[f.info_hash] = b_file
          end
          root[FILES] = b_files
        end
      end
      r = root.out
      logger.debug "  :-) scrape response: #{r}" if logger
      r
    end
  end
end