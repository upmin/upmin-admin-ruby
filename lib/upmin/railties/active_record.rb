require 'active_support/concern'

module Upmin::Railties
  module ActiveRecord
    extend ::ActiveSupport::Concern

    included do
      after_save :notify_upmin_of_save
    end

    def notify_upmin_of_save
      # TODO(jon): Add after_save notifications.
    end

    def upmin_attributes
      return self.class.upmin_attributes
    end

    def upmin_associations
      return self.class.upmin_associations
    end

    def upmin_collection_reflections
      return self.class.upmin_collection_reflections
    end

    def upmin_name(type = :plural)
      return self.class.upmin_name(type)
    end

    def upmin_color
      return self.class.upmin_color
    end

    def upmin_attr_editable?(attr_name)
      return false if attr_name.to_sym == :id
      return false if attr_name.to_sym == :created_at
      return false if attr_name.to_sym == :updated_at
      # TODO(jon): Add a way to lock this later
      return self.respond_to?("#{attr_name}=")
    end

    def upmin_attr_type(attr_name)
      if uc = self.class.columns_hash[attr_name.to_s]
        return uc.type
      else
        return :unknown
      end
    end

    def upmin_get_attr(attr_name)
      return send(attr_name)
    end

    def upmin_get_assoc(assoc_name)
      assoc_name = assoc_name.to_sym
      if upmin_collection_reflections.include?(assoc_name)
        return send(assoc_name).limit(5)
      else
        return send(assoc_name)
      end
    end

    module ClassMethods

      def upmin_attributes(*attributes)
        if attributes.any?
          @upmin_attributes = attributes.map{|a| a.to_sym}
        end
        @upmin_attributes ||= attribute_names.map{|a| a.to_sym}
        return @upmin_attributes
      end

      def upmin_associations(*associations)
        if associations.any?
          @upmin_associations = associations.map{|a| a.to_sym}
        end
        return @upmin_associations if defined?(@upmin_associations)

        # TODO(jon): Make this handle through relationships and ignore those.
        upmin_associations = []
        ignored_associations = []
        self.reflect_on_all_associations.each do |reflection|
          upmin_associations << reflection.name.to_sym
          if reflection.is_a?(::ActiveRecord::Reflection::ThroughReflection)
            ignored_associations << reflection.options[:through]
          end
        end
        return @upmin_associations = upmin_associations - ignored_associations
      end

      def upmin_collection_reflections
        return @upmin_collection_reflections if defined?(@upmin_collection_reflections)
        collections = self.reflect_on_all_associations.select do |r|
          r.collection?
        end.map do |r|
          r.name
        end
        return @upmin_collection_reflections = collections
      end

      # def upmin_collections(*collections)
      #   if collections.any?
      #     @upmin_collections = collections.map{|a| a.to_sym}
      #   end
      #   return @upmin_collections if defined?(@upmin_collections)

      #   @upmin_collections = []
      #   ignored_collections
      #   self.reflect_on_all_associations.each do |reflection|
      #     @upmin_collections.name.to_sym << if reflection.collection?
      #     if reflection.is_a?(ActiveRecord::Reflection::ThroughReflection)
      #       # We need to figure out what collection to ignore.
      #       @upmin_collections.name.to_sym
      #     end
      #   end
      #   return @upmin_collections
      # end

      def upmin_actions(*actions)
        if actions.any?
          @upmin_actions = actions.map{|a| a.to_sym}
        end
        @upmin_actions ||= []
        return @upmin_actions
      end

      def upmin_name(type = :plural)
        names = name.gsub(/([a-z])([A-Z])/, "#{$1} #{$2}").split(" ")
        if type == :plural
          names[names.length-1] = names.last.pluralize
        end
        return names.join(" ")
      end

      def upmin_color
        return @upmin_color if defined?(@upmin_color)
        return @upmin_color = Upmin::Model.find(self.name).color
      end

    end
  end
end
