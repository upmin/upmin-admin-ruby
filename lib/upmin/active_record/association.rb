module Upmin::ActiveRecord
  module Association

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

      if @type == :unknown
        @type = infer_type_from_value
      end

      return @type
    end

    def collection?
      if reflection
        return reflection.collection?
      elsif value
        return value.responds_to?(:each)
      else
        return false
      end
    end


    private

      def reflection
        return @reflection if defined?(@reflection)
        @reflection = model.model_class.reflect_on_all_associations.select do |r|
            r.name == name
        end.first
        return @reflection
      end

  end
end
