require_dependency "upmin/application_controller"

module Upmin
  class ModelsController < ApplicationController
    before_filter :set_klass, only: [:show, :update, :search, :action]
    before_filter :set_model, only: [:show, :update, :action]

    before_filter :set_page, only: [:search]

    before_filter :set_method, only: [:action]
    before_filter :set_arguments, only: [:action]

    def dashboard
    end

    # GET /:model_name/:id
    def show
    end

    # PUT /:model_name/:id
    def update
      instance = @model.instance
      updates = params[@klass.name.underscore]
      transforms = updates.delete(:transforms) || {}

      updates.each do |key, value|
        # TODO(jon): Figure out a better way to do transforms.
        #   This could cause issues and is exploitable, but it
        #   should be fine for now since this is only on admin pages
        if transforms[key] and not value.blank?
          value = transform(transforms, key, value)
        end

        instance.send("#{key}=", value)
      end

      if instance.save
        flash[:notice] = "#{@klass.humanized_name(:singular)} updated successfully."
        redirect_to(upmin_model_path(@model.path_hash))
      else
        flash.now[:alert] = "#{@klass.humanized_name(:singular)} was NOT updated."
        render(:show)
      end
    end

    def search
      @q = @klass.ransack(params[:q])
      @results = Upmin::Paginator.paginate(@q.result(distinct: true), @page, 30)
    end

    def action
      # begin
      response = @model.perform_action(params[:method], @arguments)
      flash[:notice] = "Action successfully performed with a response of: #{response}"
        redirect_to(upmin_model_path(@model.path_hash))
      # rescue Exception => e
      #   flash.now[:alert] = "Action failed with the error message: #{e.message}"
      #   render(:show)
      # end
    end

  private

      def set_klass
        @klass = Upmin::Klass.find(params[:klass])
        raise "Invalid klass name" if @klass.nil?
      end

      def set_model
        @model = @klass.find(params[:id])
      end

      def set_method
        @method = params[:method].to_sym
      end

      def set_arguments
        arguments = params[@method] || {}
        @arguments = arguments.select{|k, v| !v.empty? }
      end

      def set_page
        @page = params[:page] || 1
      end

      # TODO(jon): Figure out a better way to do transforms that is easy to extend.
      def transform(transforms, key, value)
        split = transforms[key].split('#')
        klass = eval(split[0])
        method = split[1]
        return klass.send(method, value)
      end

  end
end

