
require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
require_relative './session'
require_relative './params'


module Phase7
  class ControllerBase
    attr_reader :params, :req, :res

    def initialize(req, res, route_params = {})
      @req = req
      @res = res
      @already_built_response = false
      @params = Params.new(req, route_params)
    end

    def already_built_response?
      @already_built_response
    end

    def redirect_to(url)
      rails if already_built_response?
      @res.status = 302
      @res["Location"] = url
      @already_built_response = true
      session.store_session(@res)
    end

    def render_content(content, content_type)
      raise if already_built_response?
      @already_built_response = true
      @res.content_type = content_type
      @res.body = content
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

    def invoke_action(name)
      self.send(name)
      render(name) unless self.already_built_response?
    end

  end
end
