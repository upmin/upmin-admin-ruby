
module Upmin::Railties
  module Render

    def up_search_results(ransack_search, ransack_results, options = {})
      # options[:locals] ||= {}
      # options[:locals][:klass] ||= Upmin::Klass.find(ransack_search.klass)
      # options[:locals][:ransack_search] ||= ransack_search
      # options[:locals][:ransack_results] ||= ransack_results

      # partials = RenderHelpers.search_results_partials(ransack_search, options)

      # return up_render(ransack_results, partials, options, :up_search_results)
    end

    def up_search_result(model, options = {})
      # options[:locals] ||= {}

      # upmin_model = Upmin::AdminModel.new(model)
      # options[:locals][:upmin_model] ||= upmin_model

      # partials = RenderHelpers.search_result_partials(upmin_model, options)

      # return up_render(model, partials, options, :up_search_result)
    end

    def up_search_box(klass, options = {})
      # options[:locals] ||= {}

      # klass = Upmin::Klass.find(klass) unless klass.is_a?(Upmin::Klass)
      # if klass.nil?
      #   raise "Invalid klass provided in `up_search_box`"
      # end

      # options[:locals][:klass] = klass

      # partials = RenderHelpers.search_box_partials(klass, options)

      # return up_render(klass, partials, options, :up_search_box)
    end



    # Generic render method that is used by upmin-admin. Tries to render partials in order, passing data in as the :object, along with options.
    def up_render(data, options = {})
      if data.is_a?(Upmin::AdminModel)
        options = RenderHelpers.model_options(data, options)
        partials = RenderHelpers.model_partials(data, options)
      elsif data.is_a?(Upmin::Attribute)
        options = RenderHelpers.attribute_options(data, options)
        partials = RenderHelpers.attribute_partials(data, options)
      elsif data.is_a?(Upmin::Association)
        options = RenderHelpers.association_options(data, options)
        partials = RenderHelpers.association_partials(data, options)
      elsif data.is_a?(Upmin::Action)
        options = RenderHelpers.action_options(data, options)
        partials = RenderHelpers.action_partials(data, options)
      elsif data.is_a?(Upmin::Parameter)
        options = RenderHelpers.parameter_options(data, options)
        partials = RenderHelpers.parameter_partials(data, options)
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
