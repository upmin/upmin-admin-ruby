module Upmin::Graph
  class CollectionNode
    def initialize(collection, options = {})
      @collection = collection
      @options = options
    end

    def collection
      return @collection
    end
    alias_method :object, :collection

    def options
      return @options
    end

    def depth
      return options[:depth] ||= 0
    end

    def editable?
      return options[:editable] if options[:editable]
      return options[:editable] = false
    end

    def type
      return options[:type] ||= determine_type
    end

    def method_name
      return options[:method_name] || nil
    end

    def nodes
      return @nodes ||= create_nodes
    end

    private
      def determine_type
        # TODO(jon): Maybe optimize multi-type collections? Prob don't need this much work to figure them out.
        if collection.any?
          klasses = collection.map{|c| c.class.to_s.underscore.to_sym}
          if klasses.uniq.length == 1
            return "#{klasses.first}_collection".to_sym
          end
        end

        if method_name
          return "#{method_name.to_s.singularize}_collection"
        else
          return :unknown_collection
        end
      end

      def create_nodes
        nodes = []
        node_options = {
          depth: depth,
          editable: editable?
        }
        collection.each do |collection_item|
          if collection_item.is_a?(ActiveRecord::Base)
            nodes << ModelNode.new(collection_item, node_options)
          else
            nodes << DataNode.new(collection_item, node_options)
          end
        end
        return nodes
      end

  end
end
