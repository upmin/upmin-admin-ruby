module Upmin
  module AutomaticDelegation
    extend ActiveSupport::Concern

    # Delegates missing instance methods to the source model.
    def method_missing(method, *args, &block)
      if delegatable?(method)
        self.class.delegate(method, to: :model)
        send(method, *args, &block)
      else
        return super
      end
    end

    def delegatable?(method)
      model.respond_to?(method)
    end

    def respond_to?(method)
      super || delegatable?(method)
    end

    module ClassMethods
      # Proxies missing class methods to the source class.
      def method_missing(method, *args, &block)
        return super unless delegatable?(method)

        model_class.send(method, *args, &block)
      end

      def delegatable?(method)
        model_class? && model_class.respond_to?(method)
      end

      # Avoids reloading the model class when ActiveSupport clears autoloaded
      # dependencies in development mode.
      def before_remove_const
      end
    end

  end
end
