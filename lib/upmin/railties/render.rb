
module Upmin::Railties
  module Render

    def up_model(model, options = {})
      options[:locals] ||= {}

      upmin_model = Upmin::Model.new(model)
      options[:locals][:upmin_model] ||= upmin_model

      partials = RenderHelpers.model_partials(upmin_model, options)
      return up_render(model, partials, options, :up_model)
    end

    def up_attribute(model, attr_name, options = {})
      options[:locals] ||= {}
      options[:locals][:model] ||= model
      options[:locals][:attr_name] = attr_name

      upmin_model = Upmin::Model.new(model)
      options[:locals][:upmin_model] ||= upmin_model

      options[:locals][:form_id] ||= upmin_model.attribute_form_id(attr_name)
      # Only fill this in if it was never set so the user can override this.
      if options[:locals][:editable].nil?
        options[:locals][:editable] = upmin_model.attribute_editable?(attr_name)
      end


      partials = RenderHelpers.attribute_partials(upmin_model, attr_name, options)

      data = upmin_model.attribute(attr_name)
      return up_render(data, partials, options, :up_attribute)
    end

    def up_association(model, assoc_name, options = {})
      options[:locals] ||= {}
      options[:locals][:model] ||= model
      options[:locals][:assoc_name] = assoc_name

      upmin_model = Upmin::Model.new(model)
      options[:locals][:upmin_model] ||= upmin_model

      partials = RenderHelpers.association_partials(upmin_model, assoc_name, options)

      data = upmin_model.association(assoc_name, options)
      return up_render([data].flatten, partials, options, :up_association)
    end

    def up_action(model, action_name, options = {})
      options[:locals] ||= {}
      options[:locals][:model] ||= model
      options[:locals][:action_name] = action_name

      upmin_model = Upmin::Model.new(model)
      options[:locals][:upmin_model] ||= upmin_model

      partials = RenderHelpers.action_partials(upmin_model, action_name, options)

      data = upmin_model.action_parameters(action_name)
      return up_render(data, partials, options, :up_action)
    end

    def up_search_results(ransack_search, ransack_results, options = {})
      options[:locals] ||= {}
      options[:locals][:klass] ||= Upmin::Klass.find(ransack_search.klass)
      options[:locals][:ransack_search] ||= ransack_search
      options[:locals][:ransack_results] ||= ransack_results

      partials = RenderHelpers.search_results_partials(ransack_search, options)

      return up_render(ransack_results, partials, options, :up_search_results)
    end

    def up_search_result(model, options = {})
      options[:locals] ||= {}

      upmin_model = Upmin::Model.new(model)
      options[:locals][:upmin_model] ||= upmin_model

      partials = RenderHelpers.search_result_partials(upmin_model, options)

      return up_render(model, partials, options, :up_search_result)
    end

    def up_search_box(klass, options = {})
      options[:locals] ||= {}

      klass = Upmin::Klass.find(klass) unless klass.is_a?(Upmin::Klass)
      if klass.nil?
        raise "Invalid klass provided in `up_search_box`"
      end

      options[:locals][:klass] = klass

      partials = RenderHelpers.search_box_partials(klass, options)

      return up_render(klass, partials, options, :up_search_box)
    end


    # Generic render method that is used by all of the up_<something> methods. Tries to render the partials in order, passing data in as the :object, along with options.
    def up_render(data, partials, options = {}, calling_method = nil)
      # Use options as the render hash, and set :object as the data being used for rendering.
      options[:object] = data

      partials.each do |partial|
        begin
          options[:partial] = partial
          return render(options)
        rescue ActionView::MissingTemplate => e
        end
      end

      # If we get here we tried all of the partials and nothing matched. This *shouldn't* be possible but might happen if partials are deleted.
      raise "Failed to find a matching partial while trying to render `#{calling_method}` with the following data: #{data.inspect}"
    end

  end
end
