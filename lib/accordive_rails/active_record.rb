require 'active_support/concern'
require 'accordive_rails/association'
require 'accordive_rails/instance'

module AccordiveRails
end

module AccordiveRails::ActiveRecord
  extend ActiveSupport::Concern

  def accordify
    return AccordiveRails::Instance.new(self)
  end

  module ClassMethods

    def support_attributes(*attrs)
      @support_attributes ||= attribute_names.map { |a| a.to_sym }

      if attrs.empty?
        return @support_attributes
      elsif attrs.first.is_a?(Hash)
        hash = attrs.first
        if hash[:exclude].is_a?(Array)
          hash[:exclude].each do |excluded_attr|
            @support_attributes.delete(excluded_attr.to_sym)
          end
        else
          @support_attributes.delete(hash[:exclude])
        end
      else
        attrs.each do |attr|
          @support_attributes << attr.to_sym
        end
      end
      return @support_attributes
    end
    alias :support_attribute :support_attributes

    def support_methods(*meths)
      meths = meths.map { |m| m.to_sym }
      @support_methods ||= []

      meths.each do |meth|
        @support_methods << meth unless @support_methods.include?(meth)
      end

      return @support_methods
    end
    alias :support_method :support_methods

    def support_associations(*assocs)
      unless @support_associations
        @support_associations ||= {}
        reflect_on_all_associations.each do |reflection|
          method = reflection.name.to_sym
          model = eval(reflection.class_name)
          collection = reflection.collection?

          @support_associations[method] =
            AccordiveRails::Association.new(method, model, collection)
        end
      end

      if assocs.empty?
        return @support_associations
      elsif assocs.first.is_a?(Hash)
        hash = assocs.first
        if hash[:exclude].is_a?(Array)
          hash[:exclude].each do |excluded_attr|
            @support_associations.delete(excluded_attr.to_sym)
          end
        else
          @support_associations.delete(hash[:exclude])
        end
      else
        assocs.each do |assoc|
          @support_associations << assoc.to_sym
        end
      end
      return @support_associations
    end
    alias :support_association :support_associations

    def search_with(*meths)
      meths = meths.map { |m| m.to_sym }
      @support_search_methods ||= []

      meths.each do |meth|
        @support_search_methods << meth unless @support_search_methods.include?(meth)
      end

      return @support_search_methods
    end
  end
end
