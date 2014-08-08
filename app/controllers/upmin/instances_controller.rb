require_dependency "upmin/application_controller"

module Upmin
  class InstancesController < ApplicationController
    before_action :set_model, only: [:show]
    before_action :set_instance, only: [:show]

    def show
    end

    private

      # TODO(jon): Move these to a generic app_controller
      def set_model
        @model = Upmin::Model.find(params[:model_name])
      end

      def set_instance
        @instance = @model.find(params[:id])
      end
  end
end
