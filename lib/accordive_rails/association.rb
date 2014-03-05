module AccordiveRails
  class Association

    attr_accessor :method
    attr_accessor :model
    attr_accessor :collection

    def initialize(reflection)
      self.method = reflection.name
      self.model = eval(reflection.class_name)
      self.collection = reflection.collection?
    end

    def collection?
      !!collection
    end

  end
end
