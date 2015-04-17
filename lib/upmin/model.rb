module Upmin
  class Model
    include Upmin::Engine.routes.url_helpers
    include Upmin::AutomaticDelegation

    attr_reader :model
    alias_method :object, :model

    def initialize(model = nil, options = {})
      if self.class.active_record?
        self.class.send(:include, Upmin::ActiveRecord::Model)
      elsif self.class.data_mapper?
        self.class.send(:include, Upmin::DataMapper::Model)
      end

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

    def form_attributes
      return @form_attributes if defined?(@form_attributes)
      @form_attributes = []
      self.class.form_attributes.each do |attr_name|
        @form_attributes << Upmin::Attribute.new(self, attr_name)
      end
      return @form_attributes
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
    ###  Delegated instance methods
    ###########################################################

    # TODO(jon): Delegations here weren't working in 3.2 so this is done with normal old methods.
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
    ###  Class methods
    ###########################################################

    def Model.count(*args)
      return model_class.count(*args)
    end

    def Model.find_class(model)
      return find_or_create_class(model.to_s)
    end

    def Model.find_or_create_class(model_name)
      ::Rails.application.eager_load!

      create_name = model_name.gsub(":", "")
      return "Admin#{create_name}".constantize
    rescue NameError
      if model_name.match(/::/)
        class_str = <<-class_string
          class ::Admin#{create_name} < Upmin::Model
            def self.model_class
              return #{model_name}
            end
          end
        class_string
        eval(class_str)
      else
        eval("class ::Admin#{create_name} < Upmin::Model; end")
      end
      return "Admin#{create_name}".constantize
    end

    # Returns all upmin models.
    def Model.all
      all = []
      Upmin.configuration.models.each do |m|
        all << find_or_create_class(m.to_s.camelize)
      end
      return all
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
      name = inferred_model_class_name
      return name.constantize
    rescue NameError => error
      raise if name && !error.missing_name?(name)
      raise Upmin::UninferrableSourceError.new(self)
    end

    def Model.inferred_model_class_name
      raise NameError if name.nil? || name.demodulize !~ /Admin.+$/
      return name.demodulize[5..-1]
    end

    def Model.model_class_name
      return model_class.name
    end

    def Model.model_name
      return ActiveModel::Name.new(model_class)
    end

    def Model.humanized_name(type = :plural)
      names = @display_name ? [@display_name] : model_class_name.split(/(?=[A-Z])/).map{|n| n.gsub(":", "")}

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
      @color_index ||= 0
      next_color = colors[@color_index]
      @color_index = (@color_index + 1) % colors.length
      return next_color
    end

    # This is not currently used, but could be used to ensure colors are always the same.
    def Model.color_index
      return @color_index if defined?(@color_index)
      @color_index = model_class_name.split("").map(&:ord).inject(:+) % colors.length
      return @color_index
    end

    def Model.active_record?
      if defined?(ActiveRecord)
        return (model_class < ::ActiveRecord::Base) == true
      else
        return false
      end
    end

    def Model.data_mapper?
      if defined?(DataMapper)
        return model_class.is_a?(::DataMapper::Model)
      else
        return false
      end
    end


    ###########################################################
    ### Customization methods for Admin<Model> classes
    ###########################################################

    # Add a single attribute to upmin attributes.
    # If this is called before upmin_attributes
    # the attributes will not include any defaults
    # attributes.
    def Model.attribute(attribute = nil)
      @extra_attrs = [] unless defined?(@extra_attrs)
      @extra_attrs << attribute.to_sym if attribute
    end

    def Model.form_attribute(attribute = nil)
      @extra_form_attrs = [] unless defined?(@extra_form_attrs)
      @extra_form_attrs << attribute.to_sym if attribute
    end

    # Sets the attributes to the provided attributes # if any are any provided.
    # If no attributes are provided then the
    # attributes are set to the default attributes of
    # the model class.
    def Model.attributes(*attrs)
      @extra_attrs = [] unless defined?(@extra_attrs)

      if attrs.any?
        @attributes = attrs.map{|a| a.to_sym}
      end
      @attributes ||= default_attributes

      return (@attributes + @extra_attrs).uniq
    end

    # Edit/Create form specific attributes
    def Model.form_attributes(*attrs)
      @extra_form_attrs = [] unless defined?(@extra_form_attrs)

      if attrs.any?
        @form_attributes = attrs.map{|a| a.to_sym}
      end
      @form_attributes ||= default_attributes

      return (@form_attributes + @extra_form_attrs).uniq
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
        @actions = actions.map(&:to_sym)
      end
      @actions ||= []
      return @actions
    end

    def Model.items_per_page(items = Upmin.configuration.items_per_page)
      return @items_per_page ||= items
    end

    def Model.display_name (name)
      return @display_name ||= name
    end


    ###########################################################
    ### Methods that need to be to be overridden. If the
    ### Model.method_name version of these are ever called it
    ### means that it wasn't overridden, or an instance of
    ### the class hasn't been created yet.
    ###########################################################

    def Model.find(*args)
      new
      return find(*args)
    end

    def Model.default_attributes
      new
      return default_attributes
    end

    def Model.attribute_type(attribute)
      new
      return attribute_type(attribute)
    end

    def Model.associations
      new
      return associations
    end

  end
end
