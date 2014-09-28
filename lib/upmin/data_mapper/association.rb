module Upmin::DataMapper
  module Association

    def type
      return @type if defined?(@type)

      if relationship
        # NOTE(jon): I believe many to one is the only type where child_model_name is incorrect, but I could be wrong.
        if relationship.is_a?(DataMapper::Associations::ManyToOne::Relationship)
          @type = relationship.parent_model_name
        else
          @type = relationship.child_model_name
        end

        @type = @type.underscore

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
      if relationship
        return relationship.max > 1
      elsif value
        return value.responts_to?(:each)
      else
        return false
      end
    end


    private

      def relationship
        return @relationship if defined?(@relationship)

        @relationship = model.model_class.relationships.select do |r|
          r.name == name
        end.first

        return @relationship
      end

  end
end
