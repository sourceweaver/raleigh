require "http/server"

require "./views/renderer"

# The server example used in this file is for demonstration purposes.
# TODO: Rewrite this file with the router you'd like to use once you
# start a project using this template.

  # HomeHandler is the controller for the route:
  # `GET: /`
  class HomeHandler
    include HTTP::Handler

    def call(context : HTTP::Server::Context)
      context.response.content_type = "text/html"
      context.response.status_code = 200
      context.response.print render_page "pages/home", "default", nil
    end
  end

  # ErrorNotFoundHandler is the controller for the case:
  # `Error: 404 Page Not Found`
  class ErrorNotFoundHandler
    include HTTP::Handler

    def call(context : HTTP::Server::Context)
      context.response.content_type = "text/html"
      context.response.status_code = 404
      context.response.print "No such route as #{context.request.path}"
    end
  end

  # Router is a simple router that matches a handler based
  # on the request path.
  class Router
    include HTTP::Handler

    def route(path : String) : HTTP::Handler
      case path
      when "/"
        HomeHandler.new
      else
        ErrorNotFoundHandler.new
      end
    end

    def call(context : HTTP::Server::Context)
      handler = route(context.request.path)
      handler.call(context)
    end
  end


# start_app takes in an `AppConfig` as a *config* parameter,
# populates config consumers, registers routes and runs
# the application server.
def start_app(config : Config::App)
  handlers = [] of HTTP::Handler
  handlers << HTTP::ErrorHandler.new
  handlers << HTTP::LogHandler.new
  handlers << HTTP::CompressHandler.new if config.is_prod
  handlers << HTTP::StaticFileHandler.new config.public_dir, true, false
  handlers << Router.new

  server = HTTP::Server.new(handlers)
  server.bind_tcp config.server_host, config.server_port

  p "Running in production mode? #{config.is_prod}"
  p "Serving static assets from: #{config.public_dir}"
  p "Server starting to listen on http://#{config.server_host}:#{config.server_port}"
  server.listen
end
