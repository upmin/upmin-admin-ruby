require_dependency "upmin/application_controller"

module Upmin
  class InstancesController < ApplicationController
    before_action :set_model, only: [:show, :update]
    before_action :set_instance, only: [:show, :update]

    def show
    end

    def update
      form_name = @model.form_name
      updates = params[form_name]
      updates.each do |key, value|
        @instance.send("#{key}=", value)
      end

      if @instance.save
        flash[:notice] = "#{params[:model_name]} updated successfully."
        redirect_to(upmin_instance_path(model_name: @model.to_s, id: @instance.id))
      else
        flash.now[:alert] = "#{params[:model_name]} was NOT updated."
        render(:show)
      end
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
