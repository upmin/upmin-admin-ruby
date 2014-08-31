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

      transforms = updates.delete(:transforms)
      updates.each do |key, value|
        # TODO(jon): Figure out a better way to do transforms.
        #   This could cause issues and is exploitable, but it
        #   should be fine for now since this is only on admin pages
        if transforms[key]
          value = transform(transforms, key, value)
        end

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

      def transform(transforms, key, value)
        split = transforms[key].split('#')
        klass = eval(split[0])
        method = split[1]
        return klass.send(method, value)
      end
  end
end
