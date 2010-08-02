
# routes

  # announce

    get '/:passkey/announce' do
      halt announce(params, request.ip, options.config, options.messages[:announce], options.logger)
    end

  # scrape  
  
    get '/:passkey/scrape' do
      halt scrape(params, options.config, options.messages[:scrape], options.logger)
    end