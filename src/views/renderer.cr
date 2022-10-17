# render_page will expand *file* and *layout* string parameters
#
# ```
# content = "src/app/views/pages/#{filename}.ecr"
# layout = "src/app/views/layouts/#{layout}.ecr"
#
# ```
# You can then reference these variables on your ECR file.
# Any data structures that you want to access via your ECR
# file should be passed as the *data* parameter.
macro render_page(filename, layout, data)
  content_buff = IO::Memory.new
  ECR.embed "src/views/{{filename.id}}.ecr", content_buff
  content = content_buff.to_s

  layout_buff = IO::Memory.new
  ECR.embed "src/views/layouts/{{layout.id}}.ecr", layout_buff
  layout_buff.to_s
end

# render_partial will expand the *filename* string parameter
#
# ```
# partial = "src/app/views/partials/_#{filename}.ecr"
# ```
#
# You can call this macro to render various partials in a single
# ECR file, generally from your layout file.
macro render_partial(filename)
  partial_buff = IO::Memory.new
  ECR.embed "src/views/partials/_{{filename.id}}.ecr", partial_buff
  partial = partial_buff.to_s
end
