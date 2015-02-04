module Upmin
  class AttributeValue
    attr_reader :attribute
    
    def initialize(attribute, options = {})
      @attribute = attribute
    end

  end
end
