module Upmin::Graph
  class ModelNode
    def initialize(model, options = {})
      @model = model
      @options = options
    end

    def model
      return @model
    end

    def options
      return @options
    end

    def depth
      return options[:depth] ||= 0
    end

    def editable
      return options[:editable] if options[:editable]
      return options[:editable] = true
    end

    def type
      return options[:type] ||= determine_type
    end

    def method_name
      return options[:method_name] || nil
    end


    def attributes
      return @attributes ||= create_attributes
    end

    def children
      if depth >= 2
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

    private
      def determine_type
        name = model.class.to_s.underscore.to_sym
        if depth == 0
          return name
        elsif depth == 1
          return "#{name}_nested".to_sym
        else
          return "#{name}_badge".to_sym
        end
      end

      def create_attributes
        attributes = {}
        editable = (depth == 0)

        model.upmin_attributes.each do |u_attr|
          attributes[u_attr] = DataNode.new(
            model.upmin_get_attr(u_attr), {
            depth: depth + 1,
            editable: editable && model.upmin_attr_editable?(u_attr),
            type: model.upmin_attr_type(u_attr),
            method_name: u_attr
          })
        end
        return attributes
      end

      def create_children
        singletons = []
        collections = []

        model.upmin_associations.each do |association|
          puts "Association=#{association}"
          v = model.upmin_get_assoc(association)
          puts "Value for assoc is: #{v} #{v.inspect}"
          options = {
            depth: depth + 1,
            editable: false,
            method_name: association.to_sym
          }

          if v.nil?
            singletons << DataNode.new(nil, options.merge(type: :unknown))
          elsif v.is_a?(ActiveRecord::Base)
            singletons << ModelNode.new(v, options)
          else
            collections << CollectionNode.new(v, options)
          end
        end

        @singletons = singletons
        @collections = collections
        return @singletons + @collections
      end

  end
end
