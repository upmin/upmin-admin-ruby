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
      ::Rails.application.eager_load!
    end

    def colors
      return @colors ||= default_colors
    end

    def models
      return @models ||= default_models
    end

    private

      def default_models
        def_models = []
        orm_found = false

        if defined?(Rails) && Rails.application
          ::Rails.application.eager_load!
        else
          raise "We kinda need rails for a rails engine :("
        end

        if defined?(ActiveRecord)
          orm_found = true
          ::Rails.application.eager_load!
          def_models += ::ActiveRecord::Base.descendants
            .map(&:to_s)
            .select{ |m| m != "ActiveRecord::SchemaMigration" }
            .sort
            .map(&:underscore)
            .map(&:to_sym)
        end

        if defined?(DataMapper)
          orm_found = true
          ::Rails.application.eager_load!
          def_models += ::DataMapper::Model.descendants.entries
            .map(&:to_s)
            .sort
            .map(&:underscore)
            .map(&:to_sym)
        end

        unless orm_found
          raise UnsupportedObjectMapper.new
        end

        return def_models
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
