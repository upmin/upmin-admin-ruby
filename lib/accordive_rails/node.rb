module AccordiveRails
  class Node

    attr_accessor :model
    attr_accessor :attributes
    attr_accessor :associations

    def initialize(model)
      self.model = model
      self.attributes = model.attribute_names.map{ |a| a.to_sym }
      self.associations = build_associations
    end

    def reflections
      model.reflect_on_all_associations
    end

    def association(model)
      return associations[model]
    end

    def build_associations
      ret = {}
      reflections.each do |reflection|
        ret[eval(reflection.class_name)] = Association.new(reflection)
      end
      return ret
    end

    def instance(query = {})
      return Singleton.new(self, query)
    end

  end
end
