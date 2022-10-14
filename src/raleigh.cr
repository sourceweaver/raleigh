require "./app"

# Config is a struct that is required by the start_app method.
# TODO: Move this config to it's own directory once you start
# start a project using this template.
module Config
  struct App
    getter is_prod : Bool

    getter server_host : String = "0.0.0.0"
    getter server_port : Int32 = 3000
    getter public_dir : String = "src/assets"

    def initialize(@is_prod, @server_host, @server_port, @public_dir); end
  end
end

module Raleigh
  VERSION = "0.1.0"

  def self.run
    is_prod = ENV["PRODUCTION"] == "true" ? true : false

    app_config = Config::App.new(
      is_prod: is_prod,

      server_host: "127.0.0.1",
      server_port: 3000,
      public_dir: is_prod ? "assets" : "src/assets",
    )

    start_app(app_config)
  end

  run
end
