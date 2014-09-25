module Upmin
  class Action
    include Upmin::AutomaticDelegation

    attr_reader :model
    attr_reader :name

    def initialize(model, action_name, options = {})
      @model = model
      @name = action_name.to_sym
    end

    def title
      return name.to_s.humanize
    end

    def path
      return upmin_action_path(klass: model.model_class_name, id: model.id, method: name)
    end

    def parameters
      return @parameters if defined?(@parameters)
      @parameters = []
      model.method(name).parameters.each do |param_type, param_name|
        @parameters << Upmin::Parameter.new(self, param_name, type: param_type)
      end
      return @parameters
    end
    alias_method :arguments, :parameters

    def perform(arguments)
      array = []
      parameters.each do |parameter|
        if parameter.type == :req
          unless arguments[parameter.name]
            raise Upmin::MissingArgument.new(parameter.name)
          end
          array << arguments[parameter.name]
        elsif parameter.type == :opt
          array << arguments[parameter.name] if arguments[parameter.name]
        else # :block - skip it
        end
      end
      return model.send(name, *array)
    end

    private

  end
end
