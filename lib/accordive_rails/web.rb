require 'erb'
require 'sinatra/base'

module AccordiveRails
  class Web < Sinatra::Base

    def root_path
      path = request.path
      return path.slice(0, path.length - request.path_info.length)
    end

    set :web_dir, File.expand_path(File.dirname(__FILE__) + "/../../web")
    set :public_folder, Proc.new { "#{web_dir}/assets" }
    set :views, Proc.new { "#{web_dir}/views" }
    set :locales, ["#{web_dir}/locales"]

    def graph
      @graph ||= AccordiveRails::Graph.new
    end

    def admin_path(model = nil, id = nil)
      path = root_path + "/admin"
      if model
        if id
          return path + "/#{model}/#{id}"
        else
          return path + "/#{model}"
        end
      else
        return path
      end
    end

    def association_path(model, id, association)
      path = root_path + "/admin/#{model}/#{id}/#{association}"
      return path
    end

    get "/admin" do
      @models = graph.models
      erb :root
    end

    get "/admin/:model" do
      page = [params[:page].to_i - 1, 0].max
      @node = graph.node(params[:model])
      @model = @node.model
      @instances = @node.paginate(page)
      erb :model_index
    end

    get "/admin/:model/:id" do
      @instance = graph.node(params[:model]).model.find(params[:id])
      erb :model_show
    end

    get "/admin/:model/:id/:association" do
      @parent_node = graph.node(params[:model])
      @parent_model = @parent_node.model
      @parent_instance = @parent_model.find(params[:id])
      if association = @parent_node.associations[params[:association]]
        # TOOD(jon): Add pagination here
        @instances = @parent_instance.send(association.method)
        @model = association.model
        @node = graph.node(@model)

        if association.collection?
          erb :model_association_collection
        else
          @instance = @instances
          erb :model_association_singular
        end
      else
        raise "Invalid association."
      end
    end

    # get "/users" do
    #   @users = graph.user.model.all.limit(25)
    #   erb :users
    # end

  end
end
