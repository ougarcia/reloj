require_relative './route_helper'


module Phase7
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

    def add_helper_values(known_unknown)
      #used to store values as ivars
      # storing the values need to create a new route_helper
      # route_helpers aren't created untiil we get to the controller_class
    end


    def run(req, res)
      route_params = {}
      matches = @pattern.match(req.path)
      matches.names.each do |key|
        route_params[key] = matches[key]
      end
      #pass the methods to the controller class here
      @controller_class.new(req, res, route_params).invoke_action(@action_name)
    end
  end

  class Router
    attr_reader :routes, :helpers

    def initialize
      @routes = []
      @helpers = []
    end

    def add_helper(route)
      # add helper to route being created
      @helpers << route
      #also add helper to all previously created routes
    end

    # simply adds a new route to the list of routes
    def add_route(pattern, method, controller_class, action_name)
      route = Route.new(pattern, method, controller_class, action_name)
      @routes << route
      # make helper
      # add helper to all previously created routes
      #   including the one just created
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
        match(req).run(req, res)
      else
        res.status = 404
      end
    end
  end
end
