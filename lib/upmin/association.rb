module Upmin
  class Association
    attr_reader :model
    attr_reader :name

    def initialize(model, assoc_name, options = {})
      @model = model
      @name = assoc_name.to_sym
    end

    def value
      # TODO(jon): Add some way to handle exceptions.
      return model.send(name)
    end

    def type
      return @type if defined?(@type)

      if reflection
        @type = reflection.foreign_type.to_s.gsub(/_type$/, "")
        if collection?
          @type = @type.pluralize.to_sym
        else
          @type = @type.to_sym
        end
      else
        @type = :unknown
      end

      if @type == :unknown && first = [value].flatten.first
        @type = first.class.name.underscore
        if collection? || value.responds_to?(:each)
          @type = @type.pluralize.to_sym
        else
          @type = @type.to_sym
        end
      end

      return @type
    end

    def collection?
      return reflection.collection?
    end

    def reflection
      return @reflection if defined?(@reflection)
      @reflection = model.model_class.reflect_on_all_associations.select do |r|
          r.name == name
      end.first
      return @reflection
    end


    private

      def infer_type_from_value
        if reflection
          type = reflection.foreign_type.to_s.gsub(/_type$/, "")
          if collection?
            return type.pluralize.to_sym
          else
            return type.to_sym
          end
        else
          return :unknown
        end
      end

  end
end
