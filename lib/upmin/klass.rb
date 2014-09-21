module Upmin
  class Klass

    attr_accessor :model
    attr_accessor :color

    def initialize(model, options = {})
      self.model = model

      if options[:color]
        self.color = options[:color]
      end
    end

    def new(*args)
      m = model.new(*args)
      return Upmin::Model.new(m)
    end

    # Exposing a model method, but wrapping the result in
    # an Upmin::Model
    def find(*args)
      return Upmin::Model.new(model.find(*args))
    end

    def ransack(*args)
      return model.ransack(*args)
    end


    # Returns all of the upmin attributes for the ActiveRecord model
    # referenced by this Klass object.
    def attributes
      return model.upmin_attributes
    end

    # Returns the type for an attribute by checking the columns
    # hash. If no match can be found, :unknown is returned.
    # NOTE - the Upmin::Model version of this will look at the
    # actual contents of the attr_name if :unknown is returned,
    # so this version is more accurate if you can use it.
    def attribute_type(attr_name)
      if connection_adapter = model.columns_hash[attr_name.to_s]
        return connection_adapter.type
      else
        return :unknown
      end
    end


    # Returns all of the upmin actions for the ActiveRecord model
    # referenced by this Klass object.
    def actions
      return model.upmin_actions
    end

    # Returns all associations that are not used in through associations
    # eg - an Order's products, but not an order's product_orders that link the two.
    def associations
      return @associations if defined?(@associations)

      all = []
      ignored = []
      model.reflect_on_all_associations.each do |reflection|
        all << reflection.name.to_sym

        # We need to remove the ignored later because we don't know the order they come in.
        if reflection.is_a?(::ActiveRecord::Reflection::ThroughReflection)
          ignored << reflection.options[:through]
        end
      end

      return @associations = all - ignored
    end

    # Tries to find an association type based on the reflection
    def association_type(assoc_name)
      reflection = reflections.select { |r| r.name == assoc_name.to_sym }.first

      if reflection
        return reflection.foreign_type.to_s.gsub(/_type$/, "").pluralize.to_sym
      else
        return :unknown
      end
    end

    def plural_associations
      return model.reflect_on_all_associations
        .select{ |r| r.collection? }
        .map{ |r| r.name.to_sym }
    end

    def reflections
      return model.reflect_on_all_associations
    end



    ## Methods for prettying up things to display them in views etc.

    # Returns the class name, split at camelCase,
    # with the last word pluralized if it is plural.
    def humanized_name(type = :plural)
      names = model.name.split(/(?=[A-Z])/)
      if type == :plural
        names[names.length-1] = names.last.pluralize
      end
      return names.join(" ")
    end

    # Returns the class name, capitalized as it would be with User.name or OrderShipment.name - "User", or "OrderShipment"
    def name
      return model.name
    end

    def path_hash
      return {
        klass: klass.name
      }
    end



    ## Class Methods

    # Takes a Rails ActiveRecord or the name of one and returns an
    # Upmin::Klass instance of the model.
    def Klass.find(model)
      return all.select{|k| k.name == model.to_s}.first
    end

    # Returns an array of all Klass instances
    def Klass.all
      return @all if defined?(@all)
      all = []

      models.each_with_index do |model, i|
        klass = Klass.new(model, color: colors[i % colors.length])
        all << klass
      end

      return @all = all
    end

    def Klass.colors
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

    def Klass.models
      # If Rails
      ::Rails.application.eager_load!
      rails_models = ::ActiveRecord::Base.descendants.select do |m|
        m.to_s != "ActiveRecord::SchemaMigration"
      end

      return rails_models
    end

  end
end
