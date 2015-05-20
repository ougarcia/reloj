require 'json'
require 'webrick'

module Phase7
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      req.cookies.each do |cookie|
        if cookie.name == '_rails_lite_app'
          @_rails_lite_app = JSON.parse(cookie.value)
        end
      end
      @_rails_lite_app ||= {}
  end

    def [](key)
      @_rails_lite_app[key]
    end

    def []=(key, val)
      @_rails_lite_app[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      res.cookies << WEBrick::Cookie.new('_rails_lite_app', @_rails_lite_app.to_json)
    end
  end
end

#pretty much copy this for flash
