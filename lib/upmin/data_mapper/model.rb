module Upmin::DataMapper
  module Model
    extend ActiveSupport::Concern

    def new_record?
      return model.new?
    end

    def to_key
      return [model.id]
    end


    module ClassMethods
      # NOTE - ANY method added here must be added to the bottom of
      # Upmin::Model. This ensures that an instance of the class was
      # created, which in turn ensures that the correct module was
      # included in the class.

      def find(*args)
        return model_class.get(*args)
      end

      def default_attributes
        return model_class.properties.map(&:name)
      end

      def attribute_type(attribute)
        property = model_class.properties.select{ |p| p.name == attribute }.first
        type = property.class.to_s.demodulize.underscore.to_sym

        case type
        when :serial
          return :integer
        when :date_time
          return :datetime
        else
          return type
        end
      end

      def associations
        return @associations if defined?(@associations)

        all = []
        ignored = []
        model_class.relationships.each do |relationship|
          all << relationship.name

          # This may need dropped later if we find that it is more useful to show these.
          if relationship.is_a?(DataMapper::Associations::ManyToMany::Relationship)
            ignored << relationship.options[:through]
          end
        end

        return @associations = (all - ignored).uniq
      end

    end

  end
end
