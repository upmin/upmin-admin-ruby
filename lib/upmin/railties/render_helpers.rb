
module Upmin::Railties
  module RenderHelpers

    def RenderHelpers.model_partials(model, options = {})
      partials = []
      # Add "new_" in front of any partial for the partial for new view.
      # <options[:as]>
      # <model_name>
      # model
      prefix = model.new_record? ? "new_" : ""

      partials << build_model_path(options[:as]) if options[:as]
      partials << build_model_path(model.underscore_name, prefix)
      partials << build_model_path(:model, prefix)
      return partials
    end

    def RenderHelpers.model_options(model, options = {})
      options[:locals] ||= {}
      options[:locals][:model] ||= model
      return options
    end

    def RenderHelpers.build_model_path(partial, prefix = "")
      return build_path("models", "#{prefix}#{partial}")
    end



    def RenderHelpers.attribute_partials(attribute, options = {})
      partials = []
      # <options[:as]>
      # <model_name>_<attr_name>, eg: user_name
      # <model_name>_<attr_type>, eg: user_string
      # <attr_type>, eg: string
      # unknown

      model_name = attribute.model.underscore_name
      attr_type = attribute.type

      partials << build_attribute_path(options[:as]) if options[:as]
      partials << build_attribute_path("#{model_name}_#{attribute.name}")
      partials << build_attribute_path("#{model_name}_#{attr_type}")
      partials << build_attribute_path(attribute.name)
      partials << build_attribute_path(attr_type)
      partials << build_attribute_path(:unknown)
      return partials
    end

    def RenderHelpers.attribute_options(attribute, options = {})
      options[:locals] ||= {}
      options[:locals][:model] ||= attribute.model
      options[:locals][:attribute] = attribute
      return options
    end

    def RenderHelpers.build_attribute_path(partial)
      return build_path("attributes", partial)
    end



    def RenderHelpers.attribute_value_partials(attribute_value, options = {})
      attribute = attribute_value.attribute
      partials = []
      # <options[:as]>
      # <model_name>_<attr_name>, eg: user_name
      # <model_name>_<attr_type>, eg: user_string
      # <attr_type>, eg: string
      # unknown

      model_name = attribute.model.underscore_name
      attr_type = attribute.type

      partials << build_attribute_value_path(options[:as]) if options[:as]
      partials << build_attribute_value_path("#{model_name}_#{attribute.name}")
      partials << build_attribute_value_path("#{model_name}_#{attr_type}")
      partials << build_attribute_value_path(attribute.name)
      partials << build_attribute_value_path(attr_type)
      partials << build_attribute_value_path(:unknown)
      return partials
    end

    def RenderHelpers.attribute_value_options(attribute_value, options = {})
      attribute = attribute_value.attribute
      options[:locals] ||= {}
      options[:locals][:model] ||= attribute.model
      options[:locals][:attribute] = attribute
      return options
    end

    def RenderHelpers.build_attribute_value_path(partial)
      return build_path("attribute_values", partial)
    end



    # NOTE: assoc_type is sketchy at best. It tries to determine it, but in some cases it has to be guessed at, so if you have polymorphic associations it will choose the data type of the first association it finds - eg if user.things returns [Order, Product, Review] it will use the type of "order"
    def RenderHelpers.association_partials(association, options = {})
      partials = []
      # <options[:as]>
      # <model_name>_<assoc_name>, eg: user_recent_orders
      # <model_name>_<assoc_type>, eg: user_orders
      # <attr_type>, eg: orders
      # associations
      model_name = association.model.underscore_name
      assoc_type = association.type

      partials << build_association_path(options[:as]) if options[:as]
      partials << build_association_path("#{model_name}_#{association.name}")
      partials << build_association_path("#{model_name}_#{assoc_type}")
      partials << build_association_path(association.name)
      partials << build_association_path(assoc_type)
      partials << build_association_path(:associations)
      return partials
    end

    def RenderHelpers.association_options(association, options = {})
      options[:locals] ||= {}
      options[:locals][:model] ||= association.model
      options[:locals][:association] = association
      return options
    end

    def RenderHelpers.build_association_path(partial)
      return build_path("associations", partial)
    end



    def RenderHelpers.action_partials(action, options = {})
      partials = []
      # <options[:as]>
      # <model_name>_<action_name>, eg: order_refund
      # <action_name>, eg: refund
      # action
      model_name = action.model.underscore_name

      partials << build_action_path(options[:as]) if options[:as]
      partials << build_action_path("#{model_name}_#{action.name}")
      partials << build_action_path(action.name)
      partials << build_action_path(:action)
      return partials
    end

    def RenderHelpers.action_options(action, options = {})
      options[:locals] ||= {}
      options[:locals][:model] ||= action.model
      options[:locals][:action] = action
      return options
    end

    def RenderHelpers.build_action_path(partial)
      return build_path("actions", partial)
    end



    def RenderHelpers.parameter_partials(parameter, options = {})
      partials = []
      # <options[:as]>
      # <model_name>_<action_name>_<param_name>, eg: order_refund_amount
      # <action_name>_<param_name>, eg: refund_amount
      # <param_name>, eg: amount
      # <param_type>_parameter, eg: opt_parameter and req_parameter
      model_name = parameter.model.underscore_name
      action_name = parameter.action.name

      partials << build_parameter_path(options[:as]) if options[:as]
      partials << build_parameter_path("#{model_name}_#{action_name}_#{parameter.name}")
      partials << build_parameter_path("#{action_name}_#{parameter.name}")
      partials << build_parameter_path(parameter.name)
      partials << build_parameter_path("#{parameter.type}_parameter")
      return partials
    end

    def RenderHelpers.parameter_options(parameter, options = {})
      options[:locals] ||= {}
      options[:locals][:model] ||= parameter.model
      options[:locals][:action] ||= parameter.action
      options[:locals][:parameter] = parameter
      return options
    end

    def RenderHelpers.build_parameter_path(partial)
      return build_path("parameters", partial)
    end



    def RenderHelpers.search_results_partials(query, options = {})
      partials = []
      # <options[:as]>
      # <model_name # plural>, eg: orders
      # results
      model_name_plural = query.underscore_name(:plural)

      partials << build_search_results_path(options[:as]) if options[:as]
      partials << build_search_results_path(model_name_plural)
      partials << build_search_results_path(:results)
      return partials
    end

    def RenderHelpers.search_results_options(query, options = {})
      options[:locals] ||= {}
      options[:locals][:query] = query
      return options
    end

    def RenderHelpers.build_search_results_path(partial)
      return build_path("search_results", partial)
    end



    def RenderHelpers.search_box_partials(klass, options = {})
      partials = []
      # <options[:as]>
      # <model_name>_search_box, eg: order_search_box
      # ransack_search_box
      model_name = klass.underscore_name

      partials << build_search_box_path(options[:as]) if options[:as]
      partials << build_search_box_path("#{model_name}_search_box")
      partials << build_search_box_path(:ransack_search_box)
      return partials
    end

    def RenderHelpers.search_box_options(klass, options = {})
      options[:locals] ||= {}
      options[:locals][:klass] = klass
      return options
    end

    def RenderHelpers.build_search_box_path(partial)
      return build_path("search_boxes", partial)
    end



    def RenderHelpers.build_path(folder, partial)
      partial = partial.to_s.gsub(/[!?]/, "")
      "#{root_path}/#{folder}/#{partial}"
    end

    def RenderHelpers.root_path
      return "upmin/partials"
    end

  end
end
