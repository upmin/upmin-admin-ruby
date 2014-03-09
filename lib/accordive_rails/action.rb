module AccordiveRails
  class Action

    attr_accessor :model
    attr_accessor :method_name
    attr_accessor :params
    attr_accessor :humanized

    def initialize(model, method_name)
      self.model = model
      self.method_name = method_name
      self.humanized = method_name.to_s.humanize
      self.params = model.instance_method(method_name).parameters
    end

  end
end
