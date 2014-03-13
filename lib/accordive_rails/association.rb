module AccordiveRails
  class Association

    attr_accessor :method
    attr_accessor :model
    attr_accessor :collection

    def initialize(method, model, collection)
      self.method = method
      self.model = model
      self.collection = collection
    end

    def collection?
      !!collection
    end

    def singular?
      !collection
    end

  end
end
