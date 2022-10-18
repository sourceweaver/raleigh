require "./app"

module Raleigh
  VERSION = "0.1.0"

  # Builds and returns a `Config:App` struct. Some values are obtained by
  # environment variables, and their inexistence will cause an exception
  # so make sure you handle them when you're calling this method.
  #
  # Example:
  #
  # ```
  # config = build_config
  # rescue ex
  #   p! "Error: missing ENV variables"
  # ```
  def self.build_config : Config::App
    is_prod = ENV["PRODUCTION"] == "true" ? true : false

    Config::App.new(
      is_prod: is_prod,
      server_host: is_prod ? "0.0.0.0" : "localhost",
      server_port: 3000,
      public_dir: is_prod ? "assets" : "src/assets",
      admin: ENV["ADMIN_NAME"],
      password: ENV["ADMIN_PWD"],
    )
  end

  # Run calls `#build_config` and if successful, calls `App#start` with the
  # configuration it obtained.
  def self.run
    config = build_config
  rescue ex
    Log.fatal { "Error: you have not provided required environment variable\n #{ex.message}" }

    app = App.new config if config
    app.try(&.start)
  end

  run
end
