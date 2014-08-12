
module Upmin
end

module Upmin::RenderHelpers
  def upmin_render(object, options = {})
    partial = u_determine_partial(object, options)
    options[:nest_level] ||= -1 # since we are about to add 1 to it.
    options[:nest_level] += 1

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
        if object.is_a?(ActiveRecord::Base)
          partial = u_data_partial_path(:active_record)
          render(
            partial: partial,
            object: object,
            locals: { options: options }
          )
        else
          partial = u_data_partial_path(:unknown)
          puts "Partial path: #{partial}"
          render(
            partial: partial,
            object: object,
            locals: { options: options, unknown: object }
          )
        end
      end
    end
  end

  def u_determine_partial(object, options = {})
    # Defined partials
    if options[:partial]
      return options.delete(:partial)
    elsif options[:as]
      return u_data_partial_path(options.delete(:as))
    end

    # Associations
    if object.is_a?(ActiveRecord::AssociationRelation)
      return u_data_partial_path(:association_relation)
    end
    if object.is_a?(ActiveRecord::Associations::CollectionProxy)
      return u_data_partial_path(:collection_proxy)
    end



    # True/False
    if object.is_a?(Upmin::Datatypes::Boolean)
      return u_data_partial_path(:boolean)
    end

    # Otherwise try based on data class
    return u_data_partial_path(object.class.to_s.underscore)
  end

  def u_data_partial_path(datatype)
    return "upmin/datatypes/#{datatype}"
  end

  def u_partial_as(partial_path)
    partial_path.match(/.*\/(.+$)/).captures.first
  end
end

