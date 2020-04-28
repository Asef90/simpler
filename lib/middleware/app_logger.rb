require 'logger'

class AppLogger
  def initialize(app, **options)
    @logger = Logger.new(options[:logdev])
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)

    request_info(env)
    handler_info(env)
    parameters_info(env)
    response_info(env)

    [status, headers, body]
  end

  def request_info(env)
    request_method = env['REQUEST_METHOD']
    request_path = "#{env['PATH_INFO']}?#{env['QUERY_STRING']}"

    @logger.info("Request: #{request_method} #{request_path}")
  end

  def handler_info(env)
    controller = env['simpler.controller'].class.name
    action = env['simpler.action']

    @logger.info("Handler: #{controller}##{action}")
  end

  def parameters_info(env)
    @logger.info("Parameters: #{env['simpler.params']}")
  end

  def response_info(env)
    response = env['simpler.controller'].response
    status = response.status
    content_type = response['Content-Type']
    template_path = env['simpler.template']

    @logger.info("Response: #{status} [#{content_type}] #{template_path}")
  end
end
