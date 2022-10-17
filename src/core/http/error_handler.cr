require "http"

# Http module contains specialized handlers, helpers and other useful
# tools that the `HTTP` package lacks.
module Raleigh::Core::Http
  class ErrorHandler
    include HTTP::Handler

    # Creates a new `HTTP::Handler` which catches Http errors and allows for
    # customizing the way you can respond to these.
    def initialize(@log = Log.for("http.server")); end

    def call(context)
      begin
        call_next context
      rescue ex : Athena::Routing::Exception::ResourceNotFound
        @log.info(exception: ex.cause) { ex.message }
        context.response.content_type = "text/plain"
        context.response.status_code = 404
        context.response.print "No such route as #{context.request.path}"
      rescue ex : Athena::Routing::Exception::MethodNotAllowed
        @log.info(exception: ex.cause) { ex.message }
        context.response.respond_with_status(:method_not_allowed)
      rescue ex : Exception
        @log.error(exception: ex) { "Error: unhandled exception" }
        unless context.response.closed? || context.response.wrote_headers?
          context.response.respond_with_status(:internal_server_error)
        end
      end
    end
  end
end
