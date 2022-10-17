require "http/server"

require "athena-routing"

require "./core/http/error_handler"
require "./config/app"
require "./controllers/home"
require "./types/types"
require "./views/renderer"

module Raleigh
  # `App` class contains the logic of initializing services, controllers,
  # routers, sub-routers, loggers and registering all handlers and routes.
  # As such It's the outer most layer of the dependency chain.
  class App
    getter server : HTTP::Server
    getter config : Config::App

    def initialize(@config)
      # Initialize router:
      router = ART::RoutingHandler.new bubble_exceptions: true

      # Initialize controllers:
      home_ctrl = Controllers::Home.new

      # Register routes:
      router.add "home", ART::Route.new("/", methods: "GET"), &->home_ctrl.render(Ctx, Params)

      # Register handlers:
      handlers = [] of HTTP::Handler
      handlers << Core::Http::ErrorHandler.new
      handlers << HTTP::LogHandler.new
      handlers << HTTP::CompressHandler.new if @config.is_prod
      handlers << HTTP::StaticFileHandler.new @config.public_dir, true, false
      handlers << router.compile

      @server = HTTP::Server.new(handlers)
      @server.bind_tcp @config.server_host, @config.server_port
    end

    # Starts the application server using the provided `Config::App`.
    def start
      Log.info { "Raleigh is starting up..." }
      Log.info { "Production mode enabled? #{@config.is_prod}" }
      Log.info { "Serving public directory: #{@config.public_dir}" }
      Log.info { "Server listening on http://#{@config.server_host}:#{config.server_port}" }

      @server.listen
    end

    # Stops the application server.
    def stop
      if server = @server
        Log.info { "Raleigh is stopping..." }
        server.close
      end
    end
  end
end
