module Raleigh::Controllers
  # `Home` is the controller for the following:
  #
  # `GET: /`
  class Home
    def render(ctx : Ctx, params : Params)
      ctx.response.content_type = "text/html"
      ctx.response.status_code = 200
      ctx.response.print render_page "pages/home", "default", nil
    end
  end
end
