module Upmin
  class Model

    attr_accessor :rails_model
    attr_accessor :color

    def initialize(rails_model, options = {})
      self.rails_model = rails_model

      if options[:color]
        self.color = options[:color]
      end
    end

    def to_s
      return rails_model.to_s
    end

    def name
      return rails_model.name
    end

    def form_name
      return rails_model.name.underscore
    end

    # Wrapper methods that the normal model would have access to
    def find(id)
      return rails_model.find(id)
    end


    ## Search Methods

    ### Search indexing methods
    def admin_search_index
      return rails_model.admin_search_index
    end

    def Model.admin_search_indexes
      ret = {}
      Model.all.each do |model|
        ret[model.to_s] = model.admin_search_index if model.admin_search_index
      end
      return ret
    end

    def updated_since(date)
      rails_model.where("updated_at > ?", date)
    end


    ## Generic Class Methods

    def Model.find(name)
      return all.select{|a| a.to_s == name}.first
    end

    # TODO(jon): Store this in the future so it doesn't have to be looked up every call.
    def Model.all
      return @models_array if defined?(@models_array)
      models_array = []
      colors = [
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

      rails_models.each_with_index do |rails_model, i|
        ac_model = Model.new(rails_model, color: colors[i % colors.length])
        models_array << ac_model
      end

      return @models_array = models_array
    end

    def Model.rails_models
      ::Rails.application.eager_load!
      rails_models = ::ActiveRecord::Base.descendants.select do |m|
        m.to_s != "ActiveRecord::SchemaMigration"
      end

      return rails_models
    end

  end
end
