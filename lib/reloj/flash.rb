require 'json'
require 'webrick'

module Reloj
  class Flash
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      req.cookies.each do |cookie|
        if cookie.name == '_flash'
          @_old_flash = JSON.parse(cookie.value)
        end
      end
      @_old_flash ||= {}
      @_new_flash ||= {}
    end

    def [](key)
      @_old_flash[key] || @_new_flash[key]
    end

    def []=(key, val)
      @_new_flash[key] = val
    end

    def now
      @_old_flash
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_flash(res)
      cookie = WEBrick::Cookie.new('_flash', @_new_flash.to_json)
      cookie.path = '/'
      res.cookies << cookie
    end
  end
end
