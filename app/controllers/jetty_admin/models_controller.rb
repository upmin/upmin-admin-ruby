require_dependency "jetty_admin/application_controller"

module JettyAdmin
  class ModelsController < ApplicationController
    before_action :set_model, only: [:updated_since]

    def list
      @models = JettyAdmin::Model.all
      respond_to do |format|
        format.html
        format.json { render json: @models.map{|m| m.to_s} }
      end
    end

    def show
      respond_to do |format|

      end
    end

    def updated_since
      @date = DateTime.parse(params[:date])
      render json: @model.updated_since(@date)
    end

    def search

    end

    private

      def set_model
        @model = JettyAdmin::Model.find(params[:model_name])
      end
  end
end
