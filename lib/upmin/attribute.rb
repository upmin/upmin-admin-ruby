module Upmin
  class Attribute
    attr_reader :model
    attr_reader :name

    def initialize(model, attr_name, options = {})
      @model = model
      @name = attr_name.to_sym
    end

    def value
      # TODO(jon): Add some way to handle exceptions.
      return model.send(name)
    end

    def type
      # TODO(jon): Add a way to override with widgets?
      return @type if defined?(@type)

      # Try to get it from the model_class
      @type = model.class.attribute_type(name)

      # If we still don't know the type, try to infer it from the value
      if @type == :unknown
        @type = infer_type_from_value
      end

      return @type
    end

    def editable?
      case name.to_sym
      when :id
        return false
      when :created_at
        return false
      when :updated_at
        return false
      else
        # TODO(jon): Add a way to declare which attributes are editable and which are not later.
        return model.respond_to?("#{name}=")
      end
    end

    def errors?
      return model.errors[name].any?
    end

    def label_name
      return name.to_s.gsub(/_/, " ").capitalize
    end

    def form_id
      return "#{model.underscore_name}_#{name}"
    end

    def nilable_id
      return "#{form_id}_is_nil"
    end


    private

      def infer_type_from_value
        class_sym = value.class.to_s.underscore.to_sym
        if class_sym == :false_class || class_sym == :true_class
          return :boolean
        elsif class_sym == :nil_class
          return :unknown
        elsif class_sym == :fixnum
          return :integer
        elsif class_sym == :big_decimal
          return :decimal
        elsif class_sym == :"active_support/time_with_zone"
          return :datetime
        else
          # This should prevent any classes from being skipped, but we may not have an exhaustive list yet.
          return class_sym
        end
      end

  end
end
