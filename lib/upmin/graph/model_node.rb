module Upmin::Graph
  class ModelNode
    def initialize(model, options = {})
      @model = model
      @options = options
    end

    def model
      return @model
    end
    alias_method :object, :model

    def options
      return @options
    end

    def depth
      return options[:depth] ||= 0
    end

    def editable?
      return options[:editable] if options[:editable]
      return options[:editable] = true
    end

    def type
      return options[:type] ||= determine_type
    end

    def method_name
      return options[:method_name] || nil
    end

    def name
      return model.upmin_name(:singular)
    end

    def title
      # TODO(jon): Add block option for custom defined titles
      return "#{name} # #{model.id}"
    end

    def color
      return model.upmin_color
    end

    def path_hash
      return {
        model_name: model.class.to_s,
        id: model.id
      }
    end

    # TODO(jon): Add the following methods:


    def attributes
      return @attributes ||= create_attributes
    end

    def children
      if depth >= 1
        return [] # nothing beyond a depth of 2
      else
        return @children ||= create_children
      end
    end

    def singletons
      return @singletons if @singletons
      create_children # backfill this if not defined
      return @singletons
    end

    def collections
      return @collections if @collections
      create_children # backfill this if not defined
      return @collections
    end

    def type_prefix
      name = model.class.to_s.underscore
      return name
    end

    def type_suffix
      if depth == 0
        return "_model"
      elsif depth >= 1
        return "_model_nested"
      # else
      #   return "_model_badge"
      end
    end

    private
      def determine_type
        return "#{type_prefix}#{type_suffix}".to_sym
      end

      def create_attributes
        attributes = {}
        editable = (depth == 0)

        model.upmin_attributes.each do |u_attr|
          attributes[u_attr] = DataNode.new(
            model.upmin_get_attr(u_attr), {
            depth: depth + 1,
            editable: editable && model.upmin_attr_editable?(u_attr),
            type: model.attribute_type(u_attr),
            method_name: u_attr,
            parent_name: model.class.to_s.underscore
          })
        end
        return attributes
      end

      def create_children
        singletons = {}
        collections = {}

        model.upmin_associations.each do |association|
          puts "Association=#{association}"
          v = model.upmin_get_assoc(association)
          puts "Value for assoc is: #{v} #{v.inspect}"
          options = {
            depth: depth + 1,
            editable: (depth == 0),
            method_name: association.to_sym
          }
          puts options.inspect
          puts options.inspect
          puts options.inspect
          puts options.inspect

          if v.nil?
            singletons[association] = DataNode.new(nil, options.merge(type: :unknown))
          elsif v.is_a?(ActiveRecord::Base)
            singletons[association] = ModelNode.new(v, options)
          else
            collections[association] = CollectionNode.new(v, options)
          end
        end

        @singletons = singletons
        @collections = collections
        return @singletons.merge(@collections)
      end

  end
end
