require_relative './route_helper'


module Reloj
  class Route
    attr_reader :pattern, :http_method, :controller_class, :action_name

    def initialize(pattern, http_method, controller_class, action_name)
      @pattern = pattern
      @http_method = http_method
      @controller_class = controller_class
      @action_name = action_name
      # save all helpers in the routes
    end


    def matches?(req)
      req.request_method.downcase.to_sym == @http_method &&
      @pattern.match(req.path)
    end


    def run(req, res, paths = [])
      route_params = {}
      matches = @pattern.match(req.path)
      matches.names.each do |key|
        route_params[key] = matches[key]
      end
      #pass the methods to the controller class here
      @controller_class.new(req, res, route_params, paths).invoke_action(@action_name)
    end
  end

  class Router
    attr_reader :routes, :helpers

    def self.regex_from_pattern_string(pattern_string)
      x = pattern_string.split('/').map do |part|
        part.gsub(/:(.+)[\/]{,1}/, '(?<\1>\d+)')
      end.join('/')

      Regexp.new("^#{x}\/?$")
    end

    def initialize
      @routes = []
      @paths = []
    end

    def add_helper_attributes(pattern, action_name)
      #need controller name
      # will get that when passed to controller
      #need action
      @paths <<  pattern
    end

    # simply adds a new route to the list of routes
    def add_route(pattern, method, controller_class, action_name)
      parsed_pattern = Router.regex_from_pattern_string(pattern.to_s)
      route = Route.new(parsed_pattern, method, controller_class, action_name)
      @routes << route
      add_helper_attributes(pattern, action_name)
    end

    def draw(&proc)
      instance_eval(&proc)
    end

    [:get, :post, :put, :delete].each do |http_method|
      define_method(http_method) do |pattern, controller_class, action_name|
        add_route(pattern, http_method, controller_class, action_name)
      end
    end

    def match(req)
      @routes.each { |route| return route if route.matches?(req) }
      nil
    end

    def run(req, res)
      if match(req)
        #pass in the helper_attributes here
        match(req).run(req, res, @paths)
      else
        res.status = 404
      end
    end
  end
end
