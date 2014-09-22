module Upmin
  class AdminModel
    include Upmin::Engine.routes.url_helpers
    include Upmin::AutomaticDelegation

    attr_reader :model
    alias_method :object, :model # For delegation

    delegate(:color, to: :class)
    delegate(:humanized_name, to: :class)
    delegate(:underscore_name, to: :class)
    delegate(:model_class_name, to: :class)

    def initialize(model = nil, options = {})
      if model.is_a?(Hash)
        unless model.has_key?(:id)
          raise ":id or model instance is required."
        end
        @model = self.class.find(model[:id])
      elsif model.nil?
        @model = self.class.model_class.new
      else
        @model = model
      end
    end

    def path
      return upmin_model_path(klass: model_class_name, id: id)
    end

    def create_path
      return upmin_create_model_path(klass: model_class_name)
    end

    def up_title
      return "#{humanized_name(:singular)} # #{id}"
    end

    def up_attributes
      attributes = []
      self.class.attributes.each do |attr_name|
        attributes << Upmin::Attribute.new(self, attr_name)
      end
      return attributes
    end











    # def color(color = nil)
    #   @color ||= color
    #   @color ||= klass.color
    #   return @color
    # end

    #############################################
    #### Methods used to customize the model ####
    #############################################

    # Add a single attribute to upmin attributes.
    # If this is called before upmin_attributes
    # the attributes will not include any defaults
    # attributes.
    def AdminModel.attribute(attribute = nil)
      @extra_attrs = [] unless defined?(@extra_attrs)
      @extra_attrs << attribute.to_sym if attribute
    end

    # Sets the attributes to the provided attributes # if any are any provided.
    # If no attributes are provided then the
    # attributes are set to the default attributes of
    # the model class.
    def AdminModel.attributes(*attributes)
      @extra_attrs = [] unless defined?(@extra_attrs)

      if attributes.any?
        @attributes = attributes.map{|a| a.to_sym}
      end

      @attributes ||= model_class.attribute_names.map{|a| a.to_sym}
      return (@attributes + @extra_attrs).uniq
    end

    # Add a single action to upmin actions. If this is called
    # before upmin_actions the actions will not include any defaults
    # actions.
    def AdminModel.action(action)
      @actions ||= []

      action = action.to_sym
      @actions << action unless @actions.include?(action)
    end

    # Sets the upmin_actions to the provided actions if any are
    # provided.
    # If no actions are provided, and upmin_actions hasn't been defined,
    # then the upmin_actions are set to the default actions.
    # Returns the upmin_actions
    def AdminModel.actions(*actions)
      if actions.any?
        # set the actions
        @actions = actions.map{|a| a.to_sym}
      end
      @actions ||= []
      return @actions
    end


    def AdminModel.find_class(model)
      return find_or_create_class(model.to_s)
    end

    def AdminModel.find_or_create_class(model_name)
      ::Rails.application.eager_load!
      return "Admin#{model_name}".constantize
    rescue NameError
      eval("class ::Admin#{model_name} < Upmin::AdminModel; end")
      return "Admin#{model_name}".constantize
    end

    # Returns all admin models.
    def AdminModel.all
      return @all if defined?(@all)
      @all = []
      Upmin::Klass.models.each do |m|
        @all << find_or_create_class(m.name)
      end
      return @all
    end

    def AdminModel.model_class
      @model_class ||= inferred_model_class
    end

    def AdminModel.model_class?
      return model_class
    rescue Upmin::UninferrableSourceError
      return false
    end

    def AdminModel.model_class
      return @model_class ||= inferred_model_class
    end

    def AdminModel.inferred_model_class
      name = model_class_name
      return name.constantize
    rescue NameError => error
      raise if name && !error.missing_name?(name)
      raise Upmin::UninferrableSourceError.new(self)
    end

    def AdminModel.model_class_name
      raise NameError if name.nil? || name.demodulize !~ /Admin.+$/
      return name.demodulize[5..-1]
    end

    def AdminModel.humanized_name(type = :plural)
      names = model_class_name.split(/(?=[A-Z])/)
      if type == :plural
        names[names.length-1] = names.last.pluralize
      end
      return names.join(" ")
    end

    def AdminModel.underscore_name
      return model_class_name.underscore
    end

    def AdminModel.model_class_path
      return Upmin::Engine.routes.url_helpers.upmin_search_path(klass: klass_name)
    end

    def AdminModel.color
      # TODO(jon)[v1.0]: Make colors dynamic again.
      return :green
    end

  end
end
