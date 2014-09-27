module Upmin
  class Association
    attr_reader :model
    attr_reader :name

    def initialize(model, assoc_name, options = {})
      if model.class.active_record?
        puts "Extending AR"
        extend Upmin::ActiveRecord::Association
      elsif model.class.data_mapper?
        puts "Extending DM"
        extend Upmin::DataMapper::Association
      else
        raise ArgumentError.new(model)
      end

      @model = model
      @name = assoc_name.to_sym
    end

    def value
      # TODO(jon): Add some way to handle exceptions.
      return model.send(name)
    end

    def title
      return name.to_s.humanize
    end

    def upmin_values(options = {})
      options[:limit] ||= 5
      if collection?
        vals = [value.limit(options[:limit])].flatten
      else
        vals = [value]
      end

      return vals.map(&:upmin_model)
    end

    def type
      raise NotImplementedError
    end

    def collection?
      raise NotImplementedError
    end

    def empty?
      if collection?
        return value.count == 0
      else
        return ![value].flatten.any?
      end
    end



    private

      def infer_type_from_value
        if first = [value].flatten.first
          type = first.class.name.underscore
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
