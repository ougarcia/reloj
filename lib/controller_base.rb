require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
require_relative './session'
require_relative './params'
require_relative './flash'
require_relative './route_helper'
require 'byebug'


module Reloj
  class ControllerBase
    include RouteHelper
    attr_reader :params, :req, :res

    def initialize(req, res, route_params = {}, paths = [])
      @req = req
      @res = res
      @already_built_response = false
      @params = Params.new(req, route_params)
      @paths = paths
      self.class.create_helper_methods(paths)
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
      f = File.read("app/views/#{controller_name}/#{template_name}.html.erb")
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
