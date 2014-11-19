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
    attr_writer :colors

    def initialize
      ::Rails.application.eager_load!
    end

    def colors=(colors)
      @custom_colors = true
      @colors = colors
    end

    def colors
      if defined?(@custom_colors)
        return @colors
      else
        return default_colors
      end
    end

    def models=(models)
      @custom_models = true
      @models = models
    end

    def models
      if defined?(@custom_models)
        return @models
      else
        return default_models
      end
    end

    def items_per_page=(items)
      @custom_items_per_page = true
      @items_per_page = items
    end

    def items_per_page
      if defined?(@custom_items_per_page)
        return @items_per_page
      else
        return 30
      end
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
            .select{ |m| m.exclude? "HABTM" }
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
