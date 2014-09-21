require 'active_support/concern'

module Upmin::Railties
  module ActiveRecord
    extend ::ActiveSupport::Concern

    included do
    end

    module ClassMethods

      # Add a single attribute to upmin attributes. If this is called
      # before upmin_attributes the attributes will not include any defaults
      # attributes.
      def upmin_attribute(attribute = nil)
        @upmin_extra_attrs = [] unless defined?(@upmin_extra_attrs)
        @upmin_extra_attrs << attribute.to_sym if attribute
      end

      # Sets the upmin_attributes to the provided attributes if any are
      # provided.
      # If no attributes are provided, and upmin_attributes hasn't been defined,
      # then the upmin_attributes are set to the default attributes.
      # Returns the upmin_attributes
      def upmin_attributes(*attributes)
        @upmin_extra_attrs = [] unless defined?(@upmin_extra_attrs)

        if attributes.any?
          @upmin_attributes = attributes.map{|a| a.to_sym}
        end

        @upmin_attributes ||= attribute_names.map{|a| a.to_sym}
        return (@upmin_attributes + @upmin_extra_attrs).uniq
      end


      # Add a single action to upmin actions. If this is called
      # before upmin_actions the actions will not include any defaults
      # actions.
      def upmin_action(action)
        @upmin_actions ||= []

        action = action.to_sym
        @upmin_actions << action unless @upmin_actions.include?(action)
      end

      # Sets the upmin_actions to the provided actions if any are
      # provided.
      # If no actions are provided, and upmin_actions hasn't been defined,
      # then the upmin_actions are set to the default actions.
      # Returns the upmin_actions
      def upmin_actions(*actions)
        if actions.any?
          # set the actions
          @upmin_actions = actions.map{|a| a.to_sym}
        end
        @upmin_actions ||= []
        return @upmin_actions
      end

    end
  end
end
