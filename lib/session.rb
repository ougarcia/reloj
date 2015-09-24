require 'json'
require 'webrick'

module Reloj
  class Session
    # find the cookie for this app, deserialize into hash
    def initialize(req)
      req.cookies.each do |cookie|
        if cookie.name == '_rails_lite_app'
          @_rails_lite_app = JSON.parse(cookie.value)
        end
      end
      @_rails_lite_app ||= {}
    end

    # convenience methods
    def [](key)
      @_rails_lite_app[key]
    end

    def []=(key, val)
      @_rails_lite_app[key] = val
    end

    # serialize the hash into json and save in a cookie, add to responses
    def store_session(res)
      cookie = WEBrick::Cookie.new('_rails_lite_app', @_rails_lite_app.to_json)
      cookie.path = '/'
      res.cookies << cookie
    end
  end
end
