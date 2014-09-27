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
      return model.respond_to?(method)
    end

    def delegated?(method)
      return self.class.delegated?(method)
    end

    def respond_to?(method)
      super || delegatable?(method)
    end

    def method(method_name)
      if delegated?(method_name)
        return model.method(method_name)
      else
        return super(method_name)
      end
    rescue NameError => e
      if delegatable?(method_name)
        self.class.delegate(method_name, to: :model)
        return method(method_name)
      else
        super(method_name)
      end
    end

    module ClassMethods
      # Proxies missing class methods to the source class.
      def method_missing(method, *args, &block)
        return super unless delegatable?(method)

        model_class.send(method, *args, &block)
      end

      def delegatable?(method)
        @test ||={}
        @test[method] ||= 0
        @test[method] += 1
        puts "Method=#{method}"
        puts "Class=#{self.class.name}"
        return false if @test[method] > 2
        model_class? && model_class.respond_to?(method)
      end

      def delegate(method, *args)
        @delegated ||= []
        @delegated << method.to_sym
        super(method, *args)
      end

      def delegated?(method)
        @delegated ||= []
        return @delegated.include?(method.to_sym)
      end

      # Avoids reloading the model class when ActiveSupport clears autoloaded
      # dependencies in development mode.
      def before_remove_const
      end
    end

  end
end
