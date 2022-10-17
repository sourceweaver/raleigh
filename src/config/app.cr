# Config module contains the data structures that contain the configs
# of different services.
module Raleigh::Config
  # App struct holds the data for App config.
  struct App
    getter is_prod : Bool
    getter server_host : String
    getter server_port : Int32
    getter public_dir : String

    getter admin : String
    getter password : String

    def initialize(@is_prod, @server_host, @server_port, @public_dir,
                   @admin, @password); end
  end
end
