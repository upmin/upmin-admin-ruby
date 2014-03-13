module AccordiveRails
  class Model

    attr_accessor :rails_model

    def initialize(rails_model)
      self.rails_model = rails_model
    end

    def method_missing(m, *args, &block)
      @query_methods ||= [
        :all,
        :where,
        :limit,
        :order,
        :offset,
        :first,
        :count
      ]

      if @query_methods.include?(m.to_sym)
        return rails_model.send(m, *args, &block)
      else
        super
      end
    end

    def attribute_type(attribute)
      if rails_model.columns_hash[attribute.to_s]
        return rails_model.columns_hash[attribute.to_s].type
      else
        return nil
      end
    end

    def support_attributes
      return rails_model.support_attributes
    end

    def support_attribute?(attribute)
      return support_attributes.include?(attribute.to_sym)
    end


    def support_methods
      return rails_model.support_methods
    end

    def support_method?(method)
      return support_methods.include?(method.to_sym)
    end


    def support_associations
      return rails_model.support_associations.map { |method, a| a }
    end

    def support_association(method)
      return rails_model.support_associations[method.to_sym]
    end

    def support_association?(method)
      return !!support_association(method)
    end



    @@models = nil

    def self.models=(models)
      @@models = models
    end

    def self.models
      return @@models if @@models

      models = {}
      rails_models.each do |rails_model|
        models[rails_model.to_s] = Model.new(rails_model)
      end
      return models
    end

    def self.all
      return models.map { |rails_model_str, model| model }
    end

    def self.for(rails_model)
      return rails_model if rails_model.is_a?(AccordiveRails::Model)
      return models[rails_model.to_s]
    end

    def self.rails_models
      ::Rails.application.eager_load!
      rails_models = ::ActiveRecord::Base.descendants.select do |m|
        m.to_s != "ActiveRecord::SchemaMigration"
      end

      return rails_models
    end
  end
end
