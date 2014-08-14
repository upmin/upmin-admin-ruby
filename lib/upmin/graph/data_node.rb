module Upmin::Graph
  class Upmin::Graph::DataNode
    def initialize(data, options = {})
      @data = data
      @options = options
    end

    def data
      return @data
    end

    def options
      return @options
    end

    def depth
      return options[:depth] ||= 0
    end

    def editable
      return options[:editable] if options[:editable]
      return options[:editable] = true
    end

    def type
      return options[:type] ||= determine_type
    end

    def method_name
      return options[:method_name] || nil
    end



    private

    def determine_type
      # Preferably this gets set by the model, but in the case that it isn't we try to determine it with the data
      class_name = data.class.to_s.underscore.to_sym
      if class_name == :false_class || class_name == :true_class
        return :boolean
      elsif class_name == :nil_class
        return :unknown
      elsif class_name == :fixnum
        return :integer
      elsif class_name == :big_decimal
        return :decimal
      elsif class_name == :"active_support/time_with_zone"
        return :datetime
      else
        # TODO(jon): Determine if we need more for things like binary, date, timestamp, etc.
        return class_name
      end
    end
  end
end
