require "spec"
require "http"

require "../src/app"

# spec_client = HTTP::Client.new("localhost", 3000)

config = Raleigh::Config::App.new(
  is_prod: false,
  server_host: "localhost",
  server_port: 3000,
  public_dir: "src/assets",
  admin: "John",
  password: "123"
)
app = Raleigh::App.new(config)

def spec_client : HTTP::Client
  HTTP::Client.new "localhost", 3000
end

Spec.before_suite do
  spawn do
    app.start
  end
end

Spec.after_suite do
  app.stop
end
