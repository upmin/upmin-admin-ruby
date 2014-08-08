module Upmin
  class Model

    attr_accessor :rails_model

    def initialize(rails_model)
      self.rails_model = rails_model
    end

    def to_s
      return rails_model.to_s
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
      models_array = []

      rails_models.each do |rails_model|
        ac_model = Model.new(rails_model)
        models_array << ac_model
      end

      return models_array
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
