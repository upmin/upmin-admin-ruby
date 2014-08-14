
module Upmin::Railties
  module RenderHelpers
    def RenderHelpers.partials_for(node, options)
      partials = []
      partials << options[:partial] if options[:partial]
      partials << build_path(options[:as]) if options[:as]
      partials << build_path(node.type)

      if node.is_a?(Upmin::Graph::ModelNode)
        partials << build_path("unknown#{node.type_suffix}")
      elsif node.is_a?(Upmin::Graph::CollectionNode)
        # TODO(jon): Maybe add in support for method_name later
        if node.type != :unknown_collection
          partials << build_path(:unknown_collection)
        end
      elsif node.is_a?(Upmin::Graph::DataNode)
        # TODO(jon): Maybe add in support for method_name later
        if node.type != :unknown
          partials << build_path(:unknown)
        end
      else
        # WTF? Add unknown as a backup, but this likely isn't even a node.
        partials << build_path(:unknown)
      end

      return partials
    end

    def RenderHelpers.build_path(partial)
      return "upmin/types/#{partial}"
    end

    def RenderHelpers.object_name(partial)
      if match = partial.match(/.*\/(.*)/)
        return match.captures.first
      else
        raise "Unable to match object name for the partial #{partial}."
      end
    end

  end
end
