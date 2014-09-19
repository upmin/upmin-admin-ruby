module Upmin
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
    attr_accessor :colors
    attr_accessor :models

    def models
      @models ||= default_models
    end

    def initialize
      @colors = default_colors
    end

    private
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

      def default_models
        # If Rails
        ::Rails.application.eager_load!
        rails_models = ::ActiveRecord::Base.descendants.select { |m|
          m.to_s != "ActiveRecord::SchemaMigration"
        }.map(&:to_s).sort

        return rails_models
      end

  end
end