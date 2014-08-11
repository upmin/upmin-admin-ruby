
module Upmin
end

module Upmin::RenderHelpers
  def upmin_render(object, options = {})
    partial = u_determine_partial(object, options)

    begin
      render(
        partial: partial,
        object: object,
        locals: { options: options }
      )
    rescue ActionView::MissingTemplate
      if options[:as] || options[:partial]
        raise "Invalid partial or as option in Upmin.render"
      else
        # 2 major cases get us here
        # 1. We tried to render a model specific partial (eg a _user) and failed,
        #    so we need to fall back to a generic instance
        # 2. We tried to render a data type that wasn't support, and we need
        #    to fall back to something like plain text.
        # For now I am assuming the former, and for case #2 we will throw an error
        # and address it as it comes up.
        # TODO(jon): Make this handle invalid data types later with like text
        partial = u_data_partial_path(:instance)
        render(
          partial: partial,
          object: object,
          locals: { options: options }
        )
      end
    end
  end

  def u_determine_partial(object, options = {})
    return options[:partial] if options[:partial]
    return u_data_partial_path(options[:as]) if options[:as]
    return u_data_partial_path(object.class.to_s.underscore)
  end

  def u_data_partial_path(datatype)
    return "upmin/datatypes/#{datatype}"
  end
end

