require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response, :params

    def initialize(env)
      env['simpler.params'] = {}
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @params = env['simpler.params'].merge!(@request.params)
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    def add_params(params)
      @params.merge!(params)
    end

    private

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      headers['Content-Type'] = 'text/html'
    end

    def write_response
      body = @request.env['simpler.render_plain'] || render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def render(template)
      if template.is_a?(Hash) && @request.env['simpler.render_plain'] = template[:plain]
        headers['Content-Type'] = "text/plain"
      else
        @request.env['simpler.template'] = template
      end
    end

    def status(code)
      @response.status = code
    end

    def headers
      @response.headers
    end

  end
end

