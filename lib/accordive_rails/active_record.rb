require 'active_support/concern'

module AccordiveRails
end

module AccordiveRails::ActiveRecord
  extend ActiveSupport::Concern

  module ClassMethods

    def support_attributes(attrs = nil)
      raise "Invalid argument" unless attrs.is_a?(Hash)
      raise "Invalid argument" unless attrs.has_key?(:exclude)

      attrs[:exclude] = attrs[:exclude].map { |a| a.to_sym }
      @excluded_support_attrs ||= []

      attrs[:exclude].each do |attr|
        @excluded_support_attrs << attr unless @excluded_support_attrs.include?(attr)
      end

      return @excluded_support_attrs
    end

    def support_attribute?(attr)
      @excluded_support_attrs ||= []
      return @excluded_support_attrs.exclude?(attr.to_sym)
    end

    def exclude_support_attribute?(attr)
      @excluded_support_attrs ||= []
      return @excluded_support_attrs.include?(attr.to_sym)
    end

    def support_methods(*meths)
      meths = meths.map{ |m| m.to_sym }
      @support_methods ||= []

      meths.each do |meth|
        @support_methods << meth unless @support_methods.include?(meth)
      end

      return @support_methods
    end
    alias :support_method :support_methods

  end
end
