
module Upmin::Railties
  module Render
    def upmin_render(model_or_node, options = {})
      if model_or_node.is_a?(::ActiveRecord::Base)
        upmin_render_node(Upmin::Graph::ModelNode.new(model_or_node), options)

      else # is a node
        upmin_render_node(model_or_node, options)
      end
    end

    def upmin_render_node(node, options = {})
      partials = RenderHelpers.partials_for(node, options)

      # TODO(jon): Update this to use something like https://coderwall.com/p/ftbmsa instead of a rescue
      partials.each do |partial|
        puts "Trying #{partial}"
        begin
          return render(
            partial: partial,
            object: node.object, # this doesn't work with nil
            locals: {
              node: node,
              options: options,
              RenderHelpers.object_name(partial) => node.object
            }
          )
        rescue ActionView::MissingTemplate => e
          puts e
          puts e.message
        end
      end
      raise "Failed to find a matching partial, even with fallback :unknown partials"
    end
  end
end
