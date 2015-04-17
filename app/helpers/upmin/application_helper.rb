module Upmin
  module ApplicationHelper
    def body_classes
      ret = []

      controller = "c-#{params[:controller].tr("_", "-").tr("upmin/", "")}"
      ret << controller

      action = "a-#{params[:action].tr("_", "-")}"
      ret << action

      if params[:klass]
        model = "m-#{params[:klass]}"
        ret << model
      end

      return ret
    end

    def body_data
      ret = {}
      ret[:controller] = params[:controller].camelize.tr("Upmin::", "")
      ret[:action] = params[:action].camelize
      return ret
    end

  end
end
