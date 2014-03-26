require 'erb'
require 'sinatra/base'
require 'sinatra/jbuilder'

module AccordiveRails
  class Web < Sinatra::Base

    set :web_dir, File.expand_path(File.dirname(__FILE__) + "/../../web")
    set :public_folder, Proc.new { "#{web_dir}/assets" }
    set :views, Proc.new { "#{web_dir}/views" }
    set :locales, ["#{web_dir}/locales"]

    # Paths
    # def root_path
    #   path = request.path
    #   return path.slice(0, path.length - request.path_info.length)
    # end

    # def admin_path
    #   path = root_path + "/admin"
    # end

    # def model_path(model)
    #   return admin_path + "/#{model}"
    # end

    # def instance_path(model, id)
    #   return model_path(model) + "/#{id}"
    # end

    # def association_path(model, id, association)
    #   return instance_path(model, id) + "/association/#{association}"
    # end

    # def action_path(model, id, action)
    #   return instance_path(model, id) + "/actions/#{action}"
    # end

    # def perform_action_path(model, id, action)
    #   action_path(model, id, action) + "/perform"
    # end
    # # End of Paths

    # # Helpers
    # def plural_model(model)
    #   return ActiveModel::Naming.plural(model).humanize
    # end

    # def navbar_models
    #   return @plural_models ||= graph.models.map { |m| [plural_model(m), m] }
    # end

    # Returns the models defined in the params, or if none exist then all models are returned
    def models_param
      ret = Set.new
      puts params[:models]
      if params[:models]
        models = params[:models].split(",").map { |m| m.strip }
        puts models.inspect
        models.each do |model|
          puts "Model is.."
          puts Model.for(model)
          ret << Model.for(model) if Model.for(model)
        end
      else
        puts "Using all"
        ret = Model.all
      end
      return ret.to_a
    end

    # Returns all attributes defined in the params, or if none exist then all attributes associated
    # to the provided models
    def attributes_param(models = [])
      ret = Set.new
      if params[:attributes]
        params[:attributes].split(",").each { |a| ret << a.strip.to_sym }
      else
        models.each do |model|
          model.support_attributes.each { |a| ret << a }
        end
      end
      return ret.to_a
    end

    # Returns the query param, or errors if it doest exist
    def query_param!
      if params[:query]
        return params[:query]
      else
        puts params.inspect
        raise "Missing parameter: query"
      end
    end

    def method_param!
      if params[:method]
        return params[:method].to_sym
      else
        raise "Missing parameter: method"
      end
    end

    def class_param!
      if params[:class]
        return params[:class].to_sym
      else
        raise "Missing parameter: class"
      end
    end

    def id_param!
      if params[:id]
        return params[:id]
      else
        raise "Missing parameter: id"
      end
    end

    def arguments_params
      if params[:arguments]
        return params[:arguments]
      else
        return {}
      end
    end

    # End of Helpers


    # Routes



    # Basic version of search, where you search for:
    # - a single @query value
    # - across one or more @models
    # - using one or more @attributes for each model.
    # In the UI this would look like:
    # a. Search <All Models> using <All Attributes> for [Search Query]
    # b. Search <Users> using <email> for [Search Query]
    #
    # TODO(jon): This may need pagination in the future, which could be annoying but it's possible.
    get "/api/search" do
      models = models_param
      attributes = attributes_param(models)
      query = query_param!

      @instances = SearchEngine.search(models, attributes, query)

      content_type(:json)
      return @instances.to_json
    end

    ## POST Version for shitty Zendesk
    post "/api/zendesk/search" do
      models = models_param
      attributes = attributes_param(models)
      query = query_param!

      @instances = SearchEngine.search(models, attributes, query)

       # Custom Zendesk work
      as_json = zendesk_flatten(@instances.as_json)
      as_json = zendesk_array(as_json)

      content_type(:json)
      return as_json.to_json
    end

    def zendesk_flatten(as_json)
      # user.associations = [api_key, plane]
      ret = []
      as_json.each do |json|
        associations = json.delete(:associations)
        ret << json
        associations.each do |key, nested_json|
          zendesk_flatten(nested_json).each { |i| ret << i }
        end
      end
      return ret
    end

    def zendesk_array(as_json)
      ret = []
      as_json.each do |json|
        ret << {
          object: json[:object],
          actions: json[:actions],
          data: json.select{|k,v| k != :object && k != :actions}.map{|k, v| [k, v]}
        }
      end
      return ret
    end

    # TODO(jon): Make this a post instead of get
    # TODO(jon): Make this support action args
    get "/api/methods/perform" do
      klass = class_param!
      id = id_param!
      @method = method_param!
      raw_arguments = arguments_params

      model = Model.for(klass)
      @instance = model.find(id)
      @arguments = @instance.format_arguments(@method, raw_arguments)
      @result = @instance.perform(@method, *@arguments)
      @instance.reload

      content_type(:json)
      return {
        instance: @instance.as_json,
        method: @method,
        arguments: @arguments.as_json,
        result: @result
      }.to_json
    end

    get "/api/methods/arguments" do
      klass = class_param!
      @method = method_param!

      model = Model.for(klass)
      @arguments = model.method_arguments(@method)

      content_type(:json)
      return {
        method: @method,
        arguments: @arguments
      }.to_json
    end

    # get "/admin" do
    #   @models = graph.models
    #   erb :admin
    # end

    # get "/admin/:model" do
    #   @page = [params[:page].to_i - 1, 0].max
    #   @node = graph.node(params[:model])
    #   @model = @node.model
    #   @instances = @node.paginate(@page)
    #   erb :model
    # end

    # get "/admin/:model/:id" do
    #   @node = graph.node(params[:model])
    #   @model = @node.model
    #   @instance = @model.find(params[:id])
    #   @actions = @node.actions
    #   erb :instance
    # end

    # get "/admin/:model/:id/association/:association" do
    #   @parent_node = graph.node(params[:model])
    #   @parent_model = @parent_node.model
    #   @parent_instance = @parent_model.find(params[:id])
    #   if association = @parent_node.associations[params[:association]]
    #     # TOOD(jon): Add pagination here
    #     @instances = @parent_instance.send(association.method)
    #     @model = association.model
    #     @node = graph.node(@model)

    #     if association.collection?
    #       erb :model
    #     else
    #       @instance = @instances
    #       erb :instance
    #     end
    #   else
    #     raise "Invalid association."
    #   end
    # end

    # get "/admin/:model/:id/actions/:action" do
    #   @node = graph.node(params[:model])
    #   @model = @node.model
    #   @instance = @model.find(params[:id])
    #   @actions = @node.actions
    #   @action = @actions.select { |a| a.method_name == params[:action] }.first
    #   erb :action
    # end

    # get "/admin/:model/:id/actions/:action/perform" do
    #   @node = graph.node(params[:model])
    #   @model = @node.model
    #   @instance = @node.instance(id: params[:id])
    #   @actions = @node.actions
    #   @action = @actions.select { |a| a.method_name == params[:action].to_sym }.first
    #   @result = @instance.perform(@action, params[:args])
    #   erb :action_perform
    # end
    # End of Routes

  end
end
