module Upmin
  class Model

    attr_accessor :instance
    attr_accessor :klass

    def initialize(instance, options = {})
      self.instance = instance
      self.klass = Upmin::Klass.find(instance.class.name)
    end

    ## Methods for rendering in views
    def title
      return "#{klass.humanized_name(:singular)} # #{instance.id}"
    end

    def color
      return klass.color
    end

    def path_hash
      return {
        klass: klass.name,
        id: instance.id
      }
    end

    ## Methods for getting attributes, associations, etc and anything relevant to them.


    # Returns the type of an attribute. If it is nil and we can't
    # figure it out from the db columns we just fall back to
    # :unknown
    def attribute_type(attr_name)
      type = klass.attribute_type(attr_name)

      if type == :unknown
        # See if we can deduce it by looking at the data
        class_sym = data.class.to_s.underscore.to_sym
        if class_sym == :false_class || class_sym == :true_class
          type = :boolean
        elsif class_sym == :nil_class
          type = :unknown
        elsif class_sym == :fixnum
          type = :integer
        elsif class_sym == :big_decimal
          type = :decimal
        elsif class_sym == :"active_support/time_with_zone"
          type = :datetime
        else
          # This should prevent any classes from being skipped, but we may not have an exhaustive list yet.
          type = class_sym
        end
      end

      return type
    end

    # Returns whether or not the attr_name is an attribute that can be edited.
    def attribute_editable?(attr_name)
      attr_name = attr_name.to_sym
      return false if attr_name == :id
      return false if attr_name == :created_at
      return false if attr_name == :updated_at
      # TODO(jon): Add a way to lock this later
      return instance.respond_to?("#{attr_name}=")
    end

    # Returns the value of the attr_name method
    def attribute(attr_name)
      attr_name = attr_name.to_sym
      unless klass.attributes.include?(attr_name)
        raise "Invalid attribute. #{attr_name} not declared in upmin_attributes."
      end
      return instance.send(attr_name)
    end

    def attribute_form_id(attr_name)
      return "#{klass.name.underscore}_#{attr_name}"
    end

  end
end
