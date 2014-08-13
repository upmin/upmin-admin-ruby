module Upmin
  module Datatypes
    class Boolean

      def initialize(val = false)
        @val = val
      end

      def to_s
        return @val.to_s
      end

      def value
        return @val
      end

    end
  end
end
