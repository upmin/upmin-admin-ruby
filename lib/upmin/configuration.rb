module Upmin
  # Add Config Stuff to Upmin
  class << self
    attr_accessor :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration) if block_given?
    end
  end

  class Configuration
    attr_writer :models
    attr_writer :colors

    def initialize
      if defined?(ActiveRecord)
        # Eager load on init so even if models are set custom an eager load has happened.
        ::Rails.application.eager_load!
      end
    end

    def colors
      return @colors ||= default_colors
    end

    def models
      return @models ||= default_models
    end

    private

      def default_models
        if defined?(ActiveRecord)
          # If Rails
          ::Rails.application.eager_load!
          rails_models = ::ActiveRecord::Base.descendants
            .map(&:to_s)
            .select{ |m| m != "ActiveRecord::SchemaMigration" }
            .sort
            .map(&:underscore)
            .map(&:to_sym)
          return rails_models
        else
          raise UnsupportedObjectMapper.new
        end
      end

      def default_colors
        return [
          :light_blue,
          :blue_green,
          :red,
          :yellow,
          :orange,
          :purple,
          :dark_blue,
          :dark_red,
          :green
        ]
      end

  end
end
