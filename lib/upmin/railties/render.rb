
module Upmin::Railties
  module Render

    # Render method that is used by upmin-admin. Tries to render partials in order, passing data in as the :object, along with options.
    def up_render(data, options = {})
      if data.is_a?(Upmin::Model)
        options = RenderHelpers.model_options(data, options)
        partials = RenderHelpers.model_partials(data, options)

      elsif data.is_a?(Upmin::Attribute)
        options = RenderHelpers.attribute_options(data, options)
        partials = RenderHelpers.attribute_partials(data, options)

      elsif data.is_a?(Upmin::AttributeValue)
        options = RenderHelpers.attribute_value_options(data, options)
        partials = RenderHelpers.attribute_value_partials(data, options)

      elsif data.is_a?(Upmin::Association)
        options = RenderHelpers.association_options(data, options)
        partials = RenderHelpers.association_partials(data, options)

      elsif data.is_a?(Upmin::Action)
        options = RenderHelpers.action_options(data, options)
        partials = RenderHelpers.action_partials(data, options)

      elsif data.is_a?(Upmin::Parameter)
        options = RenderHelpers.parameter_options(data, options)
        partials = RenderHelpers.parameter_partials(data, options)

      elsif data.is_a?(Upmin::Query)
        options = RenderHelpers.search_results_options(data, options)
        partials = RenderHelpers.search_results_partials(data, options)

      elsif data.superclass == Upmin::Model
        # Probably rendering a search box
        options = RenderHelpers.search_box_options(data, options)
        partials = RenderHelpers.search_box_partials(data, options)

      else
        raise Upmin::ArgumentError.new(data)
      end

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
      raise Upmin::MissingPartial.new(data)
    end

  end
end
