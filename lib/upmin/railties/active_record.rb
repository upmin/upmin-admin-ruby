require 'active_support/concern'

module Upmin::Railties
  module ActiveRecord
    extend ::ActiveSupport::Concern

    def upmin_model
      klass = Upmin::Model.find_class(self.class)
      return klass.new(self)
    end

    included do
    end

    module ClassMethods
    end
  end
end
