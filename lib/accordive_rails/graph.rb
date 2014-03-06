module AccordiveRails
  class Graph

    attr_accessor :user
    attr_accessor :nodes

    def initialize
      self.nodes = build_nodes
      self.user = find_user_node
    end

    def build_nodes
      ret = {}
      models.each do |model|
        ret[model.to_s] = Node.new(model)
      end
      return ret
    end

    def find_user_node
      potential_matches = ["User", "Customer", "Account", "Company"]
      potential_matches.each do |class_name|
        nodes.each do |model, node|
          return node if model == class_name
        end
      end
      return nil
    end

    def node(model)
      return nodes[model.to_s]
    end

    def models
      return @models unless @models.nil?

      ::Rails.application.eager_load!
      @models = ActiveRecord::Base.descendants.select do |m|
        m.to_s != "ActiveRecord::SchemaMigration"
      end

      return @models
    end

  end
end
