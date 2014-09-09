module Upmin
  module ApplicationHelper
    def body_classes
      ret = []

      controller = "c-#{params[:controller].gsub(/_/, "-").gsub("upmin/", "")}"
      ret << controller

      action = "a-#{params[:action].gsub(/_/, "-")}"
      ret << action

      if params[:klass]
        model = "m-#{params[:klass]}"
        ret << model
      end

      return ret
    end

    def body_data
      ret = {}
      ret[:controller] = params[:controller].camelize.gsub("Upmin::", "")
      ret[:action] = params[:action].camelize
      return ret
    end

  end
end
