
module Upmin::Railties
  module RenderHelpers

    def RenderHelpers.model_partials(upmin_model, options)
      partials = []
      partials << build_model_path(upmin_model.klass.name.underscore)
      partials << build_model_path(:unknown)
      return partials
    end

    def RenderHelpers.attribute_partials(upmin_model, attr_name, options)
      partials = []
      # <model_name>_<attr_name>, eg: user_name
      # <model_name>_<attr_type>, eg: user_string
      # <attr_type>, eg: string
      # unknown
      model_name = upmin_model.klass.name.underscore
      attr_type = upmin_model.attribute_type(attr_name)

      partials << build_attribute_path("#{model_name}_#{attr_name}")
      partials << build_attribute_path("#{model_name}_#{attr_type}")
      partials << build_attribute_path(attr_type)
      partials << build_attribute_path(:unknown)
      return partials
    end

    # def RenderHelpers.action_partials(upmin_model, action, options)
    #   partials = []
    #   partials << build_action_path(:unknown)
    #   return partials
    # end


    # NOTE: assoc_type is sketchy at best. It tries to determine it, but in some cases it has to be guessed at, so if you have polymorphic associations it will choose the data type of the first association it finds - eg if user.things returns [Order, Product, Review] it will use the type of "order"
    def RenderHelpers.association_partials(upmin_model, assoc_name, options)
      partials = []
      # <model_name>_<assoc_name>, eg: user_recent_orders
      # <model_name>_<assoc_type>, eg: user_orders
      # <attr_type>, eg: orders
      # unknown
      model_name = upmin_model.klass.name.underscore
      assoc_type = upmin_model.association_type(assoc_name)

      partials << build_association_path("#{model_name}_#{assoc_name}")
      partials << build_association_path("#{model_name}_#{assoc_type}")
      partials << build_association_path(assoc_type)
      partials << build_association_path(:unknown)
      return partials
    end


    def RenderHelpers.build_model_path(partial_name)
      return "upmin/types/models/#{partial_name}"
    end

    def RenderHelpers.build_attribute_path(partial_name)
      return "upmin/types/attributes/#{partial_name}"
    end

    # def RenderHelpers.build_action_path(partial_name)
    #   return "upmin/types/actions/#{partial_name}"
    # end

    def RenderHelpers.build_association_path(partial_name)
      return "upmin/types/associations/#{partial_name}"
    end















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

    def RenderHelpers.partials_for_search_box(upmin_model, options)
      partials = []
      partials << options[:partial] if options[:partial]
      partials << build_search_box_path(options[:as]) if options[:as]
      partials << build_search_box_path(upmin_model.partial_name)
      partials << build_search_box_path(:unknown)
      return partials
    end

    def RenderHelpers.build_path(partial)
      return "upmin/types/#{partial}"
    end


    def RenderHelpers.build_search_box_path(partial)
      return "upmin/search_boxes/#{partial}"
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
