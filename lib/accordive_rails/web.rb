require 'erb'
require 'sinatra/base'

module AccordiveRails
  class Web < Sinatra::Base

    def root_path
      puts "fullpath = #{request.fullpath}"
      puts "path = #{request.path}"
      puts "path_info = #{request.path_info}"
      puts "query_string = #{request.query_string}"
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

    get "/" do
      @models = graph.nodes.map { |model, node| model }
      erb :root
    end

    get "/:model" do
      page = [params[:page].to_i - 1, 0].max
      @node = graph.node(params[:model])
      @model = @node.model
      @instances = @model.order("id").limit(25).offset(page * 25)
      erb :model_index
    end

    get "/:model/:id" do
      @instance = graph.node(params[:model]).model.find(params[:id].to_i)
      erb :model_show
    end

    # get "/users" do
    #   @users = graph.user.model.all.limit(25)
    #   erb :users
    # end

  end
end
