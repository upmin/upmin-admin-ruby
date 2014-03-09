require 'erb'
require 'sinatra/base'

module AccordiveRails
  class Web < Sinatra::Base

    set :web_dir, File.expand_path(File.dirname(__FILE__) + "/../../web")
    set :public_folder, Proc.new { "#{web_dir}/assets" }
    set :views, Proc.new { "#{web_dir}/views" }
    set :locales, ["#{web_dir}/locales"]

    def graph
      return @graph ||= AccordiveRails::Graph.new
    end

    # Paths
    def root_path
      path = request.path
      return path.slice(0, path.length - request.path_info.length)
    end

    def admin_path
      path = root_path + "/admin"
    end

    def model_path(model)
      return admin_path + "/#{model}"
    end

    def instance_path(model, id)
      return model_path(model) + "/#{id}"
    end

    def association_path(model, id, association)
      return instance_path(model, id) + "/association/#{association}"
    end

    def action_path(model, id, action)
      return instance_path(model, id) + "/actions/#{action}"
    end

    def perform_action_path(model, id, action)
      action_path(model, id, action) + "/perform"
    end
    # End of Paths

    # Helpers
    def plural_model(model)
      return ActiveModel::Naming.plural(model).humanize
    end

    def navbar_models
      return @plural_models ||= graph.models.map{ |m| [plural_model(m), m] }
    end
    # End of Helpers


    # Routes
    get "/admin" do
      @models = graph.models
      erb :admin
    end

    get "/admin/:model" do
      @page = [params[:page].to_i - 1, 0].max
      @node = graph.node(params[:model])
      @model = @node.model
      @instances = @node.paginate(@page)
      erb :model
    end

    get "/admin/:model/:id" do
      @node = graph.node(params[:model])
      @model = @node.model
      @instance = @model.find(params[:id])
      @actions = @node.actions
      erb :instance
    end

    get "/admin/:model/:id/association/:association" do
      @parent_node = graph.node(params[:model])
      @parent_model = @parent_node.model
      @parent_instance = @parent_model.find(params[:id])
      if association = @parent_node.associations[params[:association]]
        # TOOD(jon): Add pagination here
        @instances = @parent_instance.send(association.method)
        @model = association.model
        @node = graph.node(@model)

        if association.collection?
          erb :model
        else
          @instance = @instances
          erb :instance
        end
      else
        raise "Invalid association."
      end
    end

    get "/admin/:model/:id/actions/:action" do
      @node = graph.node(params[:model])
      @model = @node.model
      @instance = @model.find(params[:id])
      @actions = @node.actions
      @action = @actions.select{ |a| a.method_name == params[:action] }.first
      erb :action
    end

    get "/admin/:model/:id/actions/:action/perform" do
      @node = graph.node(params[:model])
      @model = @node.model
      @instance = @node.instance(id: params[:id])
      @actions = @node.actions
      @action = @actions.select{ |a| a.method_name == params[:action].to_sym }.first
      @result = @instance.perform(@action, params[:args])
      erb :action_perform
    end
    # End of Routes

  end
end
