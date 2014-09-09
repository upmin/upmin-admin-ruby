
module Upmin::Railties
  module RenderHelpers

    def RenderHelpers.model_partials(upmin_model, options)
      partials = []
      # <options[:as]>
      # <model_name>
      # model

      partials << build_model_path(options[:as]) if options[:as]
      partials << build_model_path(upmin_model.klass.name.underscore)
      partials << build_model_path(:model)
      return partials
    end

    def RenderHelpers.attribute_partials(upmin_model, attr_name, options)
      partials = []
      # <options[:as]>
      # <model_name>_<attr_name>, eg: user_name
      # <model_name>_<attr_type>, eg: user_string
      # <attr_type>, eg: string
      # unknown

      model_name = upmin_model.klass.name.underscore
      attr_type = upmin_model.attribute_type(attr_name)

      partials << build_attribute_path(options[:as]) if options[:as]
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
      # <options[:as]>
      # <model_name>_<assoc_name>, eg: user_recent_orders
      # <model_name>_<assoc_type>, eg: user_orders
      # <attr_type>, eg: orders
      # associations
      model_name = upmin_model.klass.name.underscore
      assoc_type = upmin_model.association_type(assoc_name)

      partials << build_association_path(options[:as]) if options[:as]
      partials << build_association_path("#{model_name}_#{assoc_name}")
      partials << build_association_path("#{model_name}_#{assoc_type}")
      partials << build_association_path(assoc_type)
      partials << build_association_path(:associations)
      return partials
    end

    def RenderHelpers.action_partials(upmin_model, action_name, options)
      partials = []
      # <options[:as]>
      # <model_name>_<action_name>, eg: order_refund
      # <action_name>, eg: refund
      # action
      model_name = upmin_model.klass.name.underscore

      partials << build_action_path(options[:as]) if options[:as]
      partials << build_action_path("#{model_name}_#{action_name}")
      partials << build_action_path(action_name)
      partials << build_action_path(:action)
      return partials
    end

    def RenderHelpers.search_results_partials(ransack_search, options)
      partials = []
      # <options[:as]>
      # <model_name # plural>, eg: orders
      # results
      model_name_plural = ransack_search.klass.name.underscore.pluralize

      partials << build_search_result_path(options[:as]) if options[:as]
      partials << build_search_result_path(model_name_plural)
      partials << build_search_result_path(:results)
      return partials
    end

    def RenderHelpers.search_result_partials(upmin_model, options)
      partials = []
      # <options[:as]>
      # <model_name # singular>, eg: order
      # results
      model_name = upmin_model.klass.name.underscore

      partials << build_search_result_path(options[:as]) if options[:as]
      partials << build_search_result_path(model_name)
      partials << build_search_result_path(:result)
      return partials
    end

    def RenderHelpers.search_box_partials(klass, options)
      partials = []
      # <options[:as]>
      # ransack_search_box

      partials << build_search_box_path(options[:as]) if options[:as]
      partials << build_search_box_path(:ransack_search_box)
      return partials
    end


    def RenderHelpers.build_model_path(partial_name)
      return "#{root_path}/models/#{partial_name}"
    end

    def RenderHelpers.build_attribute_path(partial_name)
      return "#{root_path}/attributes/#{partial_name}"
    end

    def RenderHelpers.build_action_path(partial_name)
      partial_name = partial_name.to_s.gsub(/[!?]/, "")
      return "#{root_path}/actions/#{partial_name}"
    end

    def RenderHelpers.build_association_path(partial_name)
      return "#{root_path}/associations/#{partial_name}"
    end

    def RenderHelpers.build_search_result_path(partial_name)
      return "#{root_path}/search_results/#{partial_name}"
    end

    def RenderHelpers.build_search_box_path(partial_name)
      return "#{root_path}/search_boxes/#{partial_name}"
    end

    def RenderHelpers.root_path
      return "upmin/partials"
    end

  end
end
