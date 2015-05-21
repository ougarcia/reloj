
require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
require_relative './session'
require_relative './params'
require_relative './flash'
require_relative './route_helper'
require 'byebug'


module Phase7
  class ControllerBase
    extend RouteHelper
    attr_reader :params, :req, :res

    def self.drop_suffix
      /.+?(?=Controller$)/.match(name)[0].underscore
    end

    def self.create_helper_methods(helper_attrs)
      helper_attrs.each do |helper_attr|
        create_helper_method(helper_attr)
      end
    end

    #helper_attr is hash with keys :pattern, :action_name
    def self.create_helper_method(helper_attr)
      path = helper_attr[:pattern]
      nouns = path.split('/')
      nouns.delete("")
      if nouns.any? { |noun| noun[0] == ":" }
        build_nested_route_helper(nouns)
      else
        method_name = nouns.join("_") + "_path"
        define_method(method_name) { path }
      end
    end

    def self.build_nested_route_helper(nouns)
      just_names = nouns.select { |noun| noun[0] != ":" }
      method_name = nouns.select do |noun|
        noun[0] != ":"
      end.join("_") + "_path"

      define_method(method_name) do |*ids|
        result = []
        just_names.each do |noun|
          result << noun
          result << ids.shift unless ids.empty?
        end
        result.join('/')
      end
    end

    def initialize(req, res, route_params = {}, helper_attrs = [])
      @req = req
      @res = res
      @already_built_response = false
      @params = Params.new(req, route_params)
      @helper_attrs = helper_attrs
      self.class.create_helper_methods(helper_attrs)
      #debugger
    end

    def already_built_response?
      @already_built_response
    end

    def redirect_to(url)
      raise if already_built_response?
      @res.status = 302
      @res["Location"] = url
      @already_built_response = true
      flash.store_flash(@res)
      session.store_session(@res)
    end

    def render_content(content, content_type)
      raise if already_built_response?
      @already_built_response = true
      @res.content_type = content_type
      @res.body = content
      flash.store_flash(@res)
      session.store_session(@res)
    end

    def render(template_name)
      controller_name = self.class.to_s.underscore
      f = File.read("views/#{controller_name}/#{template_name}.html.erb")
      f = ERB.new(f)
      render_content(f.result(binding), "text/html")
    end

    def session
      @session ||= Session.new(@req)
    end

    def flash
      @flash ||= Flash.new(@req)
    end

    def invoke_action(name)
      self.send(name)
      render(name) unless self.already_built_response?
    end

  end
end
