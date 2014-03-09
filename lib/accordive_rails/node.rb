module AccordiveRails
  class Node

    attr_accessor :model
    attr_accessor :attributes
    attr_accessor :associations
    attr_accessor :actions

    def initialize(model)
      self.model = model
      self.attributes = build_attributes
      self.associations = build_associations
      self.actions = build_actions
    end

    def reflections
      model.reflect_on_all_associations
    end

    def association(model)
      return associations[model]
    end

    def build_attributes
      attributes = model.attribute_names.map{ |a| a.to_sym }
      return attributes.select do |attr|
        model.support_attribute?(attr)
      end
    end

    def build_associations
      ret = {}
      reflections.each do |reflection|
        ret[reflection.class_name] = Association.new(reflection)
        if reflection.macro == :belongs_to
          attributes.delete(reflection.foreign_key.to_sym)
        end
      end
      return ret
    end

    def build_actions
      ret = []
      model.support_methods.each do |meth|
        ret << Action.new(model, meth)
      end
      return ret
    end

    def paginate(page = 0, limit = 25, order = "id")
      return model.order(order).limit(limit).offset(page*limit)
    end

    def instance(query = {})
      return Singleton.new(self, query)
    end

  end
end
