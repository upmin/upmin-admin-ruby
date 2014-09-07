
module Upmin::Railties
  module Render

    def up_model(model, options = {})
      options[:locals] ||= {}

      upmin_model = Upmin::Model.new(model)
      options[:locals][:upmin_model] ||= upmin_model

      partials = RenderHelpers.model_partials(upmin_model, options)
      return up_render(model, partials, options)
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
      return up_render(data, partials, options)
    end

    def up_association(model, assoc_name, options = {})
      options[:locals] ||= {}
      options[:locals][:model] ||= model
      options[:locals][:assoc_name] = assoc_name

      upmin_model = Upmin::Model.new(model)
      options[:locals][:upmin_model] ||= upmin_model

      partials = RenderHelpers.association_partials(upmin_model, assoc_name, options)

      data = upmin_model.association(assoc_name, options)
      return up_render([data].flatten, partials, options)
    end

    def up_action(model, action_name, options = {})
      options[:locals] ||= {}
      options[:locals][:model] ||= model
      options[:locals][:action_name] = action_name

      upmin_model = Upmin::Model.new(model)
      options[:locals][:upmin_model] ||= upmin_model

      partials = RenderHelpers.action_partials(upmin_model, action_name, options)

      data = upmin_model.action_parameters(action_name)
      return up_render(data, partials, options)
    end


    # Generic render method that is used by all of the up_<something> methods. Tries to render the partials in order, passing data in as the :object, along with options.
    def up_render(data, partials, options = {})
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
      raise "Failed to find a matching partial while trying to render the following: #{object.inspect}"
    end

  end
end
