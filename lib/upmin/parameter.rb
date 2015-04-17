module Upmin
  class Parameter
    attr_reader :action
    attr_reader :name

    def initialize(action, parameter_name, options = {})
      @action = action
      @name = parameter_name.to_sym
      @type = options[:type] if options[:type]
    end

    def model
      return action.model
    end

    def title
      return name.to_s.humanize
    end

    def label_name
      name.to_s.capitalize.tr("_", " ")
    end

    def type
      return @type if defined?(@type)
      @type = action.model.method(action.name).parameters.select do |param_type, param_name|
        param_name == name
      end.first.first || :req
      return @type
    end

    def form_id
      return "#{action.name}_#{name}"
    end

    def nil_form_id
      return "#{form_id}_is_nil"
    end

    private

  end
end
