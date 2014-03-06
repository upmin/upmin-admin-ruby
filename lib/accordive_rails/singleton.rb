module AccordiveRails
  class Singleton

    attr_accessor :node
    attr_accessor :query
    attr_accessor :instance

    def initialize(node, query)
      raise "Invalid query" unless query.is_a?(Hash)

      self.node = node
      self.query = query
      self.instance = node.model.where(query).first
    end

  end
end
