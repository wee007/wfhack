require 'rack-proxy'

class ServiceProxy < Rack::Proxy

  def initialize(app)
    @app = app
  end

  def call(env)
    original_host = env["HTTP_HOST"]
    rewrite_env(env)
    if env["HTTP_HOST"] != original_host
      status, headers, response = perform_request(env)
      headers.delete "transfer-encoding"
      [status, headers, response]
    else
      @app.call(env) # just regular
    end
  end

  def rewrite_env(env)
    request = Rack::Request.new(env)

    if request.path =~ %r{^/api/}
      service = request.path.split('/')[2]
      env["HTTP_HOST"] = "#{service}-service.#{Rails.env}.dbg.westfield.com"
      env['SERVER_PORT'] = '80'
    end

    env
  end

end
