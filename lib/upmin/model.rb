module Upmin
  class Model
    include Upmin::Engine.routes.url_helpers
    include Upmin::AutomaticDelegation

    attr_reader :model
    alias_method :object, :model # For delegation

    def initialize(model = nil, options = {})
      if model.is_a?(Hash)
        unless model.has_key?(:id)
          raise ":id or model instance is required."
        end
        @model = self.class.find(model[:id])
      elsif model.nil?
        @model = self.model_class.new
      else
        @model = model
      end
    end

    def path
      if new_record?
        return upmin_new_model_path(klass: model_class_name)
      else
        return upmin_model_path(klass: model_class_name, id: id)
      end
    end

    def create_path
      return upmin_create_model_path(klass: model_class_name)
    end

    def title
      return "#{humanized_name(:singular)} # #{id}"
    end

    def attributes
      return @attributes if defined?(@attributes)
      @attributes = []
      self.class.attributes.each do |attr_name|
        @attributes << Upmin::Attribute.new(self, attr_name)
      end
      return @attributes
    end

    def associations
      return @associations if defined?(@associations)
      @associations = []
      self.class.associations.each do |assoc_name|
        @associations << Upmin::Association.new(self, assoc_name)
      end
      return @associations
    end

    def actions
      return @actions if defined?(@actions)
      @actions = []
      self.class.actions.each do |action_name|
        @actions << Upmin::Action.new(self, action_name)
      end
      return @actions
    end



    ###########################################################
    ### Rails methods that may need mapped to something     ###
    ### else with other ORMs                                ###
    ###########################################################

    def new_record?
      if self.class.active_record?
        return model.new_record?
      elsif self.class.data_mapper?
        return model.new?
      end
    end

    def to_key
      if self.class.active_record?
        return model.to_key
      elsif self.class.data_mapper?
        # TODO(jon): Make this better, but this may work for now.
        return [model.id]
      end
    end



    ###########################################################
    ###  Delegated instance methods                         ###
    ###########################################################

    # TODO(jon): Figure out why delegations here weren't working in 3.2 tests
    # delegate(:color, to: :class)
    def color
      return self.class.color
    end
    # delegate(:humanized_name, to: :class)
    def humanized_name(type = :plural)
      return self.class.humanized_name(type)
    end
    # delegate(:underscore_name, to: :class)
    def underscore_name
      return self.class.underscore_name
    end
    # delegate(:model_class, to: :class)
    def model_class
      return self.class.model_class
    end
    # delegate(:model_class_name, to: :class)
    def model_class_name
      return self.class.model_class_name
    end




    ###########################################################
    ###  Class methods                                      ###
    ###########################################################

    def Model.associations
      return @associations if defined?(@associations)

      all = []
      ignored = []
      model_class.reflect_on_all_associations.each do |reflection|
        all << reflection.name.to_sym

        # We need to remove the ignored later because we don't know the order they come in.
        if reflection.is_a?(::ActiveRecord::Reflection::ThroughReflection)
          ignored << reflection.options[:through]
        end
      end

      return @associations = all - ignored
    end

    def Model.find(*args)
      if data_mapper?
        model_class.get(*args)
      elsif active_record?
        model_class.find(*args)
      end
    end


    def Model.find_class(model)
      return find_or_create_class(model.to_s)
    end

    def Model.find_or_create_class(model_name)
      ::Rails.application.eager_load!
      return "Admin#{model_name}".constantize
    rescue NameError
      eval("class ::Admin#{model_name} < Upmin::Model; end")
      return "Admin#{model_name}".constantize
    end

    # Returns all upmin models.
    def Model.all
      return @all if defined?(@all)
      @all = []
      Upmin.configuration.models.each do |m|
        @all << find_or_create_class(m.to_s.camelize)
      end
      return @all
    end

    def Model.model_class
      @model_class ||= inferred_model_class
    end

    def Model.model_class?
      return model_class
    rescue Upmin::UninferrableSourceError
      return false
    end

    def Model.model_class
      return @model_class ||= inferred_model_class
    end

    def Model.inferred_model_class
      name = model_class_name
      return name.constantize
    rescue NameError => error
      raise if name && !error.missing_name?(name)
      raise Upmin::UninferrableSourceError.new(self)
    end

    def Model.model_class_name
      raise NameError if name.nil? || name.demodulize !~ /Admin.+$/
      return name.demodulize[5..-1]
    end

    def Model.model_name
      return ActiveModel::Name.new(model_class)
    end

    def Model.humanized_name(type = :plural)
      names = model_class_name.split(/(?=[A-Z])/)
      if type == :plural
        names[names.length-1] = names.last.pluralize
      end
      return names.join(" ")
    end

    def Model.underscore_name(type = :singular)
      if type == :singular
        return model_class_name.underscore
      else
        return model_class_name.pluralize.underscore
      end
    end

    def Model.search_path
      return Upmin::Engine.routes.url_helpers.upmin_search_path(klass: model_class_name)
    end

    def Model.color
      return @color if defined?(@color)
      @color = Model.next_color
      return @color
    end

    def Model.colors
      return Upmin.configuration.colors
    end

    def Model.next_color
      puts "Picking a color"
      @color_index ||= 0
      next_color = colors[@color_index]
      puts "colors is going to be #{next_color}"
      @color_index = (@color_index + 1) % colors.length
      puts "color index is #{@color_index}"
      return next_color
    end

    # This is not currently used, but could be used to ensure colors are always the same.
    def Model.color_index
      return @color_index if defined?(@color_index)
      @color_index = model_class_name.split("").map(&:ord).inject(:+) % colors.length
      return @color_index
    end

    def Model.active_record?
      return model_class.superclass == ActiveRecord::Base
    end

    def Model.data_mapper?
      return model_class.is_a?(DataMapper::Model)
    end


    ###########################################################
    ### Customization methods for Admin<Model> classes      ###
    ###########################################################

    # Add a single attribute to upmin attributes.
    # If this is called before upmin_attributes
    # the attributes will not include any defaults
    # attributes.
    def Model.attribute(attribute = nil)
      @extra_attrs = [] unless defined?(@extra_attrs)
      @extra_attrs << attribute.to_sym if attribute
    end

    # Sets the attributes to the provided attributes # if any are any provided.
    # If no attributes are provided then the
    # attributes are set to the default attributes of
    # the model class.
    def Model.attributes(*attributes)
      @extra_attrs = [] unless defined?(@extra_attrs)

      if attributes.any?
        @attributes = attributes.map{|a| a.to_sym}
      end
      @attributes ||= default_attributes

      return (@attributes + @extra_attrs).uniq
    end

    def Model.default_attributes
      if active_record?
        return model_class.attribute_names.map(&:to_sym)
      elsif data_mapper?
        return model_class.properties.map(&:name)
      end
    end

    def Model.attribute_type(attribute)
      if active_record?
        adapter = model_class.columns_hash[attribute.to_s]
        return adapter.type if adapter
      end
      return :unknown
    end

    # Add a single action to upmin actions. If this is called
    # before upmin_actions the actions will not include any defaults
    # actions.
    def Model.action(action)
      @actions ||= []

      action = action.to_sym
      @actions << action unless @actions.include?(action)
    end

    # Sets the upmin_actions to the provided actions if any are
    # provided.
    # If no actions are provided, and upmin_actions hasn't been defined,
    # then the upmin_actions are set to the default actions.
    # Returns the upmin_actions
    def Model.actions(*actions)
      if actions.any?
        # set the actions
        @actions = actions.map{|a| a.to_sym}
      end
      @actions ||= []
      return @actions
    end

  end
end
