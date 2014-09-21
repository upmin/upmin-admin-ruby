module Upmin
  class Model

    class << self

      attr_writer :model_names

      def model_names
        @model_names ||= {}
      end

    end

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

    def new_record?
      return instance.new_record?
    end

    ## Methods for getting attributes, associations, etc and anything relevant to them.


    # Returns the type of an attribute. If it is nil and we can't
    # figure it out from the db columns we just fall back to
    # :unknown
    def attribute_type(attr_name)
      type = klass.attribute_type(attr_name)

      if type == :unknown
        # See if we can deduce it by looking at the data
        data = attribute(attr_name)
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
      # TODO(jon): Add a way to declare which attributes are editable and which are not later.
      return instance.respond_to?("#{attr_name}=")
    end

    # Returns the value of the attr_name method
    def attribute(attr_name)
      attr_name = attr_name.to_sym
      # TODO(jon): Add some way to handle exceptions. Probably a custom error that we display.
      return instance.send(attr_name)
    end

    def attribute_form_id(attr_name)
      return "#{klass.name.underscore}_#{attr_name}"
    end

    def attribute_label_name(attr_name)
      return attr_name.to_s.gsub(/_/, " ").capitalize
    end


    # Returns the type of an association. If we can't figure it
    # out we fall back to :unknown
    def association_type(assoc_name)
      type = klass.association_type(assoc_name)
      if type == :unknown && data = association(assoc_name).first
        type = data.class.name.underscore
      end
      return type
    end

    def association(assoc_name, options = {})
      association = instance.send(assoc_name)
      if association.respond_to?(:each)
        # We have a collection, at least we hope we do.
        if options[:limit] && association.respond_to?(:limit)
          association = association.limit(5)
        end
      end
      return association
    end

    def action_parameters(action)
      instance.method(action).parameters
    end

    def perform_action(action, arguments)
      unless klass.actions.include?(action.to_sym)
        raise "Invalid action: #{action}"
      end

      params = action_parameters(action)
      params_array = []
      params.each do |param_type, param_name|
        if param_type == :req
          raise "Missing argument: #{param_name}" unless arguments[param_name]
          params_array << arguments[param_name]
        elsif param_type == :opt
          params_array << arguments[param_name] if arguments[param_name]
        else # :block or ??
          next
        end
      end
      return instance.send(action, *params_array)
    end


  end
end
